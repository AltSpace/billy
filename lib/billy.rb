$:.unshift File.dirname( __FILE__ )

Module Billy
  require 'billy/session'
  require 'billy/util/ui'
  require 'billy/commands'
  require 'billy/config'
  require 'billy/util/scm'
end