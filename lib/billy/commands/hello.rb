require 'billy/commands/command'

class Billy
  class Commands
    class Hello < Command
      
      def proceed!( arguments = nil )
        billy_say_hello
        path = get_init_path( arguments )
        config = Billy::Config.instance
        config.save!( path, true )
        if !ssh_command_exists?
          suggest_install_ssh
          exit 1
        end
        offer_ssh_keygen unless ssh_key_exists?
        print "All done!\n"
      end
      
      def billy_say_hello
        print "Hi! I'm Billy, simple deploy tool.\n"
        print "Usage:\n"
        print "  * billy hello (path) -- init billy in {path} folder. Inites in current if no one given.\n"
        print "  * billy eat {cfg_path} -- parse and save billy config in current folder. {cfg_path} here means remote file url or local one.\n"
        print "  * billy walk {application_name} -- deploy HEAD version in repository to remote server.\n"
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
        print "Billy wants you to install ssh command. Please do it first.\n"
      end
      
      def offer_ssh_keygen
        print "Billy did not find your ssh key. Would you like to create it now?(y/n): "
        confirm = get_confirmation
        if !confirm
          print "Ssh key should be generated before we continue. Please generate it.\n"
          exit 1
        end
        enc_type = 'rsa'
        print "Billy creates ssh keys for you...\n"
        system "ssh-keygen -t #{enc_type} -N '' -f ~/.ssh/id_#{enc_type}"
        print "All done!"
      end
      
      def get_init_path( arguments )
        ( path = arguments.shift ) unless arguments.nil?
        if path.nil? || path.empty?
          print "Billy will be inited in current directory. Proceed?(y/n): "
          confirm = get_confirmation
          if !confirm
            print "Billy has nothing to do. Bye-bye."
          end
          path = Dir.pwd
        end
        File.expand_path( path )
      end
      
    end
  end
end

Billy::Commands::Hello.register_self!