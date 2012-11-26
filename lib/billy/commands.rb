class Billy
  class Commands
    
    class << self
      
      attr_accessor :pool
      
      def load_pool!
        self.pool ||= []
        commands_path = File.expand_path( File.dirname(__FILE__) + '/commands/**/*.rb' )
        Dir[ commands_path ].each do |file|
          require file
        end
      end
      
      def register_command!( command )
        load_pool! unless !pool.nil?
        pool.push( command ) unless pool.include?( command )
      end
      
    end
    
  end
end