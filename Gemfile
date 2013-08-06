source 'https://rubygems.org'

ruby "1.9.2"
gem 'rails', '=3.2.14'

gem 'erector', '~>0.9.0'
gem 'sqlite3'
gem 'capistrano'
gem 'jquery-rails'
gem 'dynamic_form'
gem 'json'
gem 'http_accept_language'
group :assets do
  gem 'sass-rails', "~>3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>=1.0.3'
end

group :test, :development do
  gem 'minitest-rails'
  gem 'minitest-rails-capybara'
  gem 'capybara', "~>2.0.0"   # upgrade this with Ruby 1.9.3
  gem 'minitest-spec-rails'
  gem 'minitest-spec-context'
  gem 'minitest-reporters'
  gem 'capybara-email'
  gem 'launchy'
  gem 'rdoc'
  gem 'ruby-prof'
  gem "capybara-webkit"
end

group :production do
  gem 'pg'
  gem 'libv8'
  gem 'therubyracer'
end