Recipitor frontend
==================

This is the code for the frontend currently hosted at http://recipitor.heroku.com/


Installation and dependencies
=============================
Here's a list of the current versions of rails, rake heroku etc. It's not absolutely required that you used all of the same versions but if something goes crypticly wrong then versions are a good place to start checking for.

$ rails --version
Rails 3.0.4
$ gem --version
1.5.0
$ rake --version
rake, version 0.8.7
$ bundle -v
Bundler version 1.0.10
$ ruby -v
ruby 1.9.2p136 (2010-12-25 revision 30365) [i386-darwin9.8.0]

We also have jruby, but not currently used:
$ jruby -v
jruby 1.6.0.RC1 (ruby 1.8.7 patchlevel 330) (2011-01-10 769f847) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_22) [darwin-x86_64-java]

ImageMagick
-----------
ImageMagic is a very popular image manipulation library. http://www.imagemagick.org/script/index.php
It has a native linux version and a MacPorts version (or fink version) as well.

For image manipulation I'm using rails Paperclip (https://github.com/thoughtbot/paperclip) which depends on ImageMagic. (Heroku have ImageMagic installed natively).
So in order to work with images in the frontend you'll need to install it. See instructions here http://www.imagemagick.org/script/binary-releases.php

To verify installation you should see:
$ convert
Version: ImageMagick 6.6.6-3 2011-02-10 Q16 http://www.imagemagick.org
Copyright: Copyright (C) 1999-2010 ImageMagick Studio LLC
...

Getting started
===============
After having installed of the the dependencies run:

$ gem install bundler
$ bundle install
$ rake db:migrate
$ rake server

Browse 
* http://localhost:3000 for the static html
* http://localhost:3000/receipts for the application main page


Troubleshooting
===============
Validate gems are installed using
$ bundle check
if you wish to see server log in the console use
$ ruby script/rails server


Run Tests
=========
$ rake test

Debugging
=========
Debugging with ruby 1.9.3 and rails 3.0.x is not rully functioning on all systems.
Usually what you need to do is install the following:
 $ sudo gem install ruby-debug

To test that it worked:

 $ rdebug --version
 ruby-debug 0.11

For me, that wasn't enough so I followed the instructions at http://dirk.net/2010/04/17/ruby-debug-with-ruby-19x-and-rails-3-on-rvm/
Hence:
 # Replace the path with your rvm install path of the current ruby you're using.
 $ gem install ruby-debug19 -- -with-ruby-include=/Users/ran/.rvm/src/ruby-1.9.2-p136
 # and optionally:
 $ gem install  ruby-debug-ide19  -- -with-ruby-include=/Users/ran/.rvm/src/ruby-1.9.2-p136
 $ bundle install # this will run the line "gem 'ruby-debug19', :require => 'ruby-debug'" from this file

Now try again
 $ rdebug --version

Next, place some breakpoint in your code. where you want to break simply type "debugger" as in:

   def img_url(style = nil, include_updated_timestamp = true)
     debugger
     url = Paperclip::Interpolations.interpolate('/rcpt/:id/:style/:filename', img, style || img.default_style)
     include_updated_timestamp && img.updated_at ? [url, img.updated_at].compact.join(url.include?("?") ? "&" : "?") : url
  end


Next, Uncomment this line at Gemfile
# gem 'ruby-debug19', :require => 'ruby-debug'
Then
 $ bundle install

...Then run the code:
$ rake test # to debug tests
$ rails server # to debug a server
=======
Browse http://localhost:3000
>>>>>>> trobleshooting

Troubleshooting
===============
Validate gems are installed using
$ bundle check
if you wish to see server log in the console use
$ ruby script/rails server



