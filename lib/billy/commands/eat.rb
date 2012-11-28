require 'uri'
require 'net/http'
require 'billy/commands/command'

class Billy
  class Commands
    class Eat < Command
      
      def proceed!( arguments )
        ( path = arguments.shift ) unless arguments.nil?
        begin
          if path.nil? || path.empty?
            raise "No config path given. \nYou have to provide some settings path, e.g. in your local filesystem or direct link to blob file in repository etc.\n"
          elsif uri?( path ) && ( result = load_remote_config( path ) ).nil?
            raise "Remote config file could not be loaded"
          elsif file?( path ) && ( !File.exists?( path ) || ( result = File.read( path ) ).nil? )
            raise "Config File not found: #{path}"
          end
        rescue Exception => e
          print e.message
          exit 1
        end
        eat_config( result )
        save_config
      end
      
      def eat_config( config_string )
        Billy::Config.instance.eat_string_config( config_string )
      end
      
      def save_config
        print "Parsed config data:\n"
        Billy::Config.settings.each_pair do |k, v|
          print "#{k}: #{v}\n"
        end
        print "Save this settings?(y/n): "
        confirm = get_confirmation
        if !confirm
          print "Billy didn't save config file. Skipping\n"
          exit 1
        end
        Billy::Config.save
        print "Billy saved config file to #{Billy::Config::BILLYRC}\n"
        exit 0
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