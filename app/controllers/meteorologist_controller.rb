require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]

    # ==========================================================================
    # Your code goes below.
    #
    # The street address that the user typed is in the variable @street_address.
    # ==========================================================================

    @street_address_parsed = @street_address.gsub(" ","+")

    @url_maps = "http://maps.googleapis.com/maps/api/geocode/json?address="

    parsed_data_maps = JSON.parse(open(@url_maps+@street_address_parsed).read)

    @latitude = parsed_data_maps["results"][0]["geometry"]["location"]["lat"]

    @longitude = parsed_data_maps["results"][0]["geometry"]["location"]["lng"]

    url_cast = "https://api.darksky.net/forecast/7fb23f704e62590627e6994f6cc92050/"
    #
    latitude_comma=@latitude.to_s+","
    #
    longitude_end=@longitude.to_s
    #
    parsed_data_cast_with_map_address = JSON.parse(open(url_cast+latitude_comma+longitude_end).read)

    @current_temperature = parsed_data_cast_with_map_address["currently"]["temperature"]
    #
    @current_summary = parsed_data_cast_with_map_address["currently"]["summary"]
    #
    @summary_of_next_sixty_minutes = parsed_data_cast_with_map_address["minutely"]["summary"]
    #
    @summary_of_next_several_hours = parsed_data_cast_with_map_address["hourly"]["summary"]
    #
    @summary_of_next_several_days = parsed_data_cast_with_map_address["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
