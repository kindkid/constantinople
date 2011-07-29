Constantinople
==============

Usage
=====
Place all your configuration parameters in YAML files within a config/
directory under the top level of your project. For example, you might have a
config/database.yml file.

In an initializer at the top level of your project,
or within your config/ directory, do this:

    require 'constantinople'

You may then use CONSTANTINOPLE from anywhere in your app:

    CONSTANTINOPLE.database.username


Defaults and Overrides
======================
You can create default and over-ride versions of config files. Constantinople
will look for and load config files in the following order:

    config/*.yml.default
    config/*.yml
    config/*.yml.override

The results are merged together. We recommended you gitignore config/*.yml.

Environments
============
If there is a non-empty ENV['RAILS_ENV'], ENV['RACK_ENV'] or ENV['APP_ENV'] the
first such environment will be used as a key whose values will be merged into
the level above. So for example, if your database.yml file has

    username: root
    password:
    production:
      password: d87gfds09ds8a

Then in your development environment:

    CONSTANTINOPLE.database.username # root
    CONSTANTINOPLE.database.password # nil

And in your production environment:

    CONSTANTINOPLE.database.username # root
    CONSTANTINOPLE.database.password # d87gfds09ds8a


Working on the Gem
==================
Install rvm, including ruby 1.9.2
Clone the git repo, then...

    cd constantinople
    gem install bundler
    bundle install
    rake coverage


Forking
=======
Yeah, fine. But please rename to Istanbul.