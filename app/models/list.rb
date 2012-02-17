class List < ActiveRecord::Base
  has_many :items

  before_create :pass_through_nlp

  VOICES = ["Albert","Bad News","Bahh","Bells","Boing","Cellos","Deranged","Pipe Organ","Trinoids","Whisper","Zarvox"]

  def self.by_lat_long(lat, long)
    matches = []
    List.all.each do |list|
      place = Ext::GoogleMaps.venue("#{lat},#{long}", list.location, list.category)
      unless place.nil?
        matches << [list, place]
        display_text = "You are near #{place.name}. You had to #{list.subject}"
        # IO.popen("say -v #{VOICES.sample} -o #{Rails.public_path}/audio/#{list.id}.mp4 #{display_text}")
      end
    end
    unless matches.empty?
      last_list = matches.last.first
      last_place = matches.last.last
      display_text = "You are near #{last_place.name}. You had to #{last_list.subject}"
      # IO.popen("say -v Hysterical -o #{Rails.public_path}/audio/#{last_list.id}.mp4 #{display_text}")
    end
    sleep 1
    return matches
  end

  private

  def pass_through_nlp
    t = NLProcessor::Task.new(self.original_text)
    self.subject = t.subject
    self.location = t.location
    self.category = t.category
  end

end
