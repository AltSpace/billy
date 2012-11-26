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
  
  describe 'File' do
    
    let!( :test_dir ) { File.expand_path( File.dirname( __FILE__ ) + "../../../../tmp/" ) }
    let!( :billy ) { Billy::Config.instance }
    let!( :known_key1 ) { 'qweq123-&65poi!@#$' }
    let!( :known_value1 ) { 'asdas#$%^&3' }
    let!( :known_key2 ) { 'poioiuyuytrdfa!@#$' }
    let!( :known_value2 ) { 'mnsdgfkgwu#$%^&3' }
    
    it 'Should return false if config doesn\'t exists' do
      billy.config_exists?( test_dir ).should be_false
    end
    
    it 'Should stingify itself' do
      billy.send( "#{known_key1}=", known_value1 )
      billy.send( "#{known_key2}=", known_value2 )
      billy.to_s.should eq <<-EOS
#{known_key1}\t#{known_value1}
#{known_key2}\t#{known_value2}
EOS
    end
    
  end
  
end