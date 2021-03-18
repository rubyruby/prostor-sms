# ProstorSms

TODO: Write about here

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prostor_sms'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install prostor_sms

## Supported Versions

- Ruby 2.3+

## Usage

Configuration:

Add `config/prostor_sms.yml`

```
prostor_sms: &prostor_sms
  send_url: 'http://api.prostor-sms.ru/messages/v2/send.json'
  status_url: 'http://api.prostor-sms.ru/messages/v2/status.json'
  status_queue_url: 'http://api.prostor-sms.ru/messages/v2/statusQueue.json'
  balance_url: 'http://api.prostor-sms.ru/messages/v2/balance.json'
  log: 'log/prostor_sms.log'
  quantity_send_sms: 1
  cost_one_sms: 3
  enabled: false
  domain: <%= ENV['PROSTOR_SMS_DOMAIN'] %>
  login: <%= ENV['PROSTOR_SMS_LOGIN'] %>
  password: <%= ENV['PROSTOR_SMS_PASSWORD'] %>

development:
  <<: *prostor_sms

test:
  <<: *prostor_sms

staging:
  <<: *prostor_sms

production:
  <<: *prostor_sms
  enabled: true
```

Add `.env` variables

* `PROSTOR_SMS_DOMAIN`
* `PROSTOR_SMS_LOGIN`
* `PROSTOR_SMS_PASSWORD`

Usage:

Check account balance

    ProstorSms.balance

Send sms

    ProstorSms.deliver_message(text, [phone_numbers])

* `text` – message: `Your confirmation code is ABCDE`
* `phone_numbers` – array of phones: `["+79876543210", "+71234567890"]`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tab/prostor-sms. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/tab/prostor-sms/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ProstorSms project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/tab/prostor-sms/blob/master/CODE_OF_CONDUCT.md).
