# ConfigSpartan

Ultra simple application configuration (app config) gem with the
following features:
 * YAML config files
 * ERB support in config files
 * Inheritance
 * Object member notation to access config options

## Installation

Add this line to your application's Gemfile:

    gem 'config_spartan'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install config_spartan

## Usage

If you are using in a Rails app, you can do something like this...

    # config/base.yml
    app_name:  MyCoolApp
    domain:  mycoolapp.com
    lib_dir: <%= Rails.root + "/lib" %>
    aws:
      access_key: 123ABC
      secret_key: ABC123

    # config/development.yml
    domain:  dev.mycoolapp.com

    # app/models/app_config.rb
    AppConfig = ConfigSpartan.create do
      file "#{Rails.root}/config/base.yml"
      file "#{Rails.root}/config/#{Rails.env}.yml"
    end

In `ConfigSpartan.create`, you can call `file` as many times as you
want.  Each time, the configuration options from that file will be deep
merged into the existing configuration object.

Now fire up a Rails console (using the development environment)...

    > AppConfig.lib_dir
    => "/Users/cjbottaro/my_cool_app/lib"
    > AppConfig.aws.access_key
    => "123ABC"
    > AppConfig["aws"]["secret_key"]
    => "ABC123"
    > AppConfig.domain
    => "dev.mycoolapp.com"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
