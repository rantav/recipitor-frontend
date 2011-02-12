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
