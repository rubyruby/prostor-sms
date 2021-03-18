require "prostor_sms/version"

module ProstorSms
  autoload :Configuration, "prostor_sms/configuration"
  autoload :Client, "prostor_sms/client"

  extend self

  def balance
    Client.balance
  end

  def deliver_message(*args)
    Client.deliver_message(*args)
  end

  def deliver_status(*args)
    Client.deliver_status(*args)
  end

end
