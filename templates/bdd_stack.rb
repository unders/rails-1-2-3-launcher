# All gems are added to config/environments/test.rb and installed to the system if not already installed.
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

gem 'faker', :env => 'test'
gem 'sevenwire-forgery', :version => '>= 0.2.2', 
                         :lib => 'forgery', 
                         :source => 'http://gems.github.com', 
                         :env => 'test'

rake "gems:install", :env => "test", :sudo => true
generate :forgery

gem 'notahat-machinist', :lib => 'machinist', :source => "http://gems.github.com", :env => 'test'
file_inject 'spec/spec_helper.rb', 
            "require File.expand_path(File.dirname(__FILE__) + '/../config/environment')", 
            "require File.expand_path(File.dirname(__FILE__) + '/blueprints')"
file_inject 'spec/spec_helper.rb',
            "config.fixture_path = RAILS_ROOT + '/spec/fixtures/'", 
            'config.before(:each) { Sham.reset }'     
file_inject 'features/support/env.rb',
            "require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')",
            "require File.join(RAILS_ROOT, 'spec', 'blueprints')"
            
file 'spec/blueprints' do
<<-CODE
require ‘forgery’
require 'faker'

# Shams
# We use forgery (and faker) to make up some test data

Sham.name      { NameForgery.full_name }
Sham.login     { InternetForgery.user_name }
Sham.email     { InternetForgery.email_address }
Sham.password  { BasicForgery.password }
Sham.string    { BasicForgery.text }
Sham.text      { LoremIpsumForgery.text }
 
# Blueprints 
User.blueprint do
  pwd = Sham.password
  login { Sham.login }
  email { Sham.email }
  password { pwd }
  password_confirmation { pwd }
end

CODE
end            
                            
rake "gems:install", :env => "test", :sudo => true

 
# http://www.benmabey.com/2009/02/05/leveraging-test-data-builders-in-cucumber-steps/
# http://themomorohoax.com/2009/03/08/rails-machinist-tutorial-machinist-with-cucumber-in-10-minutes
# http://github.com/notahat/time_travel/tree/master

# sudo gem install ianwhite-pickle
#script/generate pickle [paths] [email]

# gem 'sevenwire-forgery', :lib => 'forgery', :env => 'test', :source => 'http://gems.github.com'
# generate :forgery


# faker-0.3.1 - http://faker.rubyforge.org/rdoc/
# gem install populator-0.2.5 - http://github.com/ryanb/populator/tree/master

# http://drnicwilliams.com/2008/01/04/autotesting-javascript-in-rails/
# http://github.com/drnic/jsunittest/tree/master

# metric_fu
# http://github.com/unboxed/be_valid_asset/tree/master <- for rspec

# sudo gem install ZenTest
# http://github.com/unders/spider_test/tree/master
# config.gem 'relevance-tarantula', :source => "http://gems.github.com", :lib => 'relevance/tarantula'

# http://integration.rubyforge.org/
# http://github.com/tapajos/integration/tree/master

# http://github.com/wr0ngway/assert_valid_markup/tree/master
# sudo gem install fakeweb

# Mocka in cucumber
# http://gist.github.com/80554
# http://www.brynary.com/2009/2/3/cucumber-step-definition-tip-stubbing-time

# http://www.somethingnimble.com/bliki/deep-test-1_2_0
# http://www.somethingnimble.com/bliki/deep-test
# http://deep-test.rubyforge.org/
# http://wiki.github.com/aslakhellesoy/cucumber/using-rcov-with-cucumber-and-rails

# http://github.com/langalex/culerity/tree/master - Integrates Cucumber and Celerity to test Javascript in webapps.

# http://github.com/brynary/testjour/tree/master

#git :add => "."
#git :commit => "-m 'added bdd_stack'"


# references:
# webrat-0.4.4 - http://gitrdoc.com/brynary/webrat/tree/master/
# http://wiki.github.com/bmabey/email-spec/use-cucumber-to-test-email
# http://wiki.github.com/bmabey/email-spec/use-cucumber-to-test-mailers-in-rails