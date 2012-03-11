#!/usr/bin/env ruby -wKU
# encoding: utf-8

require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8
require 'spec'

ENV['TM_SUPPORT_PATH'] = '/Library/Application\ Support/TextMate/Managed/Bundles/Bundle\ Support.tmbundle/Support/shared'

ENV['TM_DIRECTORY'] = File.expand_path(File.join(File.dirname(__FILE__), "../fixtures"))
ENV['TM_PROJECT_DIRECTORY'] = File.expand_path(File.join(File.dirname(__FILE__), "../fixtures"))

require File.expand_path(File.join(File.dirname(__FILE__), "../lib", "env"))
