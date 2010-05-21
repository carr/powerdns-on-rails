# Rails is vendored
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'haml', :version => '2.2.5'

  config.active_record.observers = :user_observer

  config.time_zone = 'UTC'
end
