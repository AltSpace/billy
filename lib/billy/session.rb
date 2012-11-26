class Billy
  class Session
    class << self
      
      def run!( args )
        Billy::Commands.register_pool!
        command = ARGV.shift
        status = proceed_command!( command_name )
        exit status
      end
      
      def proceed_command!( command_name )
        cmd = Billy::Commands.pool[ command_name.to_sym ]
        raise "Unknown command given: #{command_name}" if cmd.nil?
      end
    end
  end
end