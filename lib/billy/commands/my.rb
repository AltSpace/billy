require 'billy/commands/command'

module Billy
  class Commands
    class My < Command
      
      def proceed!( arguments = nil )
        if arguments.length < 1
          Billy::Util::UI.err 'Please provide Billy more info what do you need?'
          exit 1
        end
        sub_cmd = arguments.shift.to_sym
        case sub_cmd
        when :key
          Billy::Util::Ssh.get_pub_key
        else
          Billy::Util::UI.err "Billy doesn't know #{sub_cmd} command."
          exit 1
        end
      end
      
    end
  end
end

Billy::Commands::My.register_self!