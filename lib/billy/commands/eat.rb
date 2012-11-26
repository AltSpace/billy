require 'uri'
require 'net/http'
require 'billy/commands/command'

class Billy
  class Commands
    class Eat < Command
      
      def proceed!( *arguments )
        ( path = arguments.shift ) unless arguments.nil?
        raise "No config path given. \n\nYou have to provide some settings path, e.g. in your local filesystem or direct link to blob file in repository etc.\n" unless !path.nil? && !path.empty?
        raise "Remote config file could not be loaded" unless !uri?( path ) || ( result = load_remote_config( path ) ).nil?
        raise "Config File not found: #{path}" unless file?( path ) && File.exists?( path )
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