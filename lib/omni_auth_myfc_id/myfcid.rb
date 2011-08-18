require 'omniauth/oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    #
    # Authenticate to Myfcid via OAuth and retrieve an access token for API usage
    #
    # Usage:
    #
    #    use OmniAuth::Strategies::Myfcid, 'consumerkey', 'consumersecret', {:site=> 'http://stage.id.myfreecomm.com.br'}
    #
    class Myfcid < OmniAuth::Strategies::OAuth      
      def initialize(app, consumer_key, consumer_secret, options = {})
        @site = options.delete(:site) || 'https://id.myfreecomm.com.br'
        super(app, :myfcid, consumer_key, consumer_secret,
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