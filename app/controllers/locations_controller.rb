class LocationsController < ApplicationController
  def index
    @locations = Location.all
  end

  def show
    @location = Location.find_by(id: params[:id])

    # Call weather API here based on location 
    @forecast = WeatherForecastService.fetch_forecast(@location.zip, @location.country_code)

    @from_cache = WeatherForecastService.cached?(@location.zip)
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.create(location_params)

    if @location.save
      redirect_to @location
    else
      render :new
    end
  end

  def location_params
    params.require(:location).permit(:street, :city, :state, :country_code, :zip)
  end
end
