require 'billy/commands/my'

describe Billy::Commands::My do
  
  let!( :command ) { Billy::Commands::My.instance }
  
  before :each do
    Billy::Util::UI.stub!( :inform ) {}
    Billy::Util::UI.stub!( :succ ) {}
    Billy::Util::UI.stub!( :err ) {}
  end
  
  describe 'proceed!' do
    
    let!( :unknown_command ) { 'unknown_command' }
    
    it 'Should raise error without subcommand' do
      expect{ command.proceed!( [] ) }.to raise_error SystemExit
    end
    
    it 'Should raise error if unknown command given' do
      expect{ command.proceed!( [ unknown_command ] ) }.to raise_error SystemExit
    end
    
    it 'Should not raise error for key subcommand' do
      flag = false
      Billy::Util::Ssh.stub!( :get_pub_key ) { flag = true }
      expect{ command.proceed!( [ "key" ] ) }.to_not raise_error
      flag.should be_true
    end
    
  end
end