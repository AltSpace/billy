require 'billy/commands/command'

class Billy
  class Commands
    class Eat < Command
      
      def proceed!( arguments = nil )
        ( path = arguments.shift ) unless !arguments.nil?
      end
      
    end
  end
end