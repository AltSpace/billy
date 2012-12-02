require 'billy/commands/command'
require 'billy/util/ui'

module Billy
  class Commands
    class Config < Command
      
      def proceed!( arguments = nil )
        dir = Dir.pwd
        if !Billy::Config.config_exists?( dir )
          Billy::Util::UI.err "Billy config file could not be found here. Say Billy hello."
          exit 1
        else
          Billy::Config.load!( dir )
          Billy::Util::UI.inform "Current Billy settings:"
          Billy::Config.settings.each_pair do |k, v|
            Billy::Util::UI.inform "#{k}:\t\t\t#{v}"
          end
        end
      end
      
    end
  end
end

Billy::Commands::Config.register_self!