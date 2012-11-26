require 'billy/commands'

class Billy
  class Commands
    class Init
      
      def proceed!( arguments )
        
      end
      
      protected
      
      def initialize
        
      end
      
      class << self
        
        def instance
          @@instance ||= self.new
        end
        
        def register_self!
          Billy::Commands.register_command!( instance )
        end
        
      end
    end
  end
end

Billy::Commands::Init.register_self!