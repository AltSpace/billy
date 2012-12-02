module Billy
  module Util
    class UI
      
      class << self
        
        def colorize( text, color_code )
          "#{color_code}#{text}e[0m"
        end

        def red( text )
          colorize( text, "e[31m" )
        end
        
        def green( text )
          colorize( text, "e[32m" )
        end
        
        def confirm?( msg = nil )
          inform( msg ) if !msg.nil?
          gets.chomp.downcase == "y"
        end
        
        def inform( msg )
          print "#{msg.to_s}\n"
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