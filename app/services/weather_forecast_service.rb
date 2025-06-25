class WeatherForecastService
  API_KEY = ENV['WEATHER_API_KEY'] 
  BASE_URL = "https://api.openweathermap.org/data/2.5/weather" # endpoint for OpenWeatherMap’s current weather

  def self.fetch_forecast(zip, country_code)
    Rails.cache.fetch("forecast_#{zip}", expires_in: 30.minutes) do  # checks if forecast data already exists in the cache for the ZIP code.
      begin
        uri = URI("#{BASE_URL}?zip=#{zip},#{country_code}&appid=#{API_KEY}&units=metric") # make API request
        response = Net::HTTP.get_response(uri)

        return nil unless response.is_a?(Net::HTTPSuccess)

        data = JSON.parse(response.body)

        return nil if data["cod"] != 200 # OpenWeatherMap returns `"cod" => 200` on success

        data
      rescue => e
        Rails.logger.error("Weather API error: #{e.message}")
        nil
      end
    end
  end

  def self.cached?(zip)
    Rails.cache.exist?("forecast_#{zip}")
  end
end
