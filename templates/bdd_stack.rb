# All gems are added to config/environments/test.rb and installed to the system if not already installed.

gem 'ZenTest', :version => ">=4.0.0", :env => 'test'

gem 'rspec', :lib => false, :version => ">= 1.2.4", :env => 'test'
gem 'rspec-rails', :lib => false, :version => ">= 1.2.4", :env => 'test'

rake "gems:install", :env => "test", :sudo => true
generate "rspec"

# Cucumber gem dependencies
%w{term-ansicolor treetop diff-lcs nokogiri builder}.each do |package|
  gem package, :lib => false, :env => 'test'
end

gem 'cucumber', :version => ">= 0.3.0", :env => 'test'
gem 'webrat', :version => ">= 0.4.4", :env => 'test'
rake "gems:install", :env => "test", :sudo => true
generate "cucumber" 

gem 'remarkable_rails', :lib => false, :version => ">= 3.0.3", :env => 'test'
file_inject 'spec/spec_helper.rb', "require 'spec/rails'", "require 'remarkable_rails'"

gem 'bmabey-email_spec', :version => '>= 0.1.3', 
                         :lib => 'email_spec', 
                         :source => 'http://gems.github.com',
                         :env => 'test'
file_inject 'features/support/env.rb', "require 'cucumber/rails/world'", "require 'email_spec/cucumber'"                          
file_inject 'spec/spec_helper.rb', 
            "require 'remarkable_rails'", 
            "require 'email_spec/helpers' \nrequire 'email_spec/matchers'"
file_inject 'spec/spec_helper.rb', 
            'Spec::Runner.configure do |config|',  
            "  config.include(EmailSpec::Helpers) \n  config.include(EmailSpec::Matchers)"           

rake "gems:install", :env => "test", :sudo => true                         
generate :email_spec

gem 'faker', :version => '>=0.3.1', :env => 'test'
# gem 'sevenwire-forgery', :version => '>= 0.2.2', 
#                          :lib => 'forgery', 
#                          :source => 'http://gems.github.com', 
#                          :env => 'test'

rake "gems:install", :env => "test", :sudo => true
#generate :forgery

gem 'notahat-machinist', :lib => 'machinist', :source => "http://gems.github.com", :env => 'test'
file_inject 'spec/spec_helper.rb', 
            "require 'email_spec/matchers'", 
            "require File.expand_path(File.dirname(__FILE__) + '/blueprints')"
file_inject 'spec/spec_helper.rb',
            'config.include(EmailSpec::Matchers)', 
            '  config.before(:each) { Sham.reset }'     
file_inject 'features/support/env.rb',
            "require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')",
            "require File.join(RAILS_ROOT, 'spec', 'blueprints')"
            
file 'spec/blueprints.rb' do
<<-CODE
require 'faker'

# Shams
# We use forgery (and faker) to make up some test data

Sham.define do
  name { Faker::Name.name } 
  email { Faker::Internet.email }
  login { Faker::Internet.user_name }
  title { Faker::Lorem.sentence }
  text { Faker::Lorem.paragraphs }
  time { DateTime.civil(1990 + rand(20), rand(12)+1, rand(28)+1, rand(24), rand(60), rand(60)) }
  date { Date.civil(1990 + rand(20), rand(12)+1, rand(28)+1) }
end
 
# Blueprints 
User.blueprint do
  pwd = "test1234"
  email { Sham.email }
  password { pwd }
  password_confirmation { pwd }
end

CODE
end            
                            

plugin 'time_travel', :git => 'git://github.com/notahat/time_travel.git'

#gem :populator, :version => '>=0.2.5', :env => 'test'

file 'lib/tasks/populate.rake' do
<<-CODE
# lib/tasks/populate.rake
# http://github.com/ryanb/populator/tree/master
# http://railscasts.com/episodes/126-populating-a-database
# http://populator.rubyforge.org/

module Populate
  extend self
  
  def log(model)
    puts "[populate] created: <\#{model.class} \#{model.id}>"
  end
end

namespace :db do

  desc "Erase and fill database"
  task :populate => [
    'db:populate:users'
  ]

  namespace :populate do

    task :setup => :environment do
      require File.join(Rails.root, 'spec', 'blueprints')
    end
  end

  task :users => 'db:populate:setup' do
    puts "[populate] users"
    User.delete_all
    Populate.log User.make(:password => 'test1234', :password_confirmation => 'test1234', :email => "user@test.local").confirm!
  end

end
CODE
end

rake "gems:install", :env => "test", :sudo => true

plugin 'be_valid_asset', :git => 'git://github.com/unboxed/be_valid_asset.git'
file_inject 'spec/spec_helper.rb',
            'config.before(:each) { Sham.reset }', 
            '  config.include BeValidAsset'

file_inject 'spec/spec_helper.rb',
            'config.include BeValidAsset',            
            %q{BeValidAsset::Configuration.enable_caching = true
BeValidAsset::Configuration.cache_path = File.join(RAILS_ROOT, %w(tmp be_valid_asset_cache))}



# rack-bug has depency on rack-test and sintra gems; command: rake spec:plugins will fail
# if they aren't installed
#gem 'rack-test', :version => '>= 0.2.0', :env => "test"
#gem 'sinatra', :version => '>= 0.9.1.1', :env => "test"
rake "gems:install", :env => "test", :sudo => true

plugin 'rack-bug', :git => 'git://github.com/brynary/rack-bug.git'
environment('config.middleware.use "Rack::Bug"', :env => 'development')

initializer("middleware.rb") do
<<-CODE
require "rack/bug"

ActionController::Dispatcher.middleware.use Rack::Bug,
  :ip_masks   => [IPAddr.new("127.0.0.1")],
  :secret_key => "epT5uCIchlsHCeR9dloOeAPG66PtHd9K8l0q9avitiaA/KUrY7DE52hD4yWY+8z1",
  :password   => "rack-bug-secret"
CODE
end

                                
# sudo gem install fakeweb fakeweb-1.2.0

#Rspec has a similar function built in. You can get benchmark info on your 10 slowest test by adding:
#--format profile
#to spec/spec.opts (or passing it as a command line option to the spec script).
#http://bitfission.com/blog/2009/02/profiling-rspec.html



# http://github.com/jeremy/ruby-prof/tree/master
# gem install ruby-prof
# http://snippets.aktagon.com/snippets/255-How-to-profile-your-Rails-and-Ruby-applications-with-ruby-prof



#http://github.com/grosser/single_test/tree/master



# http://drnicwilliams.com/2008/01/04/autotesting-javascript-in-rails/
# http://github.com/drnic/jsunittest/tree/master

# or

# http://github.com/relevance/blue-ridge/tree/master

# * sudo gem install autotest_screen

# http://github.com/dchelimsky/rspec-rails/blob/master/generators/rspec/templates/script/spec_server
# http://wiki.github.com/dchelimsky/rspec/spec_server-autospec-nearly-pure-bdd-joy

git :add => "."
git :commit => "-m 'added bdd_stack'"


# Needs more investigation:

#1.
#gem 'ianwhite-pickle', :version => '>= 0.1.12', 
#                       :lib => 'pickle', 
#                       :source => 'http://gems.github.com', 
#                       :env => 'test'
#rake "gems:install", :env => "test", :sudo => true
#
#generate :pickle, "paths email"

#2.
# Mocka in cucumber
# http://gist.github.com/80554
# http://www.brynary.com/2009/2/3/cucumber-step-definition-tip-stubbing-time

#3.

# http://www.somethingnimble.com/bliki/deep-test-1_2_0
# http://www.somethingnimble.com/bliki/deep-test
# http://deep-test.rubyforge.org/
# http://wiki.github.com/aslakhellesoy/cucumber/using-rcov-with-cucumber-and-rails
# http://github.com/langalex/culerity/tree/master - Integrates Cucumber and Celerity to test Javascript in webapps.
# http://github.com/brynary/testjour/tree/master

# references:
# http://www.brynary.com/2009/4/22/rack-bug-debugging-toolbar-in-four-minutes
# http://github.com/brynary/rack-bug/tree/master
# webrat-0.4.4 - http://gitrdoc.com/brynary/webrat/tree/master/
# http://wiki.github.com/bmabey/email-spec/use-cucumber-to-test-email
# http://wiki.github.com/bmabey/email-spec/use-cucumber-to-test-mailers-in-rails
# http://www.benmabey.com/2009/02/05/leveraging-test-data-builders-in-cucumber-steps/
# http://themomorohoax.com/2009/03/08/rails-machinist-tutorial-machinist-with-cucumber-in-10-minutes
