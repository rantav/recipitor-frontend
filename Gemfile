source 'http://rubygems.org'

gem 'rails', '3.0.4'

if defined?(JRUBY_VERSION)
  gem 'jdbc-sqlite3'
  gem 'activerecord-jdbc-adapter'
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'jruby-openssl'
  gem 'jruby-rack'
  gem 'warbler'
else
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

# paperclip and s3 storage
gem 'paperclip'
gem 'aws-s3', :require => 'aws/s3'

# User management
gem 'devise'
gem 'cancan'
gem 'devise_invitable', '~> 0.3.4'
gem 'haml'
gem 'haml-rails'
gem 'will_paginate', '3.0.pre2'
gem 'hpricot'
gem 'ruby_parser'
gem 'web-app-theme'

gem 'jquery-rails', '>= 0.2.6'

# resource managemet (CSS, JS)
gem "jammit", :git => "git://github.com/documentcloud/jammit.git"
gem "closure-compiler"

# Amazon Simple Queue Service SQS
gem 'aws'

# http://flori.github.com/json/
gem 'json'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug19', :require => 'ruby-debug'

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
