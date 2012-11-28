# Billy the tool

## Commands

### Setup existing project
* billy hello
* billy eat {billy_config}

### Deploy existing project
* billy walk {app_name}

## Sample config file

```
deploy_to: /var/web/
user: user
server: 192.168.216.93
```

## Install

```bash
gem install billy --source http://gems.undev.cc
```

## Usage

```bash
cd ~
billy eat http://192.168.216.93/billy.cfg
cd project_name
billy walk project_name
open http://192.168.216.93/project_name/index.html
```