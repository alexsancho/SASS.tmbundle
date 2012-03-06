#!/usr/bin/env ruby -wKU
# encoding: utf-8

module SASS
	module Writer
		class << self
			def render(title, result)
			  html_header(title)

			  puts '<pre>'
			  puts result
			  puts '</pre>'

			  html_footer
			end

			def convert(type)
				require 'rubygems'
				require 'sass/css'; 

				puts Sass::CSS.new(ENV['TM_SELECTED_TEXT']).render(type)
			end

		end
	end
end