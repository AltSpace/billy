class Billy
  class Config
    
    attr_accessor :storage
    
    def method_missing( m, args, &block )
      if m.to_s[ /=$/ ].nil?
        # get method
        self.storage[ m.to_sym ]
      else
        # set method
        self.storage[ m.to_sym ] = args.shift
      end
    end
    
    def save!( path_to_save )
      # TODO: save it
    end

    protected
    
    def initialize
      self.storage = Hash.new
    end
    
    class << self
      
      def instance
        @@instance ||= self.new
      end
      
    end
    
  end
end