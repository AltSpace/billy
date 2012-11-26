require 'billy/commands/command'

class Billy
  class Commands
    class Eat < Command
      
      def proceed!( arguments = nil )
        ( path = arguments.shift ) unless arguments.nil?
        raise "No config path given. \n\nYou have to provide some settings path, e.g. in your local filesystem or direct link to blob file in repository etc.\n" unless path.nil? || path.empty?
      end
      
    end
  end
end

Billy::Commands::Eat.register_self!