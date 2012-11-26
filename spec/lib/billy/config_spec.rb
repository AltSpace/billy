require 'billy/config'

describe Billy::Config do
  
  describe 'Config.instance' do
    
    it 'Should not throw error' do
      expect{ Billy::Config.instance }.to_not raise_error
    end
    
    it 'Should instantiates itself' do
      Billy::Config.instance.should be_an_instance_of( Billy::Config )
    end
    
    it 'Should return same instance' do
      i1 = Billy::Config.instance
      i2 = Billy::Config.instance
      ( i1.equal?( i2 ) ).should be_true
    end
    
  end
  
  describe 'Storage' do
    
    let!( :unknown_key ) { 'asdasd12091823#$%^&3' }
    let!( :known_key ) { 'qweq123-&65poi!@#$' }
    let!( :known_value ) { 'asdas#$%^&3' }
    
    it 'Should not throw error on unknown method call' do
      Billy::Config.instance.send( unknown_key )
      expect{ Billy::Config.instance.send( unknown_key ) }.to_not raise_error
    end
    
    it 'Should return nil for unknown key' do
      Billy::Config.instance.send( unknown_key ).should be_nil
    end
    
    it 'Should not raise error on new value set' do
      expect{ Billy::Config.instance.send( "#{known_key}=", known_value ) }.to_not raise_error
    end
    
    it 'Should save value' do
      Billy::Config.instance.send( "#{known_key}=", known_value )
      Billy::Config.instance.send( known_key ).should eq known_value
    end
    
  end
  
  describe 'File storage' do
    
    let!( :test_dir ) { File.expand_path( File.dirname( __FILE__ ) + "../../../../tmp/" ) }
    let!( :billy ) { Billy::Config.instance }
    let!( :known_key1 ) { 'qweq123-&65poi!@#$' }
    let!( :known_value1 ) { 'asdas#$%^&3' }
    let!( :known_key2 ) { 'poioiuyuytrdfa!@#$' }
    let!( :known_value2 ) { 'mnsdgfkgwu#$%^&3' }
    let!( :known_key3 ) { 'uyuytrdfa!@#$!@#' }
    let!( :known_value3 ) { 'mnsdg#$%^&3fkgwu' }
    let!( :template ) {
      <<-EOS
#{known_key1}: #{known_value1}
#{known_key2}: #{known_value2}
EOS
    }
    
    before :each do
      billyrc_path = File.expand_path( test_dir + "/#{Billy::Config::BILLYRC}" )
      File.unlink( billyrc_path ) if File.exists?( billyrc_path )
    end
    
    it 'Should return false if config doesn\'t exists' do
      billy.config_exists?( test_dir ).should be_false
    end
    
    it 'Should stingify itself' do
      billy.send( "#{known_key1}=", known_value1 )
      billy.send( "#{known_key2}=", known_value2 )
      billy.to_s.should eq template
    end
    
    it 'Should save itself' do
      save_path = test_dir
      expect{ billy.save!( test_dir ) }.to_not raise_error
      File.exists?( File.expand_path( save_path + "/#{Billy::Config::BILLYRC}" ) ).should be_true
    end
    
    it 'Config file content should equals to stringified value' do
      billy.send( "#{known_key1}=", known_value1 )
      billy.send( "#{known_key2}=", known_value2 )
      original_content = billy.to_s
      billy.save!( test_dir )
      file = File.open( File.expand_path( test_dir + "/#{Billy::Config::BILLYRC}" ) )
      content = file.read
      content.should eq original_content
    end
    
    it 'Should load from file' do
      billy.send( "#{known_key1}=", known_value1 )
      billy.send( "#{known_key2}=", known_value2 )
      billy.save!( test_dir )
      billy.reload!( test_dir )
      billy.send( known_key1 ).should eq known_value1
      billy.send( known_key2 ).should eq known_value2
    end
    
    it 'Should contains no unsaved settings in storage' do
      billy.send( "#{known_key1}=", known_value1 )
      billy.send( "#{known_key2}=", known_value2 )
      billy.save!( test_dir )
      billy.send( "#{known_key3}=", known_value3 )
      billy.reload!
      billy.send( known_key3 ).should be_nil
    end
  end
  
end