class Billy
  class Session
    class << self
      
      def run!( args )
        Billy::Commands.register_pool!
        command = ARGV.shift
        cmd = Billy::Commands.pool[ command.to_sym ]
        raise "Unknown command given: #{command}" if cmd.nil?
      end
      
    end
  end
end