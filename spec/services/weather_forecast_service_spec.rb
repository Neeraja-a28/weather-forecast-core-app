require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WeatherForecastService do
  let(:zip) { '10001' }
  let(:country_code) { 'US' }
  let(:cache_key) { "forecast_#{zip}" }

  let(:base_url) { WeatherForecastService::BASE_URL }
  let(:api_key) { WeatherForecastService::API_KEY }

  let(:api_url) { "#{base_url}?zip=#{zip},#{country_code}&appid=#{api_key}&units=metric" }

  let(:api_response_body) {
    {
      "cod" => 200,
      "weather" => [{ "main" => "Clear" }],
      "main" => { "temp" => 25 }
    }.to_json
  }

  before do
    Rails.cache.clear
  end

  describe '.fetch_forecast' do
    context 'when the cache is empty' do
      it 'fetches the forecast from the API and stores it in cache' do
        stub_request(:get, api_url).to_return(status: 200, body: api_response_body)

        result = described_class.fetch_forecast(zip, country_code)

        expect(result).to be_a(Hash)
        expect(result["weather"].first["main"]).to eq("Clear")
        expect(Rails.cache.exist?(cache_key)).to be true
      end
    end

    context 'when the data is cached' do
      it 'returns the cached forecast without calling the API' do
        Rails.cache.write(cache_key, { "cached" => true })

        expect(Net::HTTP).not_to receive(:get_response)

        result = described_class.fetch_forecast(zip, country_code)
        expect(result).to eq({ "cached" => true })
      end
    end

    context 'when the API response is an error' do
      it 'returns nil and logs the error' do
        stub_request(:get, api_url).to_raise(StandardError.new("Network issue"))

        expect(Rails.logger).to receive(:error).with(/Weather API error: Network issue/)

        result = described_class.fetch_forecast(zip, country_code)
        expect(result).to be_nil
      end
    end

    context 'when API returns a non-200 code in body' do
      it 'returns nil' do
        stub_request(:get, api_url).to_return(status: 200, body: { "cod" => 404 }.to_json)

        result = described_class.fetch_forecast(zip, country_code)
        expect(result).to be_nil
      end
    end
  end

  describe '.cached?' do
    it 'returns true if cache exists' do
      Rails.cache.write(cache_key, "test")
      expect(described_class.cached?(zip)).to be true
    end

    it 'returns false if cache does not exist' do
      expect(described_class.cached?(zip)).to be false
    end
  end
end
