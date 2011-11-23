require 'omniauth/oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    #
    # Authenticate to PassaporteWeb via OAuth and retrieve an access token for API usage
    #
    # Usage:
    #
    #    use OmniAuth::Strategies::PassaporteWeb, 'consumerkey', 'consumersecret', {:site=> 'http://sandbox.app.passaporteweb.com.br'}
    #
    class PassaporteWeb < OmniAuth::Strategies::OAuth      
      def initialize(app, consumer_key, consumer_secret, options = {})
        @site = options.delete(:site) || 'https://sandbox.app.passaporteweb.com.br'
        super(app, :passaporte_web, consumer_key, consumer_secret,
                options.merge({:site => @site ,
                :request_token_path => "/sso/initiate",
                :authorize_path     => "/sso/authorize",
                :access_token_path  => "/sso/token",
                :signature_method => "PLAINTEXT"
              }))
      end
      
      def auth_hash
        OmniAuth::Utils.deep_merge(super, {
          'uid' => user_data['uuid'],
          'user_info' => user_info,
          'extra' => {
            'user_hash' => user_data
          }
        })
      end
      
      protected

        def user_data
          @result ||= @access_token.post('/sso/fetchuserdata', nil)
          @data ||= MultiJson.decode(@result.body)
        end
      
        def user_info
          {
            'nickname' => user_data['nickname'],
            'email' => user_data['email'],
            'first_name' => user_data['first_name'],
            'last_name' => user_data['last_name'],
            'name' => [user_data['first_name'], user_data['last_name']].join(' ').strip,
          }
        end

    end
  end
end