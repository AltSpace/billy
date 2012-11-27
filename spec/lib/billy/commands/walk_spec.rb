require 'billy/commands/walk'

describe Billy::Commands::Walk do
  let!( :command ) { Billy::Commands::Walk.instance }
  
  before :each do
    
    Billy::Config.instance.stub( :load ) {
      Billy::Config.clear
      Billy::Config.any_instance.stub(
        :user => "nobody",
        :remote_path => "/tmp/",
        :repository => "git://some.repo.com/"
      )
      true
    }
    
    command.stub!( :print ) {}
    
    Capistrano::Configuration.any_instance.stub( :execute! ) { |arg|
      p "Capistrano executes task #{arg}"
    }
  end
  
  describe 'proceed!' do
    
    it 'Should raise SystemExit if no config file found' do
      expect { command.proceed! }.to raise_error SystemExit
    end
    
    it 'Should raise SystemExit if app name is neither provided nor stored in config' do
      expect { command.proceed! }.to raise_error SystemExit
    end
    
    it 'Should deploy if destination given' do
      destination = "some_destination"
      expect { command.proceed!( [ destination ] ) }.to_not raise_error
      
    end
  end

  describe :prepare_capistrano do
    context 'With correct config' do
      let(:destination) { "test_destination"}
      before :each do
        Billy::Config.any_instance.stub(
          :user => "nobody",
          :remote_path => "/tmp/",
          :repository => "git://some.repo.com/"
          )

      end

      it 'Should not fail' do
        expect { command.prepare_capistrano(destination) }.not_to raise_error
      end

      it 'Should return capistrano instance' do
        command.prepare_capistrano(destination).should be_an_instance_of(Capistrano::Configuration)
      end
    end

    context 'Without destination' do
      before :each do
        Billy::Config.any_instance.stub(
          :user => "nobody",
          :remote_path => "/tmp/",
          :repository => "git://some.repo.com/"
          )

      end
      it 'Should fail' do
        expect { command.prepare_capistrano }.to raise_error
        expect { command.prepare_capistrano(nil) }.to raise_error
      end
    end

    context 'Without config' do
      let(:destination) { "test_destination"}
      it 'Should fail' do
        expect { command.prepare_capistrano(destination) }.to raise_error
      end
    end

  end    
end