require 'billy/commands/my'

describe Billy::Commands::My do
  
  let!( :command ) { Billy::Commands::My.instance }
  
  before :each do
    Billy::Util::UI.stub!( :inform ) {}
  end
  
  describe 'proceed!' do
    
    let!( :unknown_command ) { 'unknown_command' }
    
    it 'Should raise error without subcommand' do
      expect{ command.proceed!( [] ) }.to raise_error SystemExit
    end
    
    it 'Should raise error if unknown command given' do
      expect{ command.proceed!( [ unknown_command ] ) }.to raise_error SystemExit
    end
    
  end
end