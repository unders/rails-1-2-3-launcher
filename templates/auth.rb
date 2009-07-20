gem "thoughtbot-clearance", :lib => 'clearance', :source  => 'http://gems.github.com',  :version => '>=0.6.4'
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