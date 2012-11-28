class Billy
  class Session
    class << self
      
      def run!( args )
        Billy::Commands.load_pool!
        command = ARGV.shift
        arguments = ARGV
        if command.nil?
          print "Billy has nothing to do. Yay!\n"
          exit 0
        end
        status = proceed_command!( command, arguments )
        exit status
      end
      
      def proceed_command!( command_name, arguments )
        cmd = Billy::Commands.pool[ command_name.to_s ]
        if cmd.nil?
          print "Billy doesn't know this command: #{command_name}. Say billy hello.\n"
          return 1
        end
        cmd.proceed!( arguments )
        0
      end
      
    end
  end
end