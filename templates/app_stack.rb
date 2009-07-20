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

file 'app/views/layouts/application.html.erb' do
<<-CODE
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">

  <head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <link rel="shortcut icon" href="/favicon.ico" />
    <%= stylesheet_link_tag 'master.css' %>
  </head>
  
  <body>
    <div id="flash-msg">
      <%- flash.each do |name, msg| -%>
        <%= content_tag :div, msg, :class => "flash #{name}" %>
      <%- end -%>
    </div>
    
    <%= yield %>

    <%= javascript_include_tag 'jquery.js', 'application.js' %>
  </body>

</html>
CODE
end

#gem 'validate_options', :version => ">= 0.0.2"
#gem 'active_presenter', :version => ">= 1.1.2"

#rake "gems:install", :sudo => true
#rake "gems:unpack"
