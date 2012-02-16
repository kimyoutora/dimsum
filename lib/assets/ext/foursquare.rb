require 'net/http'
require 'uri'
require 'json'
require 'openssl'

module Ext
  class Foursquare
    URL = "https://api.foursquare.com/v2/venues/search?"
    # URL_APPEND_QUERY = "&intent=match&oauth_token=#{FOURSQUARE_OAUTH_TOKEN}&v=#{Time.now.strftime('%Y%m%d')}"
    def self.at_venue?(lat_long, venue_name)
      uri = URI(URL)
      uri.query = "ll=#{lat_long}&" << URI.encode_www_form([["query", venue_name]]) << URL_APPEND_QUERY
      begin
        response = Net::HTTP.start(uri.host, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
          http.get(uri.request_uri)
        end

        case response
        when Net::HTTPSuccess
          output = JSON.parse(response.body)
          return output["response"]["venues"].size > 0
        else
          puts (response.error!)
          return false
          #logger.error(response.error!)
        end
      rescue Exception => ex
        puts "Received: #{ex.message}"
        puts ex.backtrace
        return false
      end
    end
  end
end
