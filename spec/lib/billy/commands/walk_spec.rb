require 'billy/commands/walk'

describe Billy::Commands::Walk do
  let!( :command ) { Billy::Commands::Walk.instance }
  let!( :url1 ) { 'gitorious@git.undev.cc:digital-october/panels.git' }
  let!( :url2 ) { 'git@github.com:4pcbr/panels.git' }
  let!( :git_config ) {
    <<-EOS
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
	ignorecase = true
[remote "origin"]
	url = #{url1}
	fetch = +refs/heads/*:refs/remotes/origin/*
[remote "gh"]
	url = #{url2}
	fetch = +refs/heads/*:refs/remotes/gh/*
EOS
  }
  
  let!( :git_config_without_remotes ) {
    <<-EOS
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
	ignorecase = true
EOS
  }
  let!( :remotes ) { [
    [ "origin", url1 ],
    [ "gh", url2 ]
  ] }
  
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
    
    stub!( :system ) { |arg| p arg }
    
    Capistrano::Configuration.any_instance.stub( :execute! ) {}
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
  
  describe 'get_repository_path' do
    
    before :each do
      command.stub!( :local_repository_exists? ) { true }
      command.stub!( :get_git_config ) { git_config }
      command.stub!( :remote_repository_exists? ) { true }
    end
    
    it 'returns first remote path' do
      command.stub!( :gets ) { "1\n" }
      command.get_repository_path.should eq url1
    end
    
    it 'returns first remote path' do
      command.stub!( :gets ) { "2\n" }
      command.get_repository_path.should eq url2
    end
    
  end
  
  describe 'remote_repository_exists?' do
    
    it 'Returns true for config with remotes' do
      command.remote_repository_exists?( git_config ).should be_true
    end
    
    it 'Returns false for config without remotes' do
      command.remote_repository_exists?( git_config_without_remotes ).should be_false
    end
    
  end
  
  describe 'get_remotes' do
    it 'Returns all remotes' do
      command.get_remotes( git_config ).should eq remotes
    end
  end
  
  describe 'init_git_repository' do
    
    it 'forces system to call git init' do
      system_arg = nil
      command.stub!( :system ) { |arg| system_arg = arg }
      command.init_git_repository
      system_arg.should eq "git init ."
    end
    
  end
end