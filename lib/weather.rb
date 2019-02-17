require 'weather/version'
require 'httparty'
require 'json'

class Weather
  SERVICES = { 'apixu' => ApixuWeatherService }.freeze

  attr_reader :weather_service

  def initialize(service_name, options)
    @weather_service = SERVICES.fetch(service_name, DefaultWeatherService).new(options)
  end

  def weather_info_by_city(city)
    weather_service.weather_info_by_city(city)
  end
end

class WeatherService
  attr_reader :http_client, :api_key

  def initialize(options)
    @http_client = options[:http_client] || HttpClient.new
    @api_key = options[:api_key] || ''
  end
end

class ApixuWeatherService < WeatherService
  API_URL = 'http://api.apixu.com/v1/current.json'.freeze

  def weather_info_by_city(city)
    html = http_client.get("#{API_URL}?key=#{api_key}&city=#{city}")
    info = JSON.parse(html, symbolize_names: true)
    { city: info[:location].downcase }
  end
end

class DefaultWeatherService < WeatherService
  API_URL = ''.freeze

  def weather_info_by_city(city)
    ''
  end
end

class HttpClient
  def get(url)
    HTTParty.get(url).body
  end
end
