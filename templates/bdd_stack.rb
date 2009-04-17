# All gems are added to config/environments/test.rb and installed to the system if not already installed.
gem 'rspec', :lib => false, :version => ">= 1.2.4", :env => 'test'
gem 'rspec-rails', :lib => false, :version => ">= 1.2.4", :env => 'test'

rake "gems:install", :env => "test", :sudo => true
generate "rspec"

gem 'term-ansicolor', :env => 'test'
gem 'treetop', :env => 'test'
gem 'diff-lcs', :env => 'test' 
gem 'nokogiri', :env => 'test' 
gem 'builder', :env => 'test'
gem 'cucumber', :version => ">= 0.3.0", :env => 'test'
gem 'webrat', :version => ">= 0.4.4", :env => 'test'

rake "gems:install", :env => "test", :sudo => true

generate "cucumber" 

gem 'remarkable_rails', :lib => false, :version => ">= 3.0.3", :env => 'test'
file_inject 'spec/spec_helper.rb', "require 'spec/rails'", "require 'remarkable_rails'"


# And then require remarkable inside your spec_helper.rb, after "spec/rails":
# require 'spec/rails'
# require 'remarkable_rails'

# sudo gem install notahat-machinist --source http://gems.github.com

# faker-0.3.1 - http://faker.rubyforge.org/rdoc/
# gem install populator-0.2.5 - http://github.com/ryanb/populator/tree/master



#git :add => "."
#git :commit => "-m 'added bdd_stack'"

# references:
# webrat-0.4.4 - http://gitrdoc.com/brynary/webrat/tree/master/