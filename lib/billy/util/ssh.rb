module Billy
  module Util
    module Ssh
      
      class << self
        def ssh_root_path
          File.expand_path( "~/.ssh" )
        end
      
        def ssh_folder_exists?
          File.exists?( ssh_root_path ) && File.directory?( ssh_root_path )
        end
      
        def get_pub_key( type = :id_rsa )
          keys = pub_keys
          return nil unless !keys.nil? && keys.any?
          keys[ type ]
        end
      
        def pub_keys
          return nil unless ssh_folder_exists?
          res = Hash.new
          Dir[ ssh_root_path + '/*.pub' ].each do |f|
            key = File.basename( f, '.pub' ).to_sym
            res[ key ] = File.read( f )
          end
        end
      end
    end
  end
end