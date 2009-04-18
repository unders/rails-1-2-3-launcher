#########################
#  SCM
#########################
git :init
 
# Set up .gitignore
file '.gitignore', <<-EOS.gsub(/^  /, '')
.DS_Store
config/database.yml
coverage/*
db/*.sqlite3
db/schema.rb
log/*.log
tmp/**/*
EOS

 
# tell git to hold empty directories
run "touch log/.gitignore tmp/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}


# Copy database.yml for distribution use 
run "cp config/database.yml config/database.yml.example"
 
git :add => "."
git :commit => "-m 'initial commit'"
