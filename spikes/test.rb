require 'net/http'
require 'uri'
require 'json'
require 'openssl'

#"lat" : 37.75,
#"lng" : -122.43
url = "https://api.foursquare.com/v2/venues/search?ll=37.75,-122.43&query=whole+foods&intent=match&oauth_token=NGRXLIRVOWOHCQENLOKOELLSTC5YX3QJIPJ3QFSQXSQ51SF2&v=20120214"
#url = "https://api.foursquare.com/v2/venues/search?ll=37.75,-122.43&query=whole+foods&intent=match&oauth_token=NGRXLIRVOWOHCQENLOKOELLSTC5YX3QJIPJ3QFSQXSQ51SF2"
uri = URI(url)
response = Net::HTTP.start(uri.host, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
  http.get(uri.request_uri)
end

case response
when Net::HTTPSuccess
  output = response.body
  puts JSON.parse(output)["response"]["venues"].first
  #JSON.parse(output)["response"]["groups"].first["items"].each do |supermarket|
  #  puts supermarket
  #end
else
  pp response.error!
end
