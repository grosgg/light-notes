# Defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development'  unless defined?(RACK_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

Padrino::Logger::Config[:deployment] = { :log_level => :info, :stream => :to_file }

##
# ## Enable devel logging
#
# Padrino::Logger::Config[:development][:log_level]  = :devel
# Padrino::Logger::Config[:development][:log_static] = true
#
# ## Configure your I18n
#
# I18n.default_locale = :en
# I18n.enforce_available_locales = false
#
# ## Configure your HTML5 data helpers
#
# Padrino::Helpers::TagHelpers::DATA_ATTRIBUTES.push(:dialog)
# text_field :foo, :dialog => true
# Generates: <input type="text" data-dialog="true" name="foo" />
#
# ## Add helpers to mailer
#
# Mail::Message.class_eval do
#   include Padrino::Helpers::NumberHelpers
#   include Padrino::Helpers::TranslationHelpers
# end

##
# Add your before (RE)load hooks here
#
Padrino.before_load do
  Padrino.dependency_paths << Padrino.root('config/evernote.rb')
	Padrino.dependency_paths << Padrino.root('config/secret.rb')
	# if OAUTH_CONSUMER_KEY.empty? || OAUTH_CONSUMER_SECRET.empty?
 #    halt '<span style="color:red">Evernote settings are missing!</span>'
 #  end
end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
  Padrino.use Rack::SSL if Padrino.env == :deployment
end

Padrino.load!
