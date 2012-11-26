require 'billy/commands'

class Billy
  class Commands
    class Init
      
      def proceed!( arguments )
        arguments[ :path ] ||= File.dirname( __FILE__ )
        cfg = Billy::Config.load!( arguments[ :path ] )
        ( cfg = Billy::Config.new( arguments[ :path ] ) ) unless !cfg.nil?
      end
      
      protected
      
      def initialize
        
      end
      
      class << self
        
        def instance
          @@instance ||= self.new
        end
        
        def register_self!
          Billy::Commands.register_command!( instance )
        end
        
      end
    end
  end
end

Billy::Commands::Init.register_self!