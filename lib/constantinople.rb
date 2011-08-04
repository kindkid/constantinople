require "map"
require "yaml"
require "deep_merge/core"
require "constantinople/deep_merge_map"
require "constantinople/version"

module Constantinople

  def self.reload!
    result = Map.new
    caller_config_directories do |dir|
      result.deeper_merge!(load_from_directory(dir))
    end
    result # I'm the map, I'm the map, I'm the map, I'm the map...
  end

  private

  def self.load_from_directory(dir)
    env = environment
    result = Map.new
    ['.yml.default', '.yml', '.yml.override'].each do |ext|
      Dir.glob(File.join(dir,"*#{ext}")) do |path|
        filename = File.basename(path,ext)
        result.deeper_merge!(filename => YAML.load_file(path))
        sub = result[filename]
        sub.deeper_merge!(sub[env]) if sub.include?(env)
      end
    end
    result
  end

  def self.environment
    ['RAILS_ENV', 'RACK_ENV', 'APP_ENV'].each do |env|
      environment = ENV[env]
      return environment unless environment.nil? || environment.empty?
    end
    'development'
  end

  def self.caller_config_directories
    possible_caller_config_directories do |dir|
      yield dir if File.directory?(dir)
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
      dir = File.dirname(trace)
      yield dir unless results.include?(dir) || !File.directory?(dir)
      results << dir
    end
  end

end

CONSTANTINOPLE = Constantinople.reload!