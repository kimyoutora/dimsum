require 'net/http'
require 'uri'
require 'json'
require 'openssl'

#"lat" : 37.75,
#"lng" : -122.43
url = "https://maps.googleapis.com/maps/api/place/search/json?location=37.75,-122.43&radius=200&name=walgreens&keyword=pharmacy&sensor=false&key=AIzaSyBbwI24flYLtaYgjzPhydunHVhTbgg15Zo"
uri = URI(url)
response = Net::HTTP.start(uri.host, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
  http.get(uri.request_uri)
end

case response
when Net::HTTPSuccess
  output = response.body
  puts JSON.parse(output)["results"].first["vicinity"]
#  JSON.parse(output)["results"].first["items"].each do |supermarket|
  #  puts supermarket
  #end
else
  pp response.error!
end
