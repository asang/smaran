# vi:set et ts=2 sw=2 ai ft=ruby:
source 'http://rubygems.org'
ruby '2.0.0'
#ruby-gemset=smaran

gem 'rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 4.0.5'
gem 'prototype-rails', :git => 'git://github.com/rails/prototype-rails.git'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'protected_attributes'
gem 'paperclip'
gem 'spreadsheet'
gem 'prawn'
gem 'authlogic'
gem 'scrypt'
gem 'bcrypt'
# searchlogic doesn't work with rails 3.0 yet.
# gem 'meta_search'
gem 'attr_encrypted'
gem 'mysql2'
gem 'will_paginate'
gem 'RedCloth', '>= 4.1.1'
gem 'redcarpet'
gem 'sqlite3'
gem 'rake'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
PLATFORM_IS_OSX     = (Object::RUBY_PLATFORM =~ /darwin/i) ? true : false
if PLATFORM_IS_OSX
  gem "rb-inotify", "~> 0.9", :require => false
else
  gem "rb-inotify", "~> 0.9"
end

group :test do
  gem "rspec-rails", "~> 3.1.0"
  gem "cucumber"
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner', '< 1.1.0'
  gem "factory_girl_rails"
  gem "capybara"
  gem "guard-rspec"
  if not PLATFORM_IS_OSX
    gem 'capybara-webkit'
  end
  gem 'aruba'
  gem 'rspec-collection_matchers'
end
# Needed for the new asset pipeline
gem 'sass-rails', github: 'rails/sass-rails'
gem 'coffee-rails'
gem 'uglifier'

gem 'paper_trail'
gem 'rails-observers'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'
gem 'execjs'
gem 'therubyracer', :platforms => :ruby
gem 'less-rails'
