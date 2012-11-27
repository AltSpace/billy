class Billy
  class Config
    
    BILLYRC = '.billyrc'
    SEPARATOR = ': '
    
    attr_accessor :storage
    attr_accessor :storage_path
    
    def method_missing( m, *args, &block )
      if m.to_s[ /=$/ ].nil?
        self.storage[ m.to_s ]
      else
        key = ( m.to_s )[ /^([^=]+)/ ]
        val = args.shift
        ( self.storage[ key ] = val ) unless key.nil? && key.empty?
      end
    end
    
    def config_exists?( dir )
      File.exists?( File.expand_path( dir + "/#{BILLYRC}" ) )
    end

    def to_s
      [].tap { |res|
        self.storage.each_pair do |k, v|
          res.push "#{k}#{SEPARATOR}#{v}"
        end
      }.push( "" ).join( "\n" )
    end
    
    def load
      %w(. ~).each do |path|
        begin
          load!( File.expand_path( path ) )
          return true
        rescue e
          next
        end
      end
      
      false
    end
    
    def load!( dir )
      self.storage_path = File.expand_path( dir )
      file_path = storage_path + "/#{BILLYRC}"
      raise "Config was not found in #{path}" unless File.exists?( file_path )
      eat_string_config( File.read( file_path ) )
    end
    
    def clear
      self.storage.clear
    end
    
    def reload!( dir = nil )
      dir ||= storage_path
      clear
      load!( dir )
    end
    
    def save( dir = nil )
      dir ||= Dir.pwd
      begin
        save!( dir, true )
        true
      rescue
        false
      end
    end
    
    def save!( dir, force = false )
      raise 'Directory name should not be empty' unless !dir.empty?
      raise "Directory #{dir.to_s} doesn't exist" unless File.exist?( File.expand_path( dir ) )
      billyrc_path = File.expand_path( dir + "/#{BILLYRC}" )
      raise "Config already exists in #{billyrc_path}" unless !File.exists?( billyrc_path ) || force
      File.open( billyrc_path, 'w' ) { |file|
        file.flush
        file.write( self.to_s )
      }
    end
    
    def eat_string_config( string_config )
      clear
      string_config.each_line do |line|
        next unless !line.empty?
        items = line.split( SEPARATOR )
        k = items.shift
        v = items.join( SEPARATOR ).strip
        ( self.storage[ k.to_s ] = v ) unless k.nil? || k.empty? || v.nil? || v.empty?
      end
    end
    
    protected
    
    def initialize
      self.storage = Hash.new
    end
    
    class << self
      
      def instance
        @@instance ||= self.new
      end
      
      def settings
        instance.storage
      end
      
      def method_missing( m, *args, &block )
        instance.send( m, *args, &block ) if instance.respond_to?( m )
      end
      
    end
    
  end
end