# Remove tmp directories
%w[tmp/pids tmp/sessions tmp/sockets tmp/cache].each do |dir|
  run("rm -rf #{dir}")
end
 
# Delete unnecessary files.
%w[README doc/README_FOR_APP public/index.html public/favicon.ico 
   public/robots.txt public/images/rails.png].each do |file|
  run("rm #{file}")
end
run "rm -f public/javascripts/*"

git :add => "-u"
git :commit => "-m 'removed files: README, 
                                   doc/README_FOR_APP
                                   public/index.html, 
                                   public/favicon.ico, 
                                   public/robots.txt, 
                                   public/images/rails.png,
                                   public/javascripts/*'"