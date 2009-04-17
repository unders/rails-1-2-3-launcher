

## Howto

To use this generator template I recommend adding this function to your bash profile.

    function railsapp {
      appname=$1
      rails $appname -m http://github.com/unders/rails-1-2-3-launcher/raw/master/generate.rb $@
    }

You can then use this "railsapp" command instead of the traditional "rails" one.

    railsapp appname

That will generate a Rails app using the generate.rb template found here.

## Thanks to / Inspirations / Stolen from

* Ryan Bates - http://github.com/ryanb/rails-templates/tree/master

--

Copyright (c) 2008 Anders Törnqvist
 
Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:
 
The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.