require 'billy/commands/command'
require 'capistrano'

module Billy
  class Commands
    class Walk < Command
      
      def proceed!( arguments = nil )
        
        if !Billy::Config.load
          Billy::Util::UI.inform "Billy config could not be found. Say Billy hello."
          exit 1
        end
        
        destination = ( arguments.shift rescue nil ) || Billy::Config.instance.destination
        
        if destination.nil?
          Billy::Util::UI.err "Billy doesn't know where to walk."
          Billy::Util::UI.err "You have to provide deploy folder, e.g.: billy walk my_super_project."
          exit 1
        end
        
        cap = prepare_capistrano( destination )
        %w(deploy:setup deploy).each do |command|
          cap.find_and_execute_task(command, :before => :start, :after => :finish)
        end
        cap.trigger( :exit )
        
        Billy::Util::UI.succ "All done! Billy is a clever boy!"
      end

      def prepare_capistrano( destination )
        
        cap = Capistrano::Configuration.new
        cap.load "standard"
        cap.load "deploy"
        cap.trigger( :load )
        config = Billy::Config.instance
        
        if config.deploy_to.nil?
          Billy::Util::UI.err "Billy doesn't know remote deploy path. Please provide it in config under deploy_to key."
          exit 1
        end
        cap.set :deploy_to, File.join( config.deploy_to, destination )
        cap.set :normalize_asset_timestamps, false
        
        reject_keys = [ :deploy_to, :server ]
        
        {
          :scm => 'git',
          :use_sudo => false,
          :deploy_via => :remote_cache,
          :application => destination
        }.merge( config.storage.reject{ |k, v| reject_keys.include?( k ) } ).each_pair do |k, v|
          cap.set k, v
        end
        
        cap.server config.server, :app, :web, :db, :primary => true
        
        cap.namespace :deploy do
          cap.task :start, :roles => :app do; end
          cap.task :stop, :roles => :app do; end
          cap.task :restart, :roles => :app do; end
        end
        
        cap
      end
      
    end
  end
end

Billy::Commands::Walk.register_self!