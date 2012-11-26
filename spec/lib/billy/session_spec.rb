require 'lib/billy/session'

describe Billy::Session do
  
  describe 'proceed_command!' do
    
    it 'should raise error if empty command name given' do
      empty_command = ""
      expect { Billy::Session.proceed_command!( empty_command ) }.to raise_error
    end
    
  end
  
end