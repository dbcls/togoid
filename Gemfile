source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

gem 'rails', '~> 5.2.2', '>= 5.2.2.1'

# middleware
gem 'foreman', '~> 0.85.0', require: false
gem 'puma', '~> 3.11'
gem 'unicorn', '~> 5.4', require: false

gem 'hamlit', '~> 2.9'
gem 'hamlit-rails', '~> 0.2.2'
gem 'jbuilder', '~> 2.5'

# js/css
gem 'coffee-rails', '~> 4.2'
gem 'sass-rails', '~> 5.0'
gem 'webpacker'

# optimization
gem 'bootsnap', '>= 1.1.0', require: false
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

# utils
gem 'dotenv-rails', '~> 2.7'
gem 'faraday', '~> 0.15.4'
gem 'faraday_middleware', '~> 0.13.1'
gem 'linkeddata', '~> 3.0', '>= 3.0.1'

group :development, :test do
  gem 'awesome_print'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-byebug', '~> 3.7'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec', '~> 3.8'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
