require 'billy/util/ui'

module Billy
  module Util
    class Scm
      
      class << self
        
        attr_accessor :pool
        
        def register_self!
          Billy::Util::Scm.register_scm( self.new )
        end
        
        def register_scm( scm )
          key = scm.class.to_s.split( "::" ).last.downcase.to_sym
          ( self.pool ||= {} )[ key ] = scm
        end
        
        def configure!( cap, config )
          scm = ( config.scm || :git ).to_sym
          raise "#{scm} handler is unknown." if !self.pool.has_key?( scm )
          pool[ scm ].configure!( cap, config )
        end
      
      end
      
    end
  end
end