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

# Functional programming aid for Javascript. Works well with jQuery.
# http://github.com/documentcloud/underscore
# http://documentcloud.github.com/underscore/underscore-min.js
#  http://documentcloud.github.com/underscore/underscore.js

#http://code.quirkey.com/sammy/resources.html
#http://blog.joecorcoran.co.uk/past/2009/7/2/practical_uses_for_sammy/
#http://code.quirkey.com/sammy/resources.html
#http://github.com/ahe/sammy_crud
#http://code.quirkey.com/sammy/tutorials/json_store_part1.html

#http://github.com/hafriedlander/jquery.concrete/
#http://github.com/hafriedlander/jquery.concrete/tree/master/spec/

#http://github.com/sbecker/asset_packager

# http://json.org/json2.js

# http://closure-library.googlecode.com/svn/trunk/closure/goog/docs/closure_goog_locale_locale.js.html
# http://closure-library.googlecode.com/svn/trunk/closure/goog/docs/closure_goog_timer_timer.js.html

# http://github.com/rpbertp13/kiwi

# http://github.com/visionmedia/jquery-rest
# Json
# http://www.maheshchari.com/jquery-ajax-error-handling/
# http://www.bennadel.com/blog/1392-Handling-AJAX-Errors-With-jQuery.htm
# http://www.railsfire.com/article/handling-ajax-errors-and-displaying-friendly-error-messages-users
# http://stackoverflow.com/questions/872206/http-status-code-0-what-does-this-mean-in-ms-xmlhttp
# http://www.intridea.com/2008/7/23/using-http-status-codes-for-rails-ajax-error-handling?blog=company

# http://github.com/intridea/hashie

# http://github.com/visionmedia/mojo
run "curl -s -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery.js"
run "touch public/javascripts/application.js"
git :add => "."
git :commit => "-m 'Added jquery'"
 
plugin "blue-ridge", :git => 'git://github.com/unders/blue-ridge.git'
generate :blue_ridge

git :add => "."
git :add => "-u"
git :commit => "-m 'Added blue-ridge'"
