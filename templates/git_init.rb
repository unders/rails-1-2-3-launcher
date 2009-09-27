#########################
#  SCM
#########################
git :init
 
# Ignore auto-generated files
file '.gitignore', 
%q{coverage/*
log/*.log
log/*.pid
db/*.db
db/*.sqlite3
db/schema.rb
tmp/**/*
.DS_Store
doc/api
doc/app
config/database.yml
public/javascripts/all.js
public/stylesheets/all.js
coverage/*
.dotest/*
spec/fixtures/*.yml
spec/javascripts/fixtures/*.html
public/uploads
}

 
# Tell git to hold empty directories
run "touch log/.gitignore tmp/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}


# Copy database.yml for distribution use 
run "cp config/database.yml config/database.yml.example"
 
git :add => "."
git :commit => "-m 'initial commit'"
