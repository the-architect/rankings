require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec') do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = %w[--color]
end

task :default => :spec


desc 'seed database with some user data'
task :seed do
  require 'rankings'

  10000.times do |i|
    Rankings::User.create(i, "User #{i}", { 'overall' => rand(i*10).to_i+10, 'xp' => rand(i*10).to_i+10, 'might' => rand(i*10).to_i+10, 'honor' => rand(i*10).to_i+10 })
  end
end
