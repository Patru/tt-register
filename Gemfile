source 'https://rubygems.org'

ruby "1.9.3"
gem 'rails', '=3.2.22.5'

gem 'erector', '~>0.10.0'
gem 'capistrano', '~>3.4.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'dynamic_form'
gem 'json'
gem 'http_accept_language'
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier'
end

gem 'i18n', '~> 0.7'     # do away with this once you update ruby
gem 'nokogiri', '~> 1.6.8'
#gem 'ref', '~> 1.0', '>= 1.0.5'
#gem 'highline', '~> 1.6.21', '>= 1.6.21'
#gem 'acts-as-taggable-on', '3.0.2'
#gem 'rails_autolink', '1.1.4'

group :test, :development do
  gem 'sqlite3'
  gem 'minitest', '~>4.7.0'
  gem 'minitest-rails-capybara'
  gem 'minitest-capybara'
  gem 'minitest-matchers'
  gem 'capybara'
  gem 'capybara_minitest_spec', '~>1.0.0'
  gem 'minitest-spec-rails', '~> 4.3'
  gem 'minitest-spec-context'
  gem 'minitest-reporters'
  gem 'capybara-email'
  gem 'launchy'
  gem 'rdoc'
  gem 'ruby-prof'
  gem "capybara-webkit"
  gem 'rake'
  gem 'public_suffix', '~>1.4.0'
end

group :development do
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
  gem 'net-ssh', '~>2.9.0'
end

group :production do
  gem 'pg', '~>0.18.0'
  gem 'libv8', "~>5.3.332.38"
#  gem 'therubyracer'
end
