require 'colorize'

module Billy
  module Util
    class UI
      
      class << self
        
        def red( text )
          text.red
        end
        
        def green( text )
          text.green
        end
        
        def input
          gets.chomp.downcase
        end
        
        def confirm?( msg = nil )
          inform( msg ) if !msg.nil?
          input == "y"
        end
        
        def inform( msg )
          puts "#{msg.to_s}\n"
        end
        
        def succ( msg )
          inform green msg
        end
        
        def err( msg )
          inform red msg
        end
        
      end
      
    end
  end
end