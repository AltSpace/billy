require 'billy/commands'

class Billy
  class Commands
    class Command
      
      def name
        self.class.to_s.split( "::" ).last.downcase
      end
      
      protected
      
      def initialize
      end
      
      def get_confirmation
        gets.chomp.downcase == "y"
      end
      
      class << self
        
        attr_accessor :_instance
        
        def instance
          self._instance ||= self.new
        end
        
        def register_self!
          Billy::Commands.register_command!( instance )
        end
        
      end
      
    end
  end
end