require 'billy/commands/hello'

describe Billy::Commands::Hello do

  before :each do
    stub!( :system ) { |arg| "System call: #{arg}" }
  end
  
  after :each do
    file_path = File.expand_path( Billy::Config::BILLYRC )
    File.unlink( file_path ) if File.exists?( file_path )
  end
  
  describe 'Register' do
    
    it 'Should register itself' do
      expect { Billy::Commands::Hello.register_self! }.not_to raise_error
      Billy::Commands.pool.values.should include Billy::Commands::Hello.instance
    end
    
  end
  
  describe 'Proceed' do
    
    let!( :command ) { Billy::Commands::Hello.instance }
    let!( :init_path ) { File.expand_path( File.dirname( __FILE__ ) + "../../../../../tmp" ) }
    let!( :arguments ) { [ init_path ] }
    
    before :each do
      
      command.stub!( :gets ) { "y\n" }
      command.stub!( :print ) {}
      command.stub!( :ssh_key_exists? ) { true }
      command.stub!( :ssh_command_exists? ) { true }
      
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
    
    # it 'Should create config file inside folder to proceed' do
    #   command.proceed!( arguments )
    #   File.exists?( File.expand_path( init_path + "/#{Billy::Config::BILLYRC}" ) ).should be_true
    # end
    
  end
  
  describe 'SSH' do
    
    let!( :command ) { Billy::Commands::Hello.instance }
    
    before :each do
      command.stub!( :print ) {}
    end
    
    it 'Offer to generate ssh key if it does not exist' do
      flag = false
      command.stub!( :ssh_key_exists? ) { false }
      command.stub!( :get_confirmation ) { true }
      command.stub!( :offer_ssh_keygen ) { flag = true }
      expect{ command.proceed! }.to_not raise_error
      flag.should be_true
    end
    
    it 'Should suggest install ssh if it was not installed' do
      flag = false
      command.stub!( :ssh_command_exists? ) { false }
      command.stub!( :get_confirmation ) { true }
      command.stub!( :suggest_install_ssh ) { flag = true }
      expect{ command.proceed! }.to raise_error SystemExit
      flag.should be_true
    end
    
  end
end