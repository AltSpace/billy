require 'billy/commands/command'
require 'capistrano'

class Billy
  class Commands
    class Walk < Command
      
      GIT_PATH = ".git"
      
      def proceed!( arguments = nil )
        
        if !Billy::Config.load
          print "Billy config could not be found. Say Billy hello."
          exit 1
        end
        
        destination = ( arguments.shift rescue nil ) || Billy::Config.instance.destination
        
        if destination.nil?
          print "Billy doesn't know where to walk."
          print "You have to provide deploy folder, e.g.: billy walk my_super_project.\n"
          exit 1
        end
        
        cap = prepare_capistrano( destination )
        %w(deploy:setup deploy).each do |command|
          cap.find_and_execute_task(command, :before => :start, :after => :finish)
        end
        cap.trigger( :exit )
        
        print "All done! Billy is a clever boy!\n"
      end

      def prepare_capistrano( destination )
        
        cap = Capistrano::Configuration.new
        cap.load "standard"
        cap.load "deploy"
        cap.trigger( :load )
        config = Billy::Config.instance
        
        if config.deploy_to.nil?
          print "Billy doesn't know remote deploy path. Please provide it in config under deploy_to key.\n"
          exit 1
        end
        
        cap.set :scm, "git"
        cap.set :use_sudo, false
        cap.set :deploy_via, :remote_cache
        cap.set :application, destination
        cap.set :deploy_to, File.join( config.deploy_to, destination )
        cap.server config.server, :app, :web, :db, :primary => true
        cap.set :user, config.user
        
        repository = config.repository || get_repository_path
        
        cap.set :repository, repository
        cap.set :normalize_asset_timestamps, false
        
        cap.namespace :deploy do
          cap.task :start, :roles => :app do; end
          cap.task :stop, :roles => :app do; end
          cap.task :restart, :roles => :app do; end
        end
        
        cap
      end

      def get_repository_path
        if !local_repository_exists?
          print "Git repository was not created. Do you want Billy to create it now?\n"
          confirm = get_confirmation
          if !confirm
            print "Billy could not proceed without git repository.\n"
            exit 1
          else
            print "Creating git repository.\n"
            init_git_repository
          end
        end

        config = get_git_config

        if !remote_repository_exists?( config )
          print "Billy could not find remote repository for your project.\n"
          print "Please add some remote, e.g. git remote add git@github.com:myUsername/myProject.git.\n"
          exit 1
        end

        idx = 1
        i = 0
        
        match_data = get_remotes( config )
        
        if match_data.length > 1
          print "Billy found several remotes in repository. Choose one to deploy from:"
          match_data.each do |remote|
            i += 1
            print "#{i}: #{remote[0]}\t\t#{remote[1]}\n"
          end
          while ( idx = gets.chomp.to_i ) > match_data.length; end
        end
        match_data[ idx - 1 ][ 1 ]
      end
      
      def get_git_config
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
      
      def init_git_repository
        system "git init ."
      end
      
    end
  end
end

Billy::Commands::Walk.register_self!