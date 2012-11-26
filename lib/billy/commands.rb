class Billy
  class Commands
    
    class << self
      
      attr_accessor :pool
      
      def register_pool!
        self.pool ||= []
        Dir[ File.expand_path( File.dirname(__FILE__) + '/commands/**/*.rb' ) ].each { |file| require file }
      end
      
      def register_command!( command )
        register_pool! unless pool.nil?
        pool.push( command ) unless pool.include?( command )
      end
      
    end
    
  end
end