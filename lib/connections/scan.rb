require 'rubygems'
require 'activeresource'
module Rhessus
  class Scan < ActiveResource::Base
    class << self
      def checkout
        new.tap do |x|
          begin
            x.load(format.decode(post(:checkout).body))
            puts self
            x.should_fire = true
          rescue Exception => e
	    puts e
            x.should_fire = false
          end
        end
      end
    end
    
    def checkin(result_string)
      self.results = ::Rhessus.parse_results(result_string)
      puts "Attemping to checkin"
      post(:checkin) 
    end
    
    def failure
      post(:failure)
    end
    
    def should_fire?
      @should_fire
    end
    
    def should_fire=(x)
      @should_fire = x
    end
  end
end
