# README
This is a simple Ruby on Rails application that accepts a user-inputed address and returns weather forecast information for that location. It also caches the results by zip code to improve performance and reduce API calls.

Features Implemented:
✅ Accept an address (street, city, state, zip, country code) as input
✅ Retrieve weather forecast using an external API (WeatherForecastService)
✅ Display forecast details to the user
✅ Cache weather forecast results by zip code for 30 minutes
✅ Show a message indicating whether data is pulled from cache

How It Works :
Controller Logic (LocationsController)
- index: Displays a list of all saved locations
- new: Presents a form for user to input a new location
- create: Saves the location and redirects to its forecast
- show: 
  - Finds location by ID
  - Calls the WeatherForecastService to fetch forecast based on zip and country code
  - Checks if the result is served from cache using cached? method

Weather Forecast Service: 
Responsible for:
- Fetching weather data from an external API (e.g., OpenWeatherMap)
- Caching results for 30 minutes using the zip code as the cache key

Openweathermap Account:
- Sign up for an openweathermap Account. Go to https://openweathermap.org/
- Create a .env file in the project root directory
  -  WEATHER_API_KEY=your_api_key_here

Getting Started:
1. Clone the repo
2. Run bundle install
3. Setup database: rails db:migrate
4. Start the server: rails server
5. Visit http://localhost:3000/locations to input an address
