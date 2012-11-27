require 'billy/commands/command'
require 'capistrano'

class Billy
  class Commands
    class Walk < Command

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
        
        cap = prepare_capistrano(destination)
        cap.execute!( "deploy:setup" )
        cap.execute!( "deploy" )
      end

      def prepare_capistrano( destination ) 
        cap = Capistrano::Configuration.new
        config = Billy::Config.instance
        
        cap.set :scm, "git"
        cap.set :deploy_via, :remote_cache
        cap.set :deploy_path, File.join(config.remote_path,destination)

        [:user,:repository,:deploy_path].each do |variable|
          cap.set variable, config.send(variable)
        end

        cap
      end

      
    end
  end
end

Billy::Commands::Walk.register_self!