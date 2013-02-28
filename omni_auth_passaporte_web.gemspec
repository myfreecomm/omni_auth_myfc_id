# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name = %q{omni_auth_passaporte_web}
  s.version = "3.0.0"
  s.authors = ["Rodrigo Tassinari de Oliveira", "Marcos Tapajos"]
  s.email = ["rodrigo@pittlandia.net", "marcos@tapajos.me"]
  s.homepage = %q{http://myfreecomm.com.br}
  s.summary = %q{Autenticação via SSO usando o Passaporte Web}
  s.description = s.summary
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency('omniauth-oauth', '~> 1.0.1')
  s.add_dependency('multi_json', '>= 1.0.4')
  s.add_development_dependency('rspec', '~>  2.13.0')
  s.add_development_dependency('rake', '~> 10.0.3')
end
