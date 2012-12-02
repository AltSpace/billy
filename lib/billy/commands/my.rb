require 'billy/commands/command'

module Billy
  class Commands
    class My < Command
      
      def proceed!( arguments = nil )
        if arguments.length < 1
          Billy::Util::UI.err 'Please provide Billy more info what do you need?'
          exit 1
        end
        sub_cmd = arguments.shift.downcase.to_sym rescue nil
        case sub_cmd
        when :key 
          res = Billy::Util::Ssh.get_pub_key
          if res.nil?
            Billy::Util::UI.err "Billy could not find your ssh key. Say billy hello."
            exit 1
          else
            Billy::Util::UI.inform "Billy found an ssh key:"
            Billy::Util::UI.succ res
            Billy::Util::UI.inform "Copy and add it to your deployment server."
          end
        else
          Billy::Util::UI.err "Billy doesn't know #{sub_cmd} command."
          exit 1
        end
      end
      
    end
  end
end

Billy::Commands::My.register_self!