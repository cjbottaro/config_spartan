require "erb"
require "yaml"
require "hashie"

require "config_spartan/version"

class ConfigSpartan
  
  attr_reader :config

  def self.create(&block)
    new.tap{ |spartan| spartan.instance_eval(&block) }.config
  end

  def initialize
    @config = Hashie::Mash.new
  end

  def file(path)
    data = File.read(path)
    yaml = ERB.new(data).result
    hash = YAML.load(yaml)
    mash = Hashie::Mash.new(hash)
    @config.deep_merge!(mash)
  end

end
