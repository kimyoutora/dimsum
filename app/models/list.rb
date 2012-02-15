require 'assets/ext/google_maps'
class List < ActiveRecord::Base
  has_many :items

  def self.by_lat_long(lat, long)
    matches = []
    venues.each do |venue_name|
      place = Ext::GoogleMaps.venue("#{lat},#{long}", venue_name)
      unless place.nil?
        matches << [List.where(:location => venue_name).first, place]
      end
    end
    return matches
  end

  private
  def self.venues
    List.all.collect(&:location)
  end

end
