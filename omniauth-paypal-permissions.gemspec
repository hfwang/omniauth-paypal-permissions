# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'omniauth/paypal_permissions/version'

Gem::Specification.new do |s|
  s.name     = 'omniauth-paypal-permissions'
  s.version  = OmniAuth::PaypalPermissions::VERSION
  s.authors  = ['Hsiu-Fan Wang']
  s.email    = ['hfwang@porkbuns.net']
  s.summary  = 'PayPal Permissions Service API strategy for OmniAuth'
  s.homepage = 'https://github.com/hfwang/omniauth-paypal-permissions'
  s.license  = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'paypal-sdk-permissions', '~> 1.96'

  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'rake'
end
