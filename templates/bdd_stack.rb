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

# http://drnicwilliams.com/2008/01/04/autotesting-javascript-in-rails/
# http://github.com/drnic/jsunittest/tree/master

# gem 'notahat-machinist', :lib => 'machinist', :env => 'test', :source => "http://gems.github.com"

# http://github.com/notahat/time_travel/tree/master

# gem 'sevenwire-forgery', :lib => 'forgery', :env => 'test', :source => 'http://gems.github.com'
# generate :forgery

# sudo gem install notahat-machinist --source http://gems.github.com

# faker-0.3.1 - http://faker.rubyforge.org/rdoc/
# gem install populator-0.2.5 - http://github.com/ryanb/populator/tree/master

# metric_fu
# http://github.com/unboxed/be_valid_asset/tree/master <- for rspec
# http://github.com/unders/spider_test/tree/master
# http://github.com/wr0ngway/assert_valid_markup/tree/master
# sudo gem install fakeweb

#git :add => "."
#git :commit => "-m 'added bdd_stack'"

# references:
# webrat-0.4.4 - http://gitrdoc.com/brynary/webrat/tree/master/
# http://wiki.github.com/bmabey/email-spec/use-cucumber-to-test-email
# http://wiki.github.com/bmabey/email-spec/use-cucumber-to-test-mailers-in-rails