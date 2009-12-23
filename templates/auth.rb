
# thoughtbot-factory_girl must be present when generating clearence
gem 'factory_girl', :version => '>=1.2.3', :lib => "factory_girl", :env => 'development'
rake "gems:install", :env => "development", :sudo => true

gem "clearance", :lib => 'clearance', :version => '>=0.8.4'
rake "gems:install", :sudo => true

generate "clearance"
rake "db:migrate"

hostname = ask("what is the hostname in development?")
initializer('clearance.rb', <<-FILE)
if Rails.env.development?
  HOST = "#{hostname}"
elsif Rails.env.test?
  HOST = "test.host"
else
  HOST = "foo.bar"
end
DO_NOT_REPLY = "noreplay@elabs.se"
FILE

route "map.root :controller => 'home'"


generate "clearance_features", "-f"
generate "clearance_views"

file 'app/controllers/home_controller.rb' do
<<-CODE
class HomeController < ApplicationController
  def index
  end
end
CODE
end

file 'app/views/home/index.html.erb' do
<<-CODE
<%- if signed_in? -%>
  <p>
    Welcome <%= current_user.email %>
    <%= link_to 'Sign out', session_path, :method => :delete %>
  </p>
<% else %>
  <p>
    <%= link_to 'Login', new_session_path %> or
    <%= link_to 'Sign Up', new_user_path %>
  </p>
<%- end -%>
CODE
end  
  
user_factory = <<-RUBY.strip
  user = Factory :user,
    :email                 => email,
    :password              => password,
    :password_confirmation => password
RUBY
gsub_file('features/step_definitions/clearance_steps.rb', user_factory, "User.make(:email => email, :password => password, :password_confirmation => password)")

confirmed_user_factory = <<-RUBY.strip
  user = Factory :email_confirmed_user,
    :email                 => email,
    :password              => password,
    :password_confirmation => password
RUBY
gsub_file('features/step_definitions/clearance_steps.rb', confirmed_user_factory, "User.make(:email => email, :password => password, :password_confirmation => password).confirm_email!")

in_root do
  run("rm features/step_definitions/clearance_steps.rb")
  run("rm features/step_definitions/factory_girl_steps.rb")
  run("rm features/password_reset.feature")
  run("rm features/sign_in.feature")
  run("rm features/sign_out.feature")
  run("rm features/sign_up.feature")
end
run "curl -s -L http://github.com/unders/rails-1-2-3-launcher/raw/master/files/custom_steps.rb > features/step_definitions/custom_steps.rb"
run "curl -s -L http://github.com/unders/rails-1-2-3-launcher/raw/master/files/clearance_steps.rb > features/step_definitions/clearance_steps.rb"
run "curl -s -L http://github.com/unders/rails-1-2-3-launcher/raw/master/files/password_reset.feature > features/password_reset.feature"
run "curl -s -L http://github.com/unders/rails-1-2-3-launcher/raw/master/files/sign_in.feature > features/sign_in.feature"
run "curl -s -L http://github.com/unders/rails-1-2-3-launcher/raw/master/files/sign_out.feature > features/sign_out.feature"
run "curl -s -L http://github.com/unders/rails-1-2-3-launcher/raw/master/files/sign_up.feature > features/sign_up.feature"

git :add => '.'
git :add => "-u"
git :commit => '-m "added authentication with clearance"'