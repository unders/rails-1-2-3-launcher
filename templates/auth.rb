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

generate "clearance_features"

git :add => '.', :commit => '-m "added authentication with clearance"'