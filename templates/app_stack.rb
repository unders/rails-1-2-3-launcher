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

#plugin 'safe_mass_assignment', :git => 'http://github.com/jamis/safe_mass_assignment/tree/master'

#gem 'chardet', :version => ">= 0.9.0", :lib => false
#gem 'html5', :version => ">= 0.10.0"
plugin 'xss_terminate', :git => 'git://github.com/look/xss_terminate.git'
inside('vendor/plugins/xss_terminate/test') do
  run("rm xss_terminate_test.rb")
  run("rm setup_test.rb")
end

plugin 'demeters_revenge', :git => 'git://github.com/caius/demeters_revenge.git'

gem 'justinfrench-formtastic', :lib => 'formtastic', :source => "http://gems.github.com", :version => '>=0.2.1'

file 'lib/tasks/ci.rake' do
<<-CODE
namespace :ci do
  task :copy_yml do
    %x{cp \#{Rails.root}/config/database.yml.ci \#{Rails.root}/config/database.yml}
  end

  task :build => ['ci:copy_yml', 'db:migrate', 'spec', 'features'] do
  end
end
CODE
end

file 'lib/tasks/super.rake' do
<<-CODE
task :supermigrate => ['environment', 'db:migrate', 'db:test:prepare'] do
  %x(cd \#{RAILS_ROOT} && annotate)
end

task :superspec => ['spec', 'features'] do
end
CODE
end

#gem 'validate_options', :version => ">= 0.0.2"
#gem 'active_presenter', :version => ">= 1.1.2"

#rake "gems:install", :sudo => true
#rake "gems:unpack"
