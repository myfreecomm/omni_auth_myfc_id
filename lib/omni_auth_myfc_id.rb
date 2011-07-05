$:.unshift(File.dirname(__FILE__))

gem 'oa-oauth', '0.2.6'

require 'omniauth/oauth'
require 'oauth/signature/plaintext'
require 'omni_auth_myfc_id/myfcid'