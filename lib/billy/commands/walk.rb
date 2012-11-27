require 'billy/commands/command'
require 'capistrano'

class Billy
  class Commands
    class Walk < Command

      def proceed!(arguments)
        destination = arguments[0]

        cap = prepare_capistrano(destination)

        #deploy here
      end

      def prepare_capistrano(destination) 
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