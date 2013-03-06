# encoding: utf-8
module OmniAuth
  module Strategies
    #
    # Authenticate to PassaporteWeb via OAuth and retrieve an access token for API usage
    #
    # Usage:
    #
    #    use OmniAuth::Strategies::PassaporteWeb, 'consumerkey', 'consumersecret', :client_options => {:site => 'http://sandbox.app.passaporteweb.com.br'}
    #
    class PassaporteWeb < OmniAuth::Strategies::OAuth

      # Give your strategy a name.
      option :name, "passaporte_web"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        :site => "http://sandbox.app.passaporteweb.com.br",
        :request_token_path => "/sso/initiate",
        :authorize_path => "/sso/authorize",
        :access_token_path => "/sso/token",
        :signature_method => "PLAINTEXT",
        :include_expired_service_accounts => false
      }

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      # uid{ request.params['uuid'] }
      uid{ user_data['uuid'] }

      info do
        {
          'uuid' => user_data['uuid'],
          'nickname' => user_data['nickname'],
          'email' => user_data['email'],
          'first_name' => user_data['first_name'],
          'last_name' => user_data['last_name'],
          'name' => [user_data['first_name'], user_data['last_name']].join(' ').strip,
        }
      end

      extra do
        {
          'user_hash' => user_data
        }
      end

      def user_data
        @result ||= access_token.post('/sso/fetchuserdata', fetch_user_data_post_body)
        @user_data ||= MultiJson.decode(@result.body)
      end

      def fetch_user_data_post_body
        options['client_options']['include_expired_service_accounts'] ? {:include_expired_accounts => true} : nil
      end

    end
  end
end
