require "map"
require 'yaml'
require "deep_merge/core"
require "constantinople/deep_merge_map"
require "constantinople/version"

module Constantinople

  def self.reload!
    result = Map.new
    caller_config_directories do |dir|
      result.deeper_merge!(load_from_directory(dir))
    end
    env = environment
    result.each do |key, value|
      value.deeper_merge!(value[env]) if value.include?(env)
    end
    result # I'm the map, I'm the map, I'm the map, I'm the map...
  end

  private

  def self.load_from_directory(dir)
    result = Map.new
    ['.yml.default', '.yml', '.yml.override'].each do |ext|
      Dir.glob(File.join(dir,"*#{ext}")) do |path|
        filename = File.basename(path,ext)
        result.deeper_merge!(filename => YAML.load_file(path))
      end
    end
    result
  end

  def self.environment
    ['RAILS_ENV', 'RACK_ENV', 'APP_ENV'].each do |env|
      environment = ENV[env]
      return environment unless environment.nil? || environment.empty?
    end
    nil
  end

  def self.caller_config_directories
    possible_caller_config_directories do |dir|
      yield dir if Dir.exist?(dir)
    end
  end

  def self.possible_caller_config_directories
    caller_directories do |d|
      yield File.join(d,'config')
      yield File.join(File.dirname(d),'config')
    end
  end

  def self.caller_directories
    results = []
    regex = /^(.*)\:\d+\:in .*$/
    caller.each do |trace|
      next unless match = regex.match(trace)
      file = match[1]
      next unless file && File.exist?(file)
      dir = File.dirname(file)
      yield dir unless results.include?(dir)
    end
  end

end

CONSTANTINOPLE = Constantinople.reload!