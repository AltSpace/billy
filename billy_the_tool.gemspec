# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{billy_the_tool}
  s.version = "0.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["4pcbr"]
  s.date = %q{2013-04-10}
  s.default_executable = %q{billy}
  s.description = %q{Billy is simplified deploy system based on top of capistrano}
  s.email = %q{me@4pcbr.com}
  s.executables = ["billy"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "bin/billy",
    "lib/billy.rb",
    "lib/billy/commands.rb",
    "lib/billy/commands/command.rb",
    "lib/billy/commands/config.rb",
    "lib/billy/commands/eat.rb",
    "lib/billy/commands/hello.rb",
    "lib/billy/commands/my.rb",
    "lib/billy/commands/walk.rb",
    "lib/billy/config.rb",
    "lib/billy/session.rb",
    "lib/billy/util/scm/git.rb",
    "lib/billy/util/scm/scm.rb",
    "lib/billy/util/ssh.rb",
    "lib/billy/util/ui.rb"
  ]
  s.homepage = %q{http://github.com/AltSpace/billy}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{Billy the tool}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>, ["~> 2.13.5"])
      s.add_runtime_dependency(%q<colorize>, ["~> 0.5.8"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.2.2"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.12.0"])
    else
      s.add_dependency(%q<capistrano>, ["~> 2.13.5"])
      s.add_dependency(%q<colorize>, ["~> 0.5.8"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.2.2"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.12.0"])
    end
  else
    s.add_dependency(%q<capistrano>, ["~> 2.13.5"])
    s.add_dependency(%q<colorize>, ["~> 0.5.8"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.2.2"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.12.0"])
  end
end

