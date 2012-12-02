require 'billy/util/scm/scm'

module Billy
  module Util
    class Git < Scm
      
      GIT_PATH = ".git"
      
      def configure!( cap, config )
        cap.set :scm, :git
        cap.set :repository, config.repository || get_repository_path
        cap.set :branch, config.branch || 'master'
      end
      
      def get_config
        File.read( File.expand_path( GIT_PATH + "/config" ) )
      end
      
      def local_repository_exists?
        File.exists?( File.expand_path( GIT_PATH ) )
      end
      
      def remote_repository_exists?( config )
        get_remotes( config ).any?
      end
      
      def get_remotes( config )
        config.gsub( /\n/, ';' ).scan /\[remote\s+\"([^"]+)\"\][^\[]+url\s*=\s*([^;]+)/
      end
      
      def init_repository
        system "git init ."
      end
      
      def get_repository_path
        if !local_repository_exists?
          if !Billy::Util::UI.confirm?( "Git repository was not created. Do you want Billy to create it now?" )
            Billy::Util::UI.err "Billy could not proceed without git repository."
            exit 1
          else
            Billy::Util::UI.inform "Creating git repository."
            init_git_repository
          end
        end

        config = get_git_config

        if !remote_repository_exists?( config )
          Billy::Util::UI.err "Billy could not find remote repository for your project."
          Billy::Util::UI.err "Please add some remote, e.g. git remote add git@github.com:myUsername/myProject.git."
          exit 1
        end

        idx = 1
        i = 0
        
        match_data = get_remotes( config )
        
        if match_data.length > 1
          Billy::Util::UI.inform "Billy found several remotes in repository. Choose one to deploy from:"
          match_data.each do |remote|
            i += 1
            Billy::Util::UI.inform "#{i}: #{remote[0]}\t\t#{remote[1]}"
          end
          while ( idx = Billy::Util::UI.input.to_i ) > match_data.length; end
        end
        match_data[ idx - 1 ][ 1 ]
      end

    end
  end
end

Billy::Util::Git.register_self!