require 'net/http'
require 'uri'
require 'json'
require 'openssl'
require 'ostruct'

module Ext
  class GoogleMaps
    URL = "https://maps.googleapis.com/maps/api/place/search/json?"
    # URL_APPEND_QUERY = "&sensor=false&key=#{GOOGLE_MAPS_API_KEY}"
    def self.venue(lat_long, venue_name, category=nil)
      uri = URI(URL)
      uri.query = "location=#{lat_long}&radius=500&" << URI.encode_www_form([["name", venue_name]]) 
      if category
        uri.query << "&" << URI.encode_www_form([["keyword", category]])
      end
      uri.query << URL_APPEND_QUERY
      puts uri
      begin
        response = Net::HTTP.start(uri.host, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
          http.get(uri.request_uri)
        end

        case response
        when Net::HTTPSuccess
          output = JSON.parse(response.body)["results"].first
          if output
            return OpenStruct.new(:name => output["name"], :vicinity => output["vicinity"])
          end
        else
          Rails.logger.error(response.error!)
        end
      rescue Exception => ex
        Rails.logger.error "Received: #{ex.message}"
        Rails.logger.error ex.backtrace
      end
    end
  end
end
