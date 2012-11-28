require 'billy/commands/eat'

describe Billy::Commands::Eat do
  
  let!( :command ) { Billy::Commands::Eat.instance }
  
  before :all do
    Dir.chdir( File.expand_path( "tmp" ) )
  end
  
  after :all do
    Dir.chdir( File.expand_path( ".." ) )
  end
  
  before :each do
    Billy::Config.instance.clear
    command.stub!( :gets ) { "y\n" }
    command.stub!( :print ) {}
  end
  
  describe 'Proceed' do
    
    let!( :non_existant_file ) { File.expand_path( Dir.pwd + "/some_settings_file.txt" ) }
    let!( :existant_file ) { File.expand_path( Dir.pwd + "/#{Billy::Config::BILLYRC}" ) }
    
    it 'Should raise error if no path given' do
      expect { command.proceed! }.to raise_error
    end
    
    it 'Should raise error if local file given and it\'s not available' do
      expect { command.proceed!( non_existant_file ) }.to raise_error
    end
    
    it 'Should not raise error if config file exists' do
      Billy::Config.instance.save!( File.expand_path( Dir.pwd ) ) unless File.exists?( existant_file )
      expect { command.proceed!( [ existant_file ] ) }.not_to raise_error
    end
    
  end
  
  describe 'load_remote_config' do
    
    let!( :remote_path ) { "http://yandex.ru/robots.txt" }
    
    before :each do
      Billy::Config.instance.clear
      command.stub!( :gets ) { "y\n" }
      command.stub!( :print ) {}
    end
    
    it 'Should load remote config' do
      expect{ command.load_remote_config( remote_path ) }.to_not raise_error
    end
    
    it 'Should return some response as string' do
      res = command.load_remote_config( remote_path )
      res.should_not be_empty
    end
    
    it 'Should save all the settings to config' do
      # simply remove it if it fails )))
      command.proceed!( [ remote_path ] )
      Billy::Config.instance.send( "User-Agent" ).should eq "*"
    end
    
    it 'Should save config file' do
      File.unlink( Billy::Config::BILLYRC ) if File.exists?( Billy::Config::BILLYRC )
      command.proceed!( [ remote_path ] )
      File.exists?( File.expand_path( Dir.pwd + "/#{Billy::Config::BILLYRC}" ) ).should be_true
    end
  end
  
end