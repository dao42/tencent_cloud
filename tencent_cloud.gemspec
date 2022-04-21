# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tencent_cloud/version"

Gem::Specification.new do |s|
  s.name        = 'tencent_cloud'
  s.version     = TencentCloud::VERSION
  s.summary     = "腾讯云api"
  s.description = "腾讯云api sdk"
  s.authors     = ["ddannyc"]
  s.email       = 'weilong@dao42.com'
  s.files       = ["lib/tencent_cloud.rb"]
  s.files       = Dir["lib/**/*"]
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 2.5"
  s.homepage    =
    'https://github.com/dao42/tencent_cloud'
  s.license       = 'MIT'
  s.add_dependency 'http'
  s.add_dependency 'activesupport'
end
