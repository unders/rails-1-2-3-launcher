initializer("active_record.rb") do 
<<-CODE
# encoding: utf-8

class ActiveRecord::Base
  
  def self.random
    random = rand(count)
    uncached do
      find(:first, :offset => random)
    end
  end
  
  def self.per_page(num=nil)
    @per_page = num if num
    @per_page || 10
  end
  
  def self.t(name)
    human_attribute_name(name.to_s)
  end
  
  # mostly for tests
  def save_and_reload
    save
    reload
  end
  
end
CODE
end

git :add => "."
git :commit => "-m 'added active_record.rb initializer'"

initializer("module.rb") do 
<<-CODE
# encoding: utf-8

class Module

  # A version of Rails' delegate method which enables the prefix and allow_nil
  def soft_delegate(*attrs)
    options = attrs.extract_options!
    options[:prefix] = true unless options.has_key?(:prefix)
    options[:allow_nil] = true unless options.has_key?(:allow_nil)
    attrs.push(options)
    delegate *attrs
  end
  
end
CODE
end
git :add => "."
git :commit => "-m 'added module.rb initializer'"

initializer("inaccessible_attributes.rb") do
<<-CODE
# encoding: utf-8

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
git :add => "."
git :commit => "-m 'added inaccessible_attributes.rb initializer'"
 
# option with a list of fields to sanitize:
plugin 'xss_terminate', :git => 'git://github.com/look/xss_terminate.git'
inside('vendor/plugins/xss_terminate/test') do
  run("rm xss_terminate_test.rb")
  run("rm setup_test.rb")
end
git :add => "."
git :commit => "-m 'added xss_terminate'"

plugin 'demeters_revenge', :git => 'git://github.com/caius/demeters_revenge.git'
git :add => "."
git :commit => "-m 'added demeters_revenge'"

#I18n
run "curl -s -L http://github.com/unders/rails-i18n/raw/master/rails/locale/sv.yml > config/locales/sv.yml"
run "curl -s -L http://github.com/unders/rails-i18n/raw/master/rails/locale/en.yml > config/locales/en.yml"

# in environments/test.rb
# config.i18n.default_locale = :en

#in routes.rb
#map.filter 'locale'

# in application_controller.rb
#   before_filter :set_locale
# 
# private
# 
#   def set_locale
#     parsed_locale = params[:locale]
#     if parsed_locale.present? and I18n.backend.available_locales.include?(parsed_locale.to_sym)
#       I18n.locale = parsed_locale
#     else
#       I18n.locale = I18n.default_locale
#     end
#   end

# routing filter plugin

git :add => "."
git :commit => "-m 'added en.yml and sv.yml localization file'"


gem 'formtastic', :lib => 'formtastic', :version => '>=0.9.7'
rake "gems:install"
generate "formtastic"
git :add => "."
git :commit => "-m 'added formtastic'"

# validation_reflection plugin

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
git :add => "."
git :commit => "-m 'added lib/tasks/ci.rake'"

file 'lib/tasks/super.rake' do
<<-CODE
task :supermigrate => ['environment', 'db:migrate', 'db:test:prepare'] do
  %x(cd \#{RAILS_ROOT} && annotate)
end

task :superspec => ['spec', 'cucumber'] do
end
CODE
end
git :add => "."
git :commit => "-m 'added lib/tasks/super.rake'"

file 'lib/tasks/capybara.rake' do
<<-CODE
namespace :capybara do
  desc "Deletes all capybara-*.html files in root directory"
  task :delete_files => :environment do
    %x(cd \#{Rails.root} && rm capybara-*.html)
  end
end
CODE
end
git :add => "."
git :commit => "-m 'added lib/tasks/super.rake'"

run "touch public/stylesheets/master.css"

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
        <%= content_tag :div, msg, :class => "flash \#{name}" %>
      <%- end -%>
    </div>
    
    <%= yield %>

    <%= javascript_include_tag 'jquery.js', 'application.js' %>
  </body>

</html>
CODE
end


git :add => "."
git :commit => "-m 'added layout file: app/views/layouts/application.html.erb'"