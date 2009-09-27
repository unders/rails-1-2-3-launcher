# http://ajaxian.com/archives/announcing-ajax-libraries-api-speed-up-your-ajax-apps-with-googles-infrastructure
# http://googleajaxsearchapi.blogspot.com/2008/05/speed-up-access-to-your-favorite.html
# http://code.google.com/apis/ajaxlibs/
# http://code.google.com/apis/ajaxlibs/documentation/index.html
# http://github.com/christianhellsten/jquery-google-analytics/tree/master
# http://github.com/danwrong/low-pro-for-jquery/tree/master

# Testing
# http://drnicwilliams.com/2008/01/04/autotesting-javascript-in-rails/
# http://github.com/drnic/jsunittest/tree/master

# or

# http://github.com/relevance/blue-ridge/tree/master


run "curl -s -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery.js"
run "touch public/javascripts/application.js"
git :add => ".", :commit => "-m 'Added jquery'"
 
plugin "blue-ridge", :git => 'git://github.com/unders/blue-ridge.git'
generate :blue_ridge

git :add => ".", :commit => "-m 'Added blue-ridge'"
