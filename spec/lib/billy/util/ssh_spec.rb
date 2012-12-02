require 'billy/util/ssh'

describe Billy::Util::Ssh do
  
  let!( :ssh ) { Billy::Util::Ssh }
  let!( :pub_keys ) { {
    :id_rsa => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmT9fD1BRKvhKTMXFjtsmlrGcwV5+B9Vfcd56S/UfZddrN7Up7mjejnXp1YH2wc04FJ1+MtkelhLDADbShVK6IdlJJeBWVDZAQ3WYJJA46SYvJcpYo6t/2BHqBoISjmt/DO09d6Dynmh1jvTQEXggZUpQKwyEKyghHpd10e7CYEEuziH0ALTcXC78Xp5W8Zc1XuqzPizyJtyYhr8fTJEzWQ0VUH/5NV1/2VSUKdawd2xhz8uhCzRna61XhtC4JdwhWe97dWOSXj9dqiVMDoUqSRQkK++m564TqxEZxlLVnpHNKwjcDa4+AX24w8OTrAFJCRyIv12e4MTGzGh469bfd me@4pcbr.com',
    :id_dsa => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmT9fD1BRKvhKTMXFjtsmlrGcwV5+B9Vfcd56S/UfZddrN7Up7mjejnXp1YH2wc04FJ1+MtkelhLDADbShVK6IdlJJeBWVDZAQ3WYJJA46SYvJcpYo6t/2BHqBoISjmt/DO09d6Dynmh1jvTQEXggZUpQKwyEKyghHpd10e7CYEEuziH0ALTcXC78Xp5W8Zc1XuqzPizyJtyYhr8fTJEzWQ0VUH/5NV1/2VSUKdawd2xhz8uhCzRna61XhtC4JdwhWe97dWOSXj9dqiVMDoUqSRQkK++m564TqxEZxlLVnpHNKwjcDa4+AX24w8OTrAFJCRyIv12e4MTGzGh469bfd me@4pcbr.com'
  } }
  
  describe 'get_pub_key' do
    
    before :each do
      ssh.stub!( :pub_keys ) { pub_keys }
      ssh.stub!( :ssh_folder_exists? ) { true }
    end
    
    it 'Should return id_rsa key with no type given' do
      ssh.get_pub_key.should eq pub_keys[ :id_rsa ]
    end
    
    it 'Should return key with type given' do
      ssh.get_pub_key( :id_dsa ).should eq pub_keys[ :id_dsa ]
    end
  end
  
end