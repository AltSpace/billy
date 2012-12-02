require 'billy/commands/command'

module Billy
  class Commands
    class Hello < Command
      
      def proceed!( arguments = nil )
        billy_say_hello
        path = get_init_path( arguments )
        if !ssh_command_exists?
          suggest_install_ssh
          exit 1
        end
        offer_ssh_keygen unless ssh_key_exists?
        Billy::Util::UI.succ "All done!"
      end
      
      def billy_say_hello
        Billy::Util::UI.inform "Hi! I'm Billy, simple deploy tool."
        Billy::Util::UI.inform "Usage:"
        Billy::Util::UI.inform "  * billy hello (path) -- init billy in {path} folder. Inites in current if no one given."
        Billy::Util::UI.inform "  * billy eat {cfg_path} -- parse and save billy config in current folder. {cfg_path} here means remote file url or local one."
        Billy::Util::UI.inform "  * billy walk {application_name} -- deploy HEAD version in repository to remote server."
      end
      
      def ssh_command_exists?
        res = true
        %w(ssh ssh-keygen).each do |cmd|
          res &= system( "which #{cmd} 2>&1 > /dev/null" )
        end
        res
      end
      
      def ssh_key_exists?
        ssh_root_path = File.expand_path( "~/.ssh" )
        res = true
        res &= File.exists?( ssh_root_path )
        res &= File.directory?( ssh_root_path )
        res &= Dir[ ssh_root_path + "/*.pub" ].any?
        res
      end
      
      def suggest_install_ssh
        Billy::Util::UI.err "Billy wants you to install ssh command. Please do it first."
      end
      
      def offer_ssh_keygen
        if !Billy::Util::UI.confirm? "Billy did not find your ssh key. Would you like to create it now?(y/n): "
          Billy::Util::UI.err "Ssh key should be generated before we continue. Please generate it."
          exit 1
        end
        enc_type = 'rsa'
        Billy::Util::UI.inform "Billy creates ssh keys for you..."
        system "ssh-keygen -t #{enc_type} -N '' -f ~/.ssh/id_#{enc_type}"
      end
      
      def get_init_path( arguments )
        ( path = arguments.shift ) unless arguments.nil?
        if path.nil? || path.empty?
          if !Billy::Util::UI.confirm? "Billy will be inited in current directory. Proceed?(y/n): "
            Billy::Util::UI.inform "Billy has nothing to do. Bye-bye."
          end
          path = Dir.pwd
        end
        File.expand_path( path )
      end
      
    end
  end
end

Billy::Commands::Hello.register_self!