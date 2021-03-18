require 'open-uri'
require 'oj'
require 'multi_json'

module ProstorSms
  class Client

    @result_send = []

    class << self
      attr_reader :result_send

      def balance
        h = {
          login: login,
          password: password
        }
        result = call_post(configuration.balance_url, Oj.dump(h, {mode: :custom}))
        configuration.logger('BALANCE SMS', result)
        sms_balance(result)
      end

      def deliver_message(message, phone_numbers = [])
        return unless phone_numbers.present?

        publish_message(h_messages(message, phone_numbers))
        configuration.logger('DEBUG', "#{phone_numbers.first} #{message}")
      end

      def deliver_status(smsc_id)
        call_post(configuration.status_url, h_payload(h_status_messages(smsc_id)))
      end

      private

      def h_messages(message, phone_numbers)
        phone_numbers.map do |phone_number|
          number = phone_number.gsub(/\D/, '')
          {
            phone: "+#{number}",
            sender: configuration.domain,
            clientId: number,
            text: message
          }
        end.uniq { |e| e[:phone] }
      end

      def h_payload(messages)
        h = {
          messages: messages,
          showBillingDetails: true,
          login: login,
          password: password
        }

        Oj.dump(h, {mode: :custom})
      end

      def result_request(response)
        result = MultiJson.load(response.body)
        logger('RESULT SMS', result)
        result
      end

      def call_post(path, payload)
        uri = URI.parse(path)
        logger('REQUEST SMS', path)
        header = { 'Content-Type': 'text/json' }

        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri, header)
        request.body = payload
        logger('PAYLOAD SMS', payload)

        response = http.request(request)
        puts response.inspect

        if response.code == '200'
          result = result_request(response)
        else
          logger('CRASH SMS', 'ERROR!')
          result = MultiJson.load('{"status": "error"}')
        end
        result
      end

      def h_status_messages(smsc_id)
        [{ smscId: smsc_id.to_s }]
      end

      def sms_balance(result)
        return result.dig('balance', 0, 'balance').to_i.round if result.dig('status') == 'ok'.downcase
        0
      end

      # return quantity sended sms
      def publish_message(dump_json)
        return unless sending_enabled?

        send_sms = 0
        all_sms = dump_json.length
        count_sms_send = balance / configuration.cost_one_sms

        if count_sms_send < all_sms
          logger('SMS_NOT_SEND', "Sms wasn't sent! Balance:#{balance}, sms: #{all_sms}")
          return 0
        end

        # send quantity sms
        dump_json.each_slice(configuration.quantity_send_sms) do |e|
          next if count_sms_send < all_sms

          result = call_post(configuration.send_url, h_payload(e))
          @result_send.push(result)
          count_sms_send = sms_balance(result) / configuration.cost_one_sms
          send_sms += configuration.quantity_send_sms
          all_sms -= configuration.quantity_send_sms
        end

        logger('ALL_SMS_NOT_SEND', "All sms weren't sent! balance:#{balance}, sms not send: #{all_sms}") if all_sms.positive?

        send_sms
      end

      def sending_enabled?
        configuration.enabled?
      end

      def login
        @login ||= configuration.login.to_s
      end

      def password
        @password ||= configuration.password.to_s
      end

      def logger
        @logger ||= configuration.logger
      end

      def configuration
        @configuration ||= Configuration.new
      end
    end

  end
end