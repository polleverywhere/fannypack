require "bundler/gem_helper"

task :default => [:spec]

desc "Run jasmine specs"
task :spec do
  sh %[bundle exec jasmine-headless-webkit -c]
end

# run the spec and keep the html file output.
# also clears out previous saved output files
desc "Debug specs"
task :debug do
  sh %[rm -f jhw.* && bundle exec jasmine-headless-webkit -c --keep]
end
