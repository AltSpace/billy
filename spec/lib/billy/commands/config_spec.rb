require 'billy/commands/config'

describe Billy::Commands::Config do
  
  describe 'proceed!' do
    
    let!( :command ) { Billy::Commands::Config.instance }
    let!( :config ) { Billy::Config.instance }
    
    before :all do
      Dir.chdir( File.expand_path( "tmp" ) )
    end
    
    after :all do
      Dir.chdir( File.expand_path( ".." ) )
    end
    
    before :each do
      command.stub!( :gets ) { "y\n" }
      command.stub!( :print ) {}
    end
    
    it 'Should raise error if there is no settings file' do
      config_file = File.expand_path( Billy::Config::BILLYRC )
      File.unlink( config_file ) if File.exists?( config_file )
      expect { command.proceed! }.to raise_error
    end
    
    it 'Should not raise error if there is a config file' do
      config_file = File.expand_path( Billy::Config::BILLYRC )
      File.unlink( config_file ) if File.exists?( config_file )
      config.save
      expect { command.proceed! }.to_not raise_error
      File.exists?( config_file ).should be_true
    end
    
  end
  
end