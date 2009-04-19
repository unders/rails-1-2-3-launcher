# All gems are added to config/environments/test.rb and installed to the system if not already installed.

gem 'ZenTest', :version => ">=4.0.0"

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
gem 'sevenwire-forgery', :version => '>= 0.2.2', 
                         :lib => 'forgery', 
                         :source => 'http://gems.github.com', 
                         :env => 'test'

rake "gems:install", :env => "test", :sudo => true
generate :forgery

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
                            

plugin 'time_travel', :git => 'git://github.com/notahat/time_travel.git'

gem :populator, :version => '>=0.2.5', :env => 'test'

file 'lib/tasks/populate.rake' do
<<-CODE
# lib/tasks/populate.rake
# http://github.com/ryanb/populator/tree/master
# http://railscasts.com/episodes/126-populating-a-database
# http://populator.rubyforge.org/

namespace :db do
  
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
#    [Category, Product].each(&:delete_all)
#
#     Category.populate 20 do |category|
#       category.name = Populator.words(1..3).titleize
#       Product.populate 10..100 do |product|
#         product.category_id = category.id
#         product.name = Populator.words(1..5).titleize
#         product.description = Populator.sentences(2..10)
#         product.price = [4.99, 19.95, 100]
#         product.created_at = 2.years.ago..Time.now
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

plugin 'spider_test', :git => 'git://github.com/courtenay/spider_test.git'
generate :integration_test, "spider_test"

gem 'htmlentities', :version => '>= 4.0.0'
gem 'hpricot', :version => '>= 0.8.1'
gem 'relevance-tarantula', :version => '>= 0.1.8',
                                  :source => "http://gems.github.com", 
                                  :lib => 'relevance/tarantula',
                                  :env => "test"

                                  

rake "gems:install", :env => "test", :sudo => true

file 'test/tarantula/tarantula_test.rb' do
<<-CODE
require '#{File.dirname(__FILE__)}/../test_helper'
require 'relevance/tarantula'

class TarantulaTest < ActionController::IntegrationTest
  # Load enough test data to ensure that there's a link to every page in your
  # application. Doing so allows Tarantula to follow those links and crawl 
  # every page.  For many applications, you can load a decent data set by
  # loading all fixtures.
  fixtures :all

  def test_tarantula
    # If your application requires users to log in before accessing certain 
    # pages, uncomment the lines below and update them to allow this test to
    # log in to your application.  Doing so allows Tarantula to crawl the 
    # pages that are only accessible to logged-in users.
    # 
    #   post '/session', :login => 'quentin', :password => 'monkey'
    #   follow_redirect!
    
    tarantula_crawl(self)
  end
end
CODE
end  

file 'lib/tasks/tarantula.rake' do
<<-TASK
namespace :tarantula do
  desc 'Run tarantula tests.'
  task :test do
    rm_rf "tmp/tarantula"
    task = Rake::TestTask.new(:tarantula_test) do |t|
      t.libs << 'test'
      t.pattern = 'test/tarantula/**/*_test.rb'
      t.verbose = true
    end

    Rake::Task[:tarantula_test].invoke
  end
  
  desc 'Run tarantula tests and open results in your browser.'
  task :report => :test do
    Dir.glob("tmp/tarantula/**/index.html") do |file|
      if PLATFORM['darwin']
        system("open #{file}")
      elsif PLATFORM[/linux/]
        system("firefox #{file}")
      else
        puts "You can view tarantula results at #{file}"
      end
    end
  end  
TASK
end            
# http://github.com/tapajos/integration/tree/master
# http://integration.rubyforge.org/

# http://drnicwilliams.com/2008/01/04/autotesting-javascript-in-rails/
# http://github.com/drnic/jsunittest/tree/master


# sudo gem install fakeweb


#git :add => "."
#git :commit => "-m 'added bdd_stack'"


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
# webrat-0.4.4 - http://gitrdoc.com/brynary/webrat/tree/master/
# http://wiki.github.com/bmabey/email-spec/use-cucumber-to-test-email
# http://wiki.github.com/bmabey/email-spec/use-cucumber-to-test-mailers-in-rails
# http://www.benmabey.com/2009/02/05/leveraging-test-data-builders-in-cucumber-steps/
# http://themomorohoax.com/2009/03/08/rails-machinist-tutorial-machinist-with-cucumber-in-10-minutes
