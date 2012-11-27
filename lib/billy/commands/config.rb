require 'billy/commands/command'

class Billy
  class Commands
    class Config < Command
      
      def proceed!( arguments = nil )
        dir = Dir.pwd
        if !Billy::Config.config_exists?( dir )
          print "Billy config file could not be found here. Say Billy hello."
          exit 1
        else
          Billy::Config.load!( dir )
          print "Current Billy settings: \n"
          Billy::Config.settings.each_pair do |k, v|
            print "#{k}:\t\t\t#{v}\n"
          end
        end
      end
      
    end
  end
end

Billy::Commands::Config.register_self!