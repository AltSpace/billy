require 'billy/commands/command'

class Billy
  class Commands
    class Hello < Command
      
      def proceed!( arguments = nil )
        path = get_init_path( arguments )
        config = Billy::Config.instance
        config.save!( path, true )
      end
      
      def get_init_path( arguments )
        ( path = arguments.shift ) unless arguments.nil?
        if path.nil? || path.empty?
          print "Billy will be inited in current directory. Proceed?(y/n)"
          confirm = get_confirmation
          exit 1 unless confirm
          path = Dir.pwd
        end
        File.expand_path( path )
      end
      
    end
  end
end

Billy::Commands::Hello.register_self!