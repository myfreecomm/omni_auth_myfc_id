require 'omniauth/oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    #
    # Authenticate to MyfcId via OAuth and retrieve an access token for API usage
    #
    # Usage:
    #
    #    use OmniAuth::Strategies::MyfcId, 'consumerkey', 'consumersecret', {:site=> 'http://stage.id.myfreecomm.com.br', :scope => 'application-slug'}
    #
    class MyfcId < OmniAuth::Strategies::OAuth      
      def initialize(app, consumer_key, consumer_secret, options = {})
        @scope = options.delete(:scope)
        @site = options.delete(:site) || 'https://id.myfreecomm.com.br'
        super(app, :myfcid, consumer_key, consumer_secret,
                options.merge({:site => @site ,
                :request_token_path => "/sso/initiate",
                :authorize_path     => "/sso/authorize",
                :access_token_path  => "/sso/token",
                :signature_method => "PLAINTEXT"
              }))
        @consumer.options.merge!({:form_data => {'scope' => @scope}})
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
          result = @access_token.post('/sso/fetchuserdata', nil, {'scope' => @scope})
          @data ||= MultiJson.decode(result.body)
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