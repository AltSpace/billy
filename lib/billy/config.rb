class Billy
  class Config
    
    BILLYRC = '.billyrc'
    
    attr_accessor :storage
    
    def method_missing( m, *args, &block )
      if m.to_s[ /=$/ ].nil?
        # get method
        self.storage[ m.to_s ]
      else
        # set method
        self.storage[ ( m.to_s )[ /^([^=]+)/ ] ] = args.shift
      end
    end
    
    def save!( dir )
      # TODO: save it
      raise 'Directory name should not be empty' unless !dir.empty?
      raise "Directory #{dir.to_s} doesn't exist" unless File.exist?( File.expand_path( dir ) )
      billyrc_path = File.expand_path( dir_to_save + "/#{BILLYRC}" )
      billyrc_file = File.new( billyrc_path )
      raise "Config already exists in #{billyrc_path}" unless !config_exists?( dir )
    end
    
    def config_exists?( dir )
      File.exists?( File.expand_path( dir + "/#{BILLYRC}" ) )
    end

    def to_s
      [].tap { |res|
        self.storage.each_pair do |k, v|
          res.push "#{k}\t#{v}"
        end
      }.push( "" ).join( "\n" )
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