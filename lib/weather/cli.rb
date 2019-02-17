require 'thor'

class CLI < Thor
  desc 'weather city', 'returns weather info in city'
  option :service
  option :api_key
  def weather(city)
    w = Weather.new(options[:service], { api_key: options[:api_key] })
    info = w.weather_info_by_city(city)
    puts "city: #{info[:city]}"
  end
end
