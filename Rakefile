require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.test_files = FileList['test/*.rb'] + FileList['test/*/*.rb']
  test.verbose = true
end

task :default => [:test]
