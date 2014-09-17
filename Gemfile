source 'https://rubygems.org'

# Distribute your app as a gem
# gemspec

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Optional JSON codec (faster performance)
# gem 'oj'

# Project requirements
gem 'rake'

# Component requirements
gem 'bcrypt'
gem 'sass'
gem 'slim'
gem 'mongoid', '~>3.0.0'
gem 'mongoid_search', '~> 0.3.2'

# Test requirements
# gem 'rspec', :group => 'test'
# gem 'rack-test', :require => 'rack/test', :group => 'test'

# Padrino Stable Gem
gem 'padrino', '0.12.2'

# Markdown gems
gem 'redcarpet', '~> 3.1.2'
gem 'reverse_markdown', '~> 0.5.1'

# Evernote
gem 'evernote_oauth', '~> 0.2.3'

# PDF Export
gem 'pdfkit', '~> 0.6.2'

# CRON tasks
gem 'whenever', '~> 0.9.2'

group :development do
  # Deployment
  gem 'byebug', '~> 3.2.0'
  gem 'capistrano', '~> 3.2.1'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano3-unicorn'
end

group :deployment do
  gem "unicorn"
end

