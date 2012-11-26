require 'billy/commands/init'

describe Billy::Commands::Init do
  
  describe 'Register' do
    
    it 'Should register itself' do
      expect { Billy::Commands::Init.register_self! }.not_to raise_error
      Billy::Commands.pool.values.should include Billy::Commands::Init.instance
    end
    
  end
  
  describe 'Proceed' do
    
    let!( :command ) { Billy::Commands::Init.instance }
    let!( :init_path ) { File.expand_path( File.dirname( __FILE__ ) + "../../../../../tmp" ) }
    let!( :arguments ) { [ init_path ] }
    
    before :each do
      command.stub!( :gets ) { "y\n" }
      command.stub!( :print ) {}
      [ File.expand_path( init_path + "/#{Billy::Config::BILLYRC}" ),
                File.expand_path( Dir.pwd + "/#{Billy::Config::BILLYRC}" ) ].each do |billyrc_path|
        File.unlink( billyrc_path ) if File.exists?( billyrc_path )
      end
    end
    
    it 'Should be proceedable' do
      expect{ command.proceed!( arguments ) }.to_not raise_error
    end
    
    it 'Should proceed without arguments but with user confirmation' do
      expect{ command.proceed! }.to_not raise_error
    end
    
    it 'Should create config file inside folder to proceed' do
      command.proceed!( arguments )
      File.exists?( File.expand_path( init_path + "/#{Billy::Config::BILLYRC}" ) ).should be_true
    end
    
  end
end