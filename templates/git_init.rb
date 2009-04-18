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

app_db = File.basename(root).gsub(/[-\s]/, '_').downcase
file 'config/database.yml', <<-EOS.gsub(/^  /, '')
development:
  adapter: mysql
  encoding: utf8
  reconnect: false
  database: #{app_db}_development
  pool: 5
  username: root
  password:
  socket: /tmp/mysql.sock

test:
  adapter: mysql
  encoding: utf8
  reconnect: false
  database: #{app_db}_test
  pool: 5
  username: root
  password:
  socket: /tmp/mysql.sock

production:
  adapter: mysql
  encoding: utf8
  reconnect: false
  database: #{app_db}_production
  pool: 5
  username: root
  password: 
EOS
# Copy database.yml for distribution use
  run "cp config/database.yml config/database.yml.example"
# Copy database.yml for distribution use 
run "cp config/database.yml config/database.yml.example"
 
git :add => "."
git :commit => "-m 'initial commit'"
