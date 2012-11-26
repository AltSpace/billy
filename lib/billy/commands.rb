class Billy
  class Commands
    
    class << self
      
      attr_accessor :pool
      
      def register_pool!
        self.pool ||= []
        Dir[ "billy/commands/*.rb" ].each { |file| require file }
      end
      
      def register_command!( command )
        register_pool! unless pool.nil?
        pool.push( command ) unless pool.contains?( command )
      end
      
    end
    
  end
end