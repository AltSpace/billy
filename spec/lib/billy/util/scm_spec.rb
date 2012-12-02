require 'billy/util/scm/scm'
require 'ostruct'

describe Billy::Util::Scm do
  
  let!( :cap ) { OpenStruct.new }
  
  class TestScm < Billy::Util::Scm
    def configure!( cap, scm )
      cap.send( 'test_k=', 'test_v' )
    end
  end
  
  let!( :scm ) { Billy::Util::Scm }
  let!( :test_scm ) { TestScm.new }
  let!( :unknown_scm ) { :asdfasdf }
  
  describe 'self.register_self!' do
    
    it 'Should register itself' do
      expect{ test_scm.class.register_self! }.to_not raise_error
      scm.pool.has_key?( test_scm.class.to_s.downcase.to_sym ).should be_true
    end
    
  end
  
  describe 'register_scm' do
    
    it 'Should not raise error on registering new scm' do
      expect{ scm.register_scm( test_scm ) }.to_not raise_error
    end
    
    it 'Should store scm in global pool' do
      scm.register_scm( test_scm )
      scm.pool.has_key?( test_scm.class.to_s.downcase.to_sym ).should be_true
    end
    
  end
  
  describe 'configure!' do
    
    it 'Should raise error if scm is unknown' do
      expect{ scm.configure!( cap, { :scm => unknown_scm } ) }.to raise_error
    end
    
    it 'Should not raise error if scm registered' do
      scm.register_scm( test_scm )
      expect{ scm.configure!( cap, { :scm => test_scm.class.to_s.downcase.to_sym } ) }.to raise_error
    end
    
    it 'Should configure cap' do
      scm.register_scm( test_scm )
      scm.configure!( cap, OpenStruct.new( :scm => test_scm.class.to_s.downcase.to_sym ) )
      cap.send( 'test_k' ).should eq 'test_v'
    end
    
  end
  
end

