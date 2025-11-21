class NotificationType
  def send(message)
    raise NotImplementedError, "Subclass must implement 'send'"
  end
end

class Email < NotificationType
  def send(message)
    puts "Sending Email: #{message}"
  end
end

class SMS < NotificationType
  def send(message)
    puts "Sending SMS: #{message}"
  end
end


class Push < NotificationType
  def send(message)
    puts "Sending Push: #{message}"
  end
end

class Notification
  def initialize(type)
    @type = type
  end

  def send(message)
    @type.send(message)
  end
end

push = Push.new
pushNotifier = Notification.new(push)
pushNotifier.send("*Push message*")

sms = SMS.new
smsNotifier = Notification.new(sms)
smsNotifier.send("*SMS message*")