$:.unshift(File.dirname(__FILE__))

gem 'oa-oauth', '0.1.6'

require 'omniauth/oauth'
require 'oauth/signature/plaintext'
require 'omni_auth_myfc_id/myfcid'