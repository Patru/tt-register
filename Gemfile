source 'https://rubygems.org'

ruby "1.9.2"
gem 'rails', '=3.2.22.5'

gem 'erector', '~>0.9.0'
gem 'capistrano', '3.2.1'
gem 'sqlite3'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'dynamic_form'
gem 'json'
gem 'http_accept_language'
group :assets do
  gem 'sass-rails', "~>3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>=1.0.3'
end

gem 'i18n', '~> 0.6.11'     # do away with this once you update ruby
gem 'rack-cache', '1.2.0'   # do away with this once you update ruby
gem 'public_suffix', '1.3.3'  # do away with this once you update ruby
gem 'net-ssh', '~> 2.9'  # do away with this once you update ruby
gem 'babosa', '~> 0.3.11'
#gem 'nokogiri', '~> 1.6.8'
gem 'nokogiri', '1.6.3.1'
#gem 'ref', '~> 1.0', '>= 1.0.5'
#gem 'highline', '~> 1.6.21', '>= 1.6.21'
#gem 'acts-as-taggable-on', '3.0.2'
#gem 'rails_autolink', '1.1.4'

group :test, :development do
  gem 'minitest-rails-capybara'
  gem 'minitest-capybara'
  gem 'minitest-matchers'
  gem 'capybara', "~>2.0.0"   # upgrade this with Ruby 1.9.3
  gem 'capybara_minitest_spec'
  gem 'minitest-spec-rails'
  gem 'minitest-spec-context'
  gem 'minitest-reporters'
  gem 'capybara-email'
  gem 'launchy'
  gem 'rdoc'
  gem 'ruby-prof', "~> 0.13.0"
  gem "capybara-webkit"
  gem 'rake', '~>10.5.0'      # do away with this once you update ruby
end

group :development do
  gem 'capistrano-rails',   '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-rbenv',   '~> 2.0', require: false
end

group :production do
  gem 'pg'
  gem 'libv8', "~>3.11.8.1"
  gem 'therubyracer', "~>0.11.4"
end
