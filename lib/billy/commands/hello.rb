require 'billy/commands/command'

class Billy
  class Commands
    class Hello < Command
      
      def proceed!( arguments = nil )
        path = get_init_path( arguments )
        config = Billy::Config.instance
        config.save!( path, true )
        if !ssh_command_exists?
          suggest_install_ssh
          exit 1
        end
        offer_ssh_keygen unless ssh_key_exists?
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
        print "Billy wants you to install ssh command first. Please do it."
      end
      
      def offer_ssh_keygen
        print "Billy did not find your ssh key. Would you like to create it now?"
        confirm = get_confirmation
        if !confirm
          print "Ssh key should be generated before we continue. Please generate it."
          exit 1
        end
        enc_type = 'rsa'
        system "ssh-keygen -t #{enc_type} -N '' -f ~/.ssh/id_#{enc_type}"
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