# frozen_string_literal: true

require_relative 'config/application'

Rails.application.load_tasks

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

desc 'Run Eslint'
task :eslint do
  system './node_modules/.bin/eslint app/assets/javascripts'
end

task default: %i[rubocop eslint test]
