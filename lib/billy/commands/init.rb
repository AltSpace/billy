require 'billy/commands'

class Billy
  class Commands
    class Init
      
      def proceed!( arguments = nil )
        ( path = arguments.shift ) unless arguments.nil?
        if path.nil? || path.empty?
          print "Billy will be initialized in current directory. Proceed?(y/n)"
          confirm = gets
          exit 1 unless confirm.downcase.strip == "y"
        end
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