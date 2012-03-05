#!/usr/bin/env ruby -wKU
# encoding: utf-8

module Story
	module Log
		class << self
			LOG_FILE = "#{e_sh ENV['HOME']}/Library/Logs/StoryWriter.log"

			# Initilialise/clear the log.
			#
			def init
				f = File.open(LOG_FILE, "w")
				f.close
			end

			# Appends the given text to log file.
			#
			def puts(text)
				init unless File.exist?(LOG_FILE)

				f = File.open(LOG_FILE, "a")
				f.puts Time.now.strftime("\n[%m/%d/%Y %H:%M:%S]") + " TextMate::StoryWriter.tmbundle"
				f.puts text
				f.flush
				f.close
			end
		end		
	end
end
