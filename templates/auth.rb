gem "thoughtbot-clearance", :lib => 'clearance', :source  => 'http://gems.github.com',  :version => '>=0.8.2'
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
DO_NOT_REPLY = "support@elabs.se"
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
  run("rm features/step_definitions/factory_girl_steps.rb")
end

git :add => '.', :commit => '-m "added authentication with clearance"'