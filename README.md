# Billy the tool

## Intro

Billy is very simple deploy application built on top of [capistrano](https://github.com/capistrano/capistrano). This tool may be useful for designers and html programmers to simplify roll out process on staging server.

Deploy model undermeans single staging server and deploying from `master` branch only.

## Install

Billy distributes as [ruby gem](http://rubygems.org/gems/billy_the_tool), requires ruby 1.8.7+ and superuser privileges in case of global system installation (not [rvm](https://rvm.io/)).

Open your terminal ( on MacOS: ⌘ + Space, then type `terminal` in search bar ). When terminal window is opened:

```
sudo gem install billy_the_tool --no-rdoc
```
If everything is ok this command will ask you to provide superuser password and then install billy on your system.

## Setup
* billy hello
* billy eat {url_to_billy_config_or_local_file}

`billy hello` will check all the system requirements and will give some helpful info. Billy will great you if all the requirements are satisfied And prompt to install otherwise.

`billy eat {url_to_billy_config_or_local_file}` will parse config file with specified path and save it to current folder. `url_to_billy_config_or_local_file` could be local file path or remote file url. Spaeking of deploy process billy will check both current and home folders while looking for config file. Billy stores it's settings in file named `.billyrc`.

### Sample config file

```
deploy_to: /var/www/
user: user
server: staging.server.com
```

### Get current config

```bash
billy my config
```

This command will return config settings from current folder if there wis .billyrc file, home settings from ~/.billyrc otherwise.

### GIT dependency
Billy hopes to find git repository inside your project with existing remote. You haven't say billy where your remote is. It checks for `.git/config` file and grabs all the remotes inside.

After config file is set up and you have pushed all the changes you've done Billy is ready to deploy.

## Usage

Here I will show how to download remote config file to my local folder and then deploy some project_name to staging server:

```bash
cd ~
billy eat http://staging.server.com/billy.cfg
cd project_name
billy walk project_name
open http://staging.server.com/project_name/index.html
```

### SSH keys management

Authorization uses ssh keys only, no password auth.

Auth process:
deployer → ssh → staging server → ssh → git remote repository

This scheme requires deployer publick key to be placed on staging server and staging server publick key on remote git server.

### Get my ssh key

```bash
billy my key
```

This command will return one of your ssh keys, id_rsa.pub by default