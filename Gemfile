source 'https://rubygems.org'
ruby "1.9.3"
gem 'rails', '3.2.14'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'



# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end
# support for httparty
gem "httparty", "~> 0.11.0"
 

# support for fakeWeb
gem "fakeweb", "~> 1.3.0"

# support for facebook authentication
gem "omniauth-facebook"

# allows open('http://...') to return body
gem "rest-open-uri", "~> 1.0.0", :require => false

# XML parser
gem "nokogiri", "~> 1.6.0"

# support for miniFB
gem 'mini_fb'

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

#Layout
gem "haml-rails"
gem 'turbolinks'

# To use debugger
gem 'factory_girl', '~> 2.2'
gem 'factory_girl_rails', :require => false
gem 'faker'
group :development, :test do
  gem 'simplecov'
  gem 'webrat'
  gem 'rspec-rails', '~> 2.0'
  gem 'simplecov', :require => false
  gem 'sqlite3'
  gem 'cucumber'
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'debugger'
  gem 'dotenv-rails', '~> 0.9.0'
  
end

#Test JS
group :test do
  gem "selenium-webdriver", "~> 2.35.1"
  gem 'capybara-webkit'
end

