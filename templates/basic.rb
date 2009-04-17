# Delete unnecessary files
run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
run "rm public/images/rails.png"
run "rm -f public/javascripts/*"

git :commit => "-a -m 'removed files: README, 
                                      public/index.html, 
                                      public/favicon.ico, 
                                      public/robots.txt, 
                                      public/images/rails.png,
                                      public/javascripts/*'"