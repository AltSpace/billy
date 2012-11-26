# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "billy"
  gem.homepage = "http://github.com/AltSpace/billy"
  gem.license = "MIT"
  gem.summary = %Q{Billy the tool}
  gem.description = %Q{Billy is simplified deploy system working on top of prepared backend}
  gem.email = "me@4pcbr.com"
  gem.authors = ["4pcbr"]
  gem.executables = %w(billy)
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec