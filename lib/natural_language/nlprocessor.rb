require 'chronic'
require 'nickel'
require File.join(File.dirname(__FILE__), 'categories')

module NLProcessor
  class TaskStruct
    attr_reader :message, :occurrences

    def initialize(msg)
      @message = msg
      @occurrences = []
    end
  end

  class Task
    attr_reader :name, :start, :location, :category

    def initialize(name)
      @original_name = name
      parse!
    end

    private

    def parse!
        @processed_task   = Nickel.parse(@original_name, Time.now) rescue TaskStruct.new(@name)
        @name             = @processed_task.message

      set_metadata!
      set_location!
    end

    def set_metadata!
      set_start_time!
    end

    def set_start_time!
      unless @processed_task.occurrences.empty?
        occurrence = @processed_task.occurrences.first
        if occurrence.type == :single
          @start = Time.parse("#{occurrence.start_date} #{occurrence.start_time}")
        end
      end
    end

    def set_location!
      sentence_parts = @name.split(/\sfrom|\sat/)
      if sentence_parts.size > 1
        location = sentence_parts.last.gsub(/^\s*the|a\s+/, "")
        if Categories.has_type?(location)
          @category = Categories.find_type(location)
        else
          @location = location
        end
      end
      @name = sentence_parts.first
    end
  end
end
