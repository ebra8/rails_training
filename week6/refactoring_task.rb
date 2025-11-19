# Broken SOLID principles:

# 1. SRP: InvoiceProcessor class is performing more than one job at the same time, 
# its processing payments(:113-121), calculating taxes(:107-111), logging invoices to files(:123-125) and sending emails(:127)

# 2. OCP: Adding new country or tax logic, or new payment method, or changing logging logic 
# requires modifications on the class as a whole, so its not open for extension and hard to maintain

# 3. ISP: Using this class forces to depend on cluttered methods thats not always used,
# this violates ISP as it has no interfaces that segregate each method for convenient and testable structure

# 4. DIP: The class is not depending on abstractions, rather its depending on concrete implementations,
# its depending directly on file system(:123) and hardcoded conditionals(:107-121)

# 5. LSP is not directly violated, but inhereting this class would require much more hustle than building it
# just to maintain the substitutions and its logic without issues

# ===============================

# The following changes fixes the problems by:

# 1. Allowing each class to have only one matter or purpose.
# 2. Allowing the module to extend by adding new classes/configurations without modifying existing code.
# 3. Allowing each PaymentMethod, Logger, Notifier subclass to be used interchangeably without conflects.
# 4. Allowing classes to only implement the methods they need/use.
# 5. Allowing InvoiceProcessor class to depend on abstractions and dependency injection rather than hard-coded dependencies.
# 6. Allowing each part of the module to be testable in order to detect flaws.

# ===============================

# Refactored code:

class PaymentMethod
  def process(amount)
    raise NotImplementedError, "Subclasses must implement 'process'"
  end
  
  def name
    raise NotImplementedError, "Subclasses must implement 'name'"
  end
end

class Logger
  def log(message)
    raise NotImplementedError, "Subclasses must implement 'log'"
  end
end

class Notifier
  def send_notification(user, message)
    raise NotImplementedError, "Subclasses must implement 'send_notification'"
  end
end

class VisaPayment < PaymentMethod
  def process(amount)
    { success: true, method: name, amount: amount }
  end
  
  def name
    "VISA"
  end
end

class PayPalPayment < PaymentMethod
  def process(amount)
    { success: true, method: name, amount: amount }
  end
  
  def name
    "PayPal"
  end
end

class CashPayment < PaymentMethod
  def process(amount)
    { success: true, method: name, amount: amount }
  end
  
  def name
    "CASH"
  end
end

class TaxCalculator
  TAX_RATES = {
    "EG" => 0.14,
    "US" => 0.20,
    "UK" => 0.20,
    "default" => 0.20
  }.freeze
  
  def calculate(subtotal, country_code)
    rate = TAX_RATES[country_code] || TAX_RATES["default"]
    subtotal * rate
  end
end

class InvoiceCalculator
  def initialize(tax_calculator)
    @tax_calculator = tax_calculator
  end
  
  def calculate_subtotal(items)
    items.reduce(0) do |sum, item|
      sum + (item[:price] * item[:quantity])
    end
  end
  
  def calculate_total(items, country_code)
    subtotal = calculate_subtotal(items)
    tax = @tax_calculator.calculate(subtotal, country_code)
    subtotal + tax
  end
end

class FileLogger < Logger
  def initialize(filename = "invoice_log.txt")
    @filename = filename
  end
  
  def log(message)
    File.open(@filename, "a") do |f|
      f.puts "[#{Time.now}] #{message}"
    end
  end
end

class ConsoleLogger < Logger
  def log(message)
    puts "[LOG] #{message}"
  end
end

# for testing
class NullLogger < Logger
  def log(message)
  end
end

class EmailNotifier < Notifier
  def send_notification(user, message)
    # this would usually use a mailer service
    # puts "Email sent to #{user.email}: #{message}"
  end
end

class SmsNotifier < Notifier
  def send_notification(user, message)
    # puts "SMS sent to #{user.phone}: #{message}"
  end
end

# for testing
class NullNotifier < Notifier
  def send_notification(user, message)
  end
end

class InvoiceProcessor
  def initialize(calculator, logger, notifier)
    @calculator = calculator
    @logger = logger
    @notifier = notifier
  end
  
  def process(user, items, payment_method)
    total = @calculator.calculate_total(items, user.country)
    
    payment_result = payment_method.process(total)
    
    unless payment_result[:success]
      raise "Payment failed"
    end
    
    @logger.log("User: #{user.name}, Total: #{total}, Method: #{payment_result[:method]}")
    
    @notifier.send_notification(user, "Thanks for your purchase! Total: #{total}")
    
    {
      total: total,
      payment_method: payment_result[:method],
      user: user.name
    }
  end
end

require 'ostruct'

tax_calculator = TaxCalculator.new
invoice_calculator = InvoiceCalculator.new(tax_calculator)
logger = ConsoleLogger.new
notifier = EmailNotifier.new
processor = InvoiceProcessor.new(invoice_calculator, logger, notifier)



# mocking flow for one user paying with Visa
user = OpenStruct.new(
  name: "Ali",
  country: "EG",
  email: "ali@example.com"
)

items = [
  { price: 40, quantity: 3 },
  { price: 30, quantity: 4 }
]

payment = VisaPayment.new 

result = processor.process(user, items, payment)
# puts "\nInvoice Result: #{result}"




# mocking a test without logging and notifying 
test_processor = InvoiceProcessor.new(
  invoice_calculator,
  NullLogger.new,
  NullNotifier.new
)

test_result = test_processor.process(user, items, PayPalPayment.new)
# puts "Test Result: #{test_result}"