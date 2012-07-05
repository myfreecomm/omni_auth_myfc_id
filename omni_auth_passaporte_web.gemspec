# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name = %q{omni_auth_passaporte_web}
  s.version = "2.0.0"
  s.authors = ["Marcos Tapajos"]
  s.email = ["marcos@tapajos.me"]
  s.homepage = %q{http://myfreecomm.com.br}
  s.summary = %q{Autenticação via SSO usando o Passaporte Web}
  s.description = s.summary
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency('oa-oauth', '0.3.2')
  s.add_development_dependency('rspec', '2.6.0')
  s.add_development_dependency('rake', '0.8.4')
end
