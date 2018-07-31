require 'delivery_boy'

DeliveryBoy.configure do |config|
  config.brokers = ["192.168.42.45:9092"]
end
