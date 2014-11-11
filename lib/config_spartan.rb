require "erb"
require "yaml"
require "hashie"

require "config_spartan/version"

class ConfigSpartan

  attr_reader :config

  def self.create(&block)
    mashie = new.tap{ |spartan| spartan.instance_eval(&block) }.config
    DynamicStruct.new(mashie) #not sure why this needs to be called twice but it does
  end

  def initialize
    @config = Hashie::Mash.new
  end

  def file(path)
    if File.exists?(path)
      data = File.read(path)
      yaml = ERB.new(data).result
      hash = YAML.load(yaml)
      mash = DynamicStruct.new(hash)
      @config.deep_merge!(mash)
    end
  end

  # TODO: remove if implemented in Hashie: https://github.com/intridea/hashie/issues/60#issue-7694298

  # stolen from https://github.com/seomoz/interpol/blob/27167ef85fa24d60bbaff90165b5e314e9eca2ec/lib/interpol/dynamic_struct.rb
  # Hashie::Mash is awesome: it gives us dot/method-call syntax for a hash.
  # This is perfect for dealing with structured JSON data.
  # The downside is that Hashie::Mash responds to anything--it simply
  # creates a new entry in the backing hash.
  #
  # DynamicStruct freezes a Hashie::Mash so that it no longer responds to
  # everything.  This is handy so that consumers of this gem can distinguish
  # between a fat-fingered field, and a field that is set to nil.
  module DynamicStruct
    SAFE_METHOD_MISSING = ::Hashie::Mash.superclass.instance_method(:method_missing)

    Mash = Class.new(::Hashie::Mash) do
      undef sort
    end

    def self.new(*args)
      Mash.new(*args).tap do |mash|
        mash.extend(self)
      end
    end

    def self.extended(mash)
      recursively_extend(mash)
    end

    def self.recursively_extend(object)
      case object
        when Array
          object.each { |v| recursively_extend(v) }
        when Mash
          object.extend(self) unless object.is_a?(self)
          object.each { |_, v| recursively_extend(v) }
      end
    end

    def method_missing(method_name, *args, &blk)
      if key = method_name.to_s[/\A([^?=]*)[?=]?\z/, 1]
        unless has_key?(key)
          return safe_method_missing(method_name, *args, &blk)
        end
      end

      super
    end

  private

    def safe_method_missing(*args)
      SAFE_METHOD_MISSING.bind(self).call(*args)
    end
  end
end
