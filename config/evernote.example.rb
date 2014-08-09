# Load libraries required by the Evernote OAuth
require 'oauth'
require 'oauth/consumer'

# Load Thrift & Evernote Ruby libraries
require "evernote_oauth"

# Client credentials
OAUTH_CONSUMER_KEY = ""
OAUTH_CONSUMER_SECRET = ""

# Connect to Sandbox server?
SANDBOX = true