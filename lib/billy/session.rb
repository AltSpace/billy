class Billy
  class Session
    class << self
      
      def run!( args )
        Billy::Commands.register_pool!
        command = ARGV.shift
        arguments = ARGV
        status = proceed_command!( command_name, arguments )
        exit status
      end
      
      def proceed_command!( command_name, arguments )
        cmd = Billy::Commands.pool[ command_name.to_sym ]
        raise "Unknown command given: #{command_name}" if cmd.nil?
        cmd.proceed!( arguments )
      end
      
    end
  end
end