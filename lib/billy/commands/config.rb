require 'colorize'
require 'billy/commands/command'
require 'billy/util/ui'

module Billy
  class Commands
    class Config < Command
      
      def proceed!( arguments = nil )
        %w(. ~).each do |f|
          dir = File.expand_path( f )
          next unless Billy::Config.config_exists?( dir )
          Billy::Util::UI.inform "Config loaded from file: #{dir}/#{Billy::Config::BILLYRC}"
          Billy::Config.load!( dir )
          Billy::Util::UI.inform "Current Billy settings:"
          Billy::Config.settings.each_pair do |k, v|
            yellow_k = "#{k}".yellow
            Billy::Util::UI.inform "#{yellow_k}:\t\t#{v.blue}"
          end
          return
        end
        
        Billy::Util::UI.err "Billy config file could not be found here. Say Billy hello."
        exit 1
        
      end
      
    end
  end
end

Billy::Commands::Config.register_self!