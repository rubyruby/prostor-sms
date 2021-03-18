require 'yaml'

module ProstorSms

  class Configuration
    attr_reader :domain, :send_url, :status_url, :balance_url,
                :login, :password, :quantity_send_sms, :cost_one_sms,
                :logger

    def initialize
      load_config
    end

    def domain
      @config.dig(:domain)
    end

    def send_url
      @config.dig(:send_url)
    end

    def status_url
      @config.dig(:status_url)
    end

    def balance_url
      @config.dig(:balance_url)
    end

    def login
      @config.dig(:login)
    end

    def password
      @config.dig(:password)
    end

    def quantity_send_sms
      @config.dig(:quantity_send_sms)
    end

    def cost_one_sms
      @config.dig(:cost_one_sms)
    end

    def enabled?
      @config.dig(:enabled) || false
    end

    def logger(tag, text)
      @logger.tagged(tag) { @logger.info dt_log(text) }
    end

    private

    def load_config
      @config = {}
      filename = Rails.root.join('config', 'prostor_sms.yml')
      return unless filename.exist?

      yaml = YAML.load(ERB.new(File.read(filename)).result)[Rails.env.to_s]
      raise ArgumentError, "The #{Rails.env} environment does not exist in #{filename}" if yaml.nil?
      yaml.each { |k, v| @config[k.to_sym] = v }
      @logger = ActiveSupport::TaggedLogging.new(Logger.new(@config[:log]))
    end

    def dt_log(txt)
      "#{Time.current.strftime('%Y-%m-%d %H:%M:%S')} #{txt}"
    end
  end

end