# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'activerecord-session_store'
gem 'bcrypt'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'devise', :github => 'heartcombo/devise', branch: 'master'
gem 'dotenv-rails'
gem 'jbuilder'
gem 'mysql2'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-twitter', :github => 'arunagw/omniauth-twitter', branch: 'master'
gem 'puma'
gem 'rails-i18n'
gem 'rails', '~> 6.0.0'
gem 'rufus-lua'

group :development do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  gem 'hirb'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https:
  gem 'spring'
  # Compiling static assets.
  gem 'mini_racer', platforms: :ruby
  gem 'sass-rails', '>= 6'
  gem 'uglifier'
end

group :test do
  gem 'capybara'
  gem 'rspec'
end
