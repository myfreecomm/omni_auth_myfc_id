# encoding: utf-8

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "omni_auth_myfc_id"
    gemspec.summary = "summary"
    gemspec.email = ["marcos@tapajos.me"]
    gemspec.homepage = "http://myfreecomm.com.br"
    gemspec.description = "description"
    gemspec.authors = ["Marcos Tapajós"]
    gemspec.add_dependency('oa-oauth', '0.2.6')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

gem "rspec", "> 2.0"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec