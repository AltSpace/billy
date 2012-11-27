require 'billy/commands/command'

class Billy
  class Commands
    class Walk < Command
      
      def proceed!( arguments )
        
      end
      
    end
  end
end

Billy::Commands::Walk.register_self!