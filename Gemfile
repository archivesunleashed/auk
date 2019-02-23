# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.3', '< 1.4'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a
  # debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'simplecov'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :production do
  gem 'pg', '1.1.3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

## AUK
gem 'attr_encrypted'
gem 'bootstrap', '~> 4.3.1' # https://nvd.nist.gov/vuln/detail/CVE-2019-8331
gem 'bootstrap_form',
    git: 'https://github.com/bootstrap-ruby/bootstrap_form.git',
    branch: 'master'
gem 'codecov', require: false, group: :test
gem 'daemons'
gem 'delayed-web'
gem 'delayed_job_active_record'
gem 'ffi', '>= 1.9.24' # https://nvd.nist.gov/vuln/detail/CVE-2018-1000201
gem 'figaro'
gem 'font-awesome-rails'
gem 'http'
gem 'humanize_boolean'
gem 'jquery-rails'
gem 'kaminari'
gem 'logstash-logger'
gem 'loofah', '>= 2.2.3' # https://nvd.nist.gov/vuln/detail/CVE-2018-16468
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'os'
gem 'parallel'
gem 'rack', '>= 2.0.6' # https://nvd.nist.gov/vuln/detail/CVE-2018-16471 https://nvd.nist.gov/vuln/detail/CVE-2018-16470
gem 'rails-html-sanitizer', '~> 1.0.4' # https://nvd.nist.gov/vuln/detail/CVE-2018-3741
gem 'rubocop', '~> 0.61.1'
gem 'rubocop-rspec', '~> 1.30.1'
gem 'rubyzip', '>= 1.2.2' # https://nvd.nist.gov/vuln/detail/CVE-2018-1000544
gem 'sitemap_generator'
gem 'slack-notifier'
gem 'sys-filesystem'
gem 'time_difference'
