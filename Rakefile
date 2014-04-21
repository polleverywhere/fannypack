require "bundler/gem_tasks"

namespace :jasmine do
  task :configure do
    require 'jasmine/config'

    begin
      Jasmine.load_configuration_from_yaml(ENV['JASMINE_CONFIG_PATH'])
    rescue Jasmine::ConfigNotFound => e
      puts e.message
      exit 1
    end
  end

  task :require do
    require 'jasmine'
  end

  task :require_json do
    begin
      require 'json'
    rescue LoadError
      puts "You must have a JSON library installed to run jasmine:ci. Try \"gem install json\""
      exit
    end
  end

  desc 'Run continuous integration tests'
  task :ci => %w(jasmine:require_json jasmine:require jasmine:configure) do
    config = Jasmine.config

    pid = spawn "foreman start -p #{config.port(:ci)}"

    sleep 5

    formatters = config.formatters.map { |formatter_class| formatter_class.new }

    exit_code_formatter = Jasmine::Formatters::ExitCode.new
    formatters << exit_code_formatter

    url = "#{config.host}:#{config.port(:ci)}/specs/jasmine"
    runner = config.runner.call(Jasmine::Formatters::Multi.new(formatters), url)
    runner.run

    break unless exit_code_formatter.succeeded?

    Process.kill "TERM", pid
    exit
  end
end