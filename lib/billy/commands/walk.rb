require 'billy/commands/command'
require 'capistrano/configuration'

class Billy
  class Commands
    class Walk < Command
      
      def proceed!( arguments = nil )
        if !Billy::Config.load
          print "Billy config could not be found. Say Billy hello."
          exit 1
        end
        config = capistrano_config
      end
      
      def capistrano_config
        Capistrano::Configuration.new( Billy::Config.settings )
      end
      
    end
  end
end

Billy::Commands::Walk.register_self!