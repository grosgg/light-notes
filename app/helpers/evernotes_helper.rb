# Helper methods defined here can be accessed in any controller or view in the application

module LightNotes
  class App
    module EvernotesHelper

      def define_client
        @client ||= EvernoteOAuth::Client.new(token: current_account.evernote_token, consumer_key:OAUTH_CONSUMER_KEY, consumer_secret:OAUTH_CONSUMER_SECRET, sandbox: SANDBOX)
      end

    end
    helpers EvernotesHelper
  end
end
