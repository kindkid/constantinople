require "map"
require "yaml"
require "deep_merge/core"
require "constantinople/deep_merge_map"
require "constantinople/version"

module Constantinople

  def self.reload!
    result = Map.new
    ignore_files = []
    caller_config_directories do |dir|
      ignore_files += files_to_ignore(dir)
    end
    ignore_files.uniq!
    caller_config_directories do |dir|
      result.deeper_merge!(load_from_directory(dir, :ignore => ignore_files))
    end
    result # I'm the map, I'm the map, I'm the map, I'm the map...
  end

  private

  def self.load_from_directory(dir, args={})
    env = environment
    result = Map.new
    ignore_files = args[:ignore]
    ['.yml.default', '.yml', '.yml.override'].each do |ext|
      Dir.glob(File.join(dir,"*#{ext}")) do |path|
        next if ignore_files.include?(File.basename(path))
        filename = File.basename(path,ext)
        sub = load_yaml_or_warn(path)
        if sub
          sub = Map.new(sub)
          sub.deeper_merge!(sub[env]) if sub.include?(env)
        else
          sub = {}
        end
        result.deeper_merge!(filename => sub)
      end
    end
    result
  end

  def self.load_yaml_or_warn(path)
    YAML.load_file(path)
  rescue Exception => e
    $stderr.puts "WARNING: Unable to load file: '#{path}'."
    $stderr.puts " Reason: #{e.message}"
    nil
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

  def self.files_to_ignore(dir)
    File.open(File.join(dir,".constantinopleignore")) do |f|
      f.readlines
    end
  rescue Exception => e
    []
  end

end

CONSTANTINOPLE = Constantinople.reload!