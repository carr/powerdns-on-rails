# Rails is vendored
RAILS_GEM_VERSION = '2.3.16' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

if Gem::VERSION >= "1.3.6" 
  module Rails
    class GemDependency
      def requirement
        r = super
        (r == Gem::Requirement.default) ? nil : r
      end
    end
  end
end

Rails::Initializer.run do |config|
  # iz nekog razloga ne radi bez ovog, iako imamo bundler
  config.gem 'haml', :version => '2.2.10'
  config.active_record.observers = :user_observer

  config.time_zone = 'UTC'
end
