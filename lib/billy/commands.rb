module Billy
  class Commands
    
    class << self
      
      attr_accessor :pool
      
      def load_pool!
        self.pool ||= Hash.new
        commands_path = File.expand_path( File.dirname(__FILE__) + '/commands/**/*.rb' )
        Dir[ commands_path ].each do |file|
          require file
        end
      end
      
      def register_command!( command )
        load_pool! unless !pool.nil?
        ( pool[ command.name ] = command ) unless pool.values.include?( command )
      end
      
    end
    
  end
end