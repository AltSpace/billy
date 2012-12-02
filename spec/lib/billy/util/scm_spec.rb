require 'billy/util/scm/git'

describe Billy::Util::Git do
  
  let!( :git ) { Billy::Util::Git.new }
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
    Billy::Util::UI.stub( :inform ) {}
  end
  
  describe 'get_repository_path' do

    before :each do
      git.stub!( :local_repository_exists? ) { true }
      git.stub!( :get_git_config ) { git_config }
      git.stub!( :remote_repository_exists? ) { true }
    end
    
    it 'returns first remote path' do
      Billy::Util::UI.stub!( :gets ) { "1\n" }
      git.get_repository_path.should eq url1
    end
    
    it 'returns first remote path' do
      Billy::Util::UI.stub!( :gets ) { "2\n" }
      git.get_repository_path.should eq url2
    end
    
  end
  
  describe 'remote_repository_exists?' do
    
    it 'Returns true for config with remotes' do
      git.remote_repository_exists?( git_config ).should be_true
    end
    
    it 'Returns false for config without remotes' do
      git.remote_repository_exists?( git_config_without_remotes ).should be_false
    end
    
  end
  
  describe 'get_remotes' do
    it 'Returns all remotes' do
      git.get_remotes( git_config ).should eq remotes
    end
  end
  
  describe 'init_repository' do
    it 'forces system to call git init' do
      system_arg = nil
      git.stub!( :system ) { |arg| system_arg = arg }
      git.init_repository
      system_arg.should eq "git init ."
    end
  end
  
end