initializer("inaccessible_attributes.rb") do
<<-CODE
ActiveRecord::Base.send(:attr_accessible, nil) 

if Rails.env.test? or Rails.env.development?

  module ActiveRecord
    class MassAssignmentError < StandardError; end
  end

  ActiveRecord::Base.class_eval do
    def log_protected_attribute_removal(*attributes)
      raise ActiveRecord::MassAssignmentError, "Can't mass-assign these protected attributes: \#{attributes.join(', ')}"
    end
  end
end
CODE
end

plugin 'safe_mass_assignment', :git => 'http://github.com/jamis/safe_mass_assignment/tree/master'

gem 'chardet', :version => ">= 0.9.0"
gem 'html5', :version => ">= 0.10.0", :lib => false
plugin 'xss_terminate', :git => 'git://github.com/look/xss_terminate.git'
inside('vendor/plugins/xss_terminate/test') do
  run("rm xss_terminate_test.rb")
end

gem 'validate_options', :version => ">= 0.0.2"
gem 'active_presenter', :version => ">= 1.1.2"

rake "gems:install", :sudo => true
rake "gems:unpack"
