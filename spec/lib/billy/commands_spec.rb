require 'lib/billy/commands'

describe Billy::Commands do
  
  context 'pool' do
    
    it 'should be an instance of Hash after load_pool!' do
      Billy::Commands.load_pool!
      Billy::Commands.pool.should be_an_instance_of( Hash )
    end
    
  end
  
end