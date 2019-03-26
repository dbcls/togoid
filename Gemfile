source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

gem 'rails', '~> 5.2.2', '>= 5.2.2.1'

gem 'puma', '~> 3.11'

gem 'jbuilder', '~> 2.5'

# js/css
gem 'coffee-rails', '~> 4.2'
gem 'sass-rails', '~> 5.0'
gem 'webpacker'

# optimization
gem 'bootsnap', '>= 1.1.0', require: false
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec', '~> 3.8'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
