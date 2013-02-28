require File.dirname(__FILE__) + '/../spec_helper'

describe OmniAuth::Strategies::PassaporteWeb do

  before(:each) do
    @access_token_mock = mock("AccessToken")
    @passaporte_web = OmniAuth::Strategies::PassaporteWeb.new("my_sample_app", "my_consumer_key", "my_consumer_secret")
    @passaporte_web.instance_variable_set(:@access_token, @access_token_mock)
  end

  it "should set consumer options" do
    @passaporte_web.consumer.options.should == {
      :request_token_path=>"/sso/initiate",
      :proxy=>nil,
      :http_method=>:post,
      :signature_method=>"PLAINTEXT",
      :authorize_path=>"/sso/authorize",
      :oauth_version=>"1.0",
      :access_token_path=>"/sso/token",
      :scheme=>:header,
      :site=>"http://sandbox.app.passaporteweb.com.br"
    }
  end

  describe ".auth_hash" do
    it "should return auth_hash using server" do
      @access_token_mock.should_receive(:token).twice.and_return("token")
      @access_token_mock.should_receive(:secret).twice.and_return("secret")
      @access_token_mock.should_receive(:post).with("/sso/fetchuserdata", nil).once.and_return(mock(:body => "{\"nickname\":\"nick\",\"last_name\":\"Tapajos\",\"email\":\"mail\",\"first_name\":\"Marcos\"}"))
      @passaporte_web.auth_hash.to_hash.should == {"provider"=>"passaporte_web", "uid"=>nil, "info"=>{"uuid"=>nil, "nickname"=>"nick", "email"=>"mail", "first_name"=>"Marcos", "last_name"=>"Tapajos", "name"=>"Marcos Tapajos"}, "credentials"=>{"token"=>"token", "secret"=>"secret"}, "extra"=>{"access_token"=>@access_token_mock, "user_hash"=>{"nickname"=>"nick", "last_name"=>"Tapajos", "email"=>"mail", "first_name"=>"Marcos"}}}
    end
  end

end
