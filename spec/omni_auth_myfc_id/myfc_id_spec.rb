require File.dirname(__FILE__) + '/../spec_helper'

describe OmniAuth::Strategies::Myfcid do
  
  before(:each) do
    @access_token_mock = mock("AccessToken")
    @myfc_id = OmniAuth::Strategies::Myfcid.new("my_sample_app", "my_consumer_key", "my_consumer_secret", {:scope => 'my_scope'})
    @myfc_id.instance_variable_set(:@access_token, @access_token_mock)
  end
  
  it "should set consumer options" do
    @myfc_id.instance_variable_get(:@consumer).options.should == {:request_token_path=>"/sso/initiate",
                                                                  :proxy=>nil,
                                                                  :http_method=>:post,
                                                                  :signature_method=>"PLAINTEXT",
                                                                  :authorize_path=>"/sso/authorize",
                                                                  :oauth_version=>"1.0",
                                                                  :access_token_path=>"/sso/token",
                                                                  :form_data=>{"scope"=>"my_scope"},
                                                                  :scheme=>:header,
                                                                  :site=>"https://id.myfreecomm.com.br"}
  end
  
  describe ".auth_hash" do

    it "should return auth_hash using server" do
      @access_token_mock.should_receive(:token).and_return("token")
      @access_token_mock.should_receive(:secret).and_return("secret")
      @access_token_mock.should_receive(:post).with("/sso/fetchuserdata", nil, {"scope"=>"my_scope"}).at_least(:once).and_return(mock(:body => "{\"nickname\":\"nick\",\"last_name\":\"Tapajos\",\"email\":\"mail\",\"first_name\":\"Marcos\"}"))
      @myfc_id.auth_hash.should == {
        "user_info"=>{"name"=>"Marcos Tapajos", "nickname"=>"nick", "last_name"=>"Tapajos", "first_name"=>"Marcos", "email"=>"mail"}, 
        "uid"=>nil, 
        "credentials"=>{"token"=>"token", "secret"=>"secret"}, 
        "extra"=>{"user_hash"=>{"nickname"=>"nick", "last_name"=>"Tapajos", "first_name"=>"Marcos", "email"=>"mail"}, 
        "access_token"=>@access_token_mock}, 
        "provider"=>"myfcid"
      }
    end

  end
  
end