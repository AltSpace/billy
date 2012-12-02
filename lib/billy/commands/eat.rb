require 'uri'
require 'net/http'
require 'billy/commands/command'

module Billy
  class Commands
    class Eat < Command
      
      def proceed!( arguments )
        ( path = arguments.shift ) unless arguments.nil?
        begin
          if path.nil? || path.empty?
            raise "No config path given. \nYou have to provide some settings path, e.g. in your local filesystem or direct link to blob file in repository etc."
          elsif uri?( path ) && ( result = load_remote_config( path ) ).nil?
            raise "Remote config file could not be loaded"
          elsif file?( path ) && ( !File.exists?( path ) || ( result = File.read( path ) ).nil? )
            raise "Config File not found: #{path}"
          end
        rescue Exception => e
          Billy::Util::UI.err e.message
          exit 1
        end
        eat_config( result )
        save_config
      end
      
      def eat_config( config_string )
        Billy::Config.instance.eat_string_config( config_string )
      end
      
      def save_config
        Billy::Util::UI.inform "Parsed config data:"
        Billy::Config.settings.each_pair do |k, v|
          Billy::Util::UI.inform "#{k}: #{v}"
        end
        if !Billy::Util::UI.confirm? "Save this settings?(y/n): "
          Billy::Util::UI.inform "Billy didn't save config file. Skipping."
          exit 1
        end
        Billy::Config.save
        Billy::Util::UI.succ "Billy saved config file to #{Billy::Config::BILLYRC}"
      end
      
      def uri?( str )
        begin
          uri = URI.parse( str )
          %w( http https ).include?( uri.scheme )
        rescue
          false
        end
      end
      
      def file?( str )
        !uri?( str )
      end
      
      def load_remote_config( path )
        uri = URI( path )
        Net::HTTP.get( uri )
      end
      
    end
  end
end

Billy::Commands::Eat.register_self!