require 'lib/billy/commands'

describe Billy::Commands do
  
  context 'pool' do
    
    # it 'should be nil on init' do
    #   Billy::Commands.pool.should be_nil
    # end
    # 
    it 'should be [] after register_pool!' do
      Billy::Commands.load_pool!
      Billy::Commands.pool.should be_an_instance_of( Array )
    end
    
  end
  
end