require 'lib/billy/commands'

describe 'Commands' do
  
  context 'pool' do
    
    it 'should be nil on init' do
      Billy::Commands.pool.should be_nil
    end
    
    it 'should be [] after register_pool!' do
      Billy::Commands.register_pool!
      Billy::Commands.pool.should eq []
    end
    
  end
  
end