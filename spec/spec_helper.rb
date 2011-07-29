YAML::ENGINE.yamler = 'syck'
require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'

Bundler.require(:default, :test, :development)
