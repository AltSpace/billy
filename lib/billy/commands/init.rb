require 'billy/commands'

class Billy
  class Commands
    class Init
      
      def proceed!( arguments = nil )
        path = get_init_path( arguments )
        config = Billy::Config.instance
        config.save!( path, true )
      end
      
      def name
        self.class.to_s.split( "::" ).last.downcase
      end
      
      protected
      
      def initialize
      end
      
      def get_init_path( arguments )
        ( path = arguments.shift ) unless arguments.nil?
        if path.nil? || path.empty?
          print "Billy will be inited in current directory. Proceed?(y/n)"
          confirm = gets.chomp
          exit 1 unless confirm.downcase == "y"
          path = Dir.pwd
        end
        File.expand_path( path )
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