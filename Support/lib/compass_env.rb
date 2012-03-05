#!/usr/bin/env ruby -wKU
# encoding: utf-8

# Used as a common require to set up the environment for commands. 

SUPPORT = "#{ENV['TM_SUPPORT_PATH']}"
BUN_SUP = File.expand_path(File.dirname(__FILE__))
DIALOG = SUPPORT + '/bin/tm_dialog'

require SUPPORT + '/lib/escape'
require SUPPORT + '/lib/exit_codes'
require SUPPORT + '/lib/textmate' 
require SUPPORT + '/lib/ui'
require SUPPORT + '/lib/tm/htmloutput'
require SUPPORT + '/lib/osx/plist'

require BUN_SUP + '/compass/log'
require BUN_SUP + '/compass/writer'
require BUN_SUP + '/compass/reader'

