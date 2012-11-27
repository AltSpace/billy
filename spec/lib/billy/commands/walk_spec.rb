require 'billy/commands/walk'

describe Billy::Commands::Walk do
  let!( :command ) { Billy::Commands::Walk.instance }
  
  before :each do
    Billy::Config.stub( :load ) {
      Billy::Config.clear
      Billy::Config.stub(
        :user => "nobody",
        :remote_path => "/tmp/",
        :repository => "git://some.repo.com/"
      )
    }
    command.stub!( :print ) {}
  end
  
  before :all do
    Dir.chdir( "tmp" )
  end
  
  after :all do
    Dir.chdir( ".." )
  end
  
  describe 'proceed!' do
    
    it 'Should raise SystemExit if no config file found' do
      expect { command.proceed! }.to raise_error SystemExit
    end
    
    it 'Should raise SystemExit if app name is neither provided nor stored in config' do
      expect { command.proceed! }.to raise_error SystemExit
    end
  end
end