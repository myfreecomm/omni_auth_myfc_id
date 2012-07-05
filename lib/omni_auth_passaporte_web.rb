$:.unshift(File.dirname(__FILE__))

gem 'oa-oauth'

require 'omniauth/oauth'
require 'oauth/signature/plaintext'
require 'omni_auth_passaporte_web/passaporte_web'