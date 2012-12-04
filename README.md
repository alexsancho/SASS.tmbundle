TextMate SASS [![Build Status](https://secure.travis-ci.org/alexsancho/SASS.tmbundle.png)](http://travis-ci.org/alexsancho/SASS.tmbundle)
-------------

TextMate bundle to work with [SASS/SCSS][1] & [Compass][2] projects.

Pre-requisites
--------------

If you're running TextMate to write scss files is probably that you are ready to go, anyway there are a couple of requeriments before running this bundle. [The Sass Way][3] explains with full detail how to setup a development enviroment with sass and compass, you can read it here: [Getting started with Sass and Compass][4].

- sass gem
- compass gem
- css_parser (only needed to show full compass stats)

Installation
------------

In the terminal:

$ cd ~/Library/Application Support/Avian/Bundles  

$ git clone git://github.com/alexsancho/SASS.tmbundle.git SASS.tmbundle

Environment variables
---------------------

**TM_COMPASS**		: path to compass gem, not needed if is on your path  

**TM_COMPASS_DOCS** : compass docs url (optional, defaults to http://compass-style.org/)  

**TM_COMPASS_PATH** : full path to compass gem directory, required to use "Find Mixin", "Select Mixin", "Find Variable", "Select Variable" commands  

**TM_CSS_SPACE**    : used on snippets to define separation between rule and value

Command reference
-----------------

- **⌘S** Save current sass file and compile into css.
- **⌘R** Compile all files under `scss` directory into css
- **⌃⌘C** Convert selection to SASS/SCSS
- **⌘⇧P** Create a new compass project
- **⌥⇧C** Create a compass configuration file (config.rb)
- **⌘⇧W** Compile all files under `scss` directory and validates the generated CSS using W3C CSS Validator
- **⌘⌥⇧S** Print out statistics about your stylesheets
- **⇧⌘K** Search for selected mixin on compass source files
- **⌃⌘K** Search for selected variable
- **⌘K** Compass mixin completion
- **⌘⌥K** Compass variable completion
- **⌃H** Search for selected word in Compass documentation

THANKS
------

- https://github.com/chriseppstein

- http://minimaldesign.net/downloads/tools/textmate-css-bundle
- https://github.com/aussiegeek/ruby-sass-tmbundle
- https://github.com/postpostmodern/sass-generator-tmbundle
- https://github.com/handcrafted/sass-tmbundle
- https://github.com/kuroir/SCSS.tmbundle
- https://github.com/grimen/compass_blueprint_tmbundle
- https://github.com/dougochris/Compass.tmbundle
- https://github.com/ajaswa/scss_helpers

[1]: http://sass-lang.com/
[2]: http://compass-style.org/
[3]: http://thesassway.com/
[4]: http://thesassway.com/beginner/getting-started-with-sass-and-compass