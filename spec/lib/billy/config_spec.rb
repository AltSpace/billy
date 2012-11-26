require 'billy/config'

describe Billy::Config do
  
  describe 'Config.instance' do
    
    it 'doesn\'t throw error' do
      expect{ Billy::Config.instance }.to_not raise_error
    end
    
    it 'instantiates itself' do
      Billy::Config.instance.should be_an_instance_of( Billy::Config )
    end
    
  end
  
end