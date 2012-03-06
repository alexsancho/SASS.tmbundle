#!/usr/bin/env ruby -wKU
# encoding: utf-8

module SASS
	module Reader
		class << self
			def compile
				if compass_root
				  `#{compass_bin} compile #{@compass_root.gsub(' ','\ ')} --boring 2>&1`
				else
				  command = options.empty? ? "cat" : "tail -n +2"
				  `#{command} #{e_sh FILEPATH} | #{sass_bin} --style #{style} #{flags} > #{e_sh output_filename} 2>&1`
				end
			end
  
			def validate_compass
				if compass_root
					`#{compass_bin} validate #{@compass_root} --boring 2>&1`
				else
					command = options.empty? ? "cat" : "tail -n +2"
					`#{sass_bin} -c #{e_sh FILEPATH} 2>&1`
				end
			end

			def project_stats
				if compass_root
					`#{compass_bin} stats #{@compass_root} --boring 2>&1`
				end
			end

			def create_compass_project
				`#{compass_bin} create #{PROJECT} --app=stand_alone --environment=development --sass-dir=sass --css-dir=css --images-dir=img --javascripts-dir=js --output-style=expanded --no-line-comments --boring 2>&1`
			end

			def create_compass_config
				`#{compass_bin} config config.rb --app=stand_alone --environment=development --sass-dir=sass --css-dir=css --images-dir=img --javascripts-dir=js --output-style=expanded --no-line-comments --boring 2>&1`
			end

			def options
				return {} unless File.file?(FILEPATH)
				first_line = File.open(FILEPATH) {|f| f.readline unless f.eof} || ''
				return {} unless first_line.match(/\s*\/\/\s*(.+:.+)/)
  
				$1.split(',').inject({}) do |hash, pair|
					k,v = pair.split(':')
					hash[k.strip.to_sym] = v.strip if k && v
					hash
				end
			end
		private
  
			def type
				@type ||= FILEPATH[/.+\.(.+)/,1].to_sym
			end
  
			def flags
				options[:flags] || "-s"
			end

			def style
				options[:style] || "compact"
			end

			def compass_root
				if ENV["TM_COMPASS"] != "false"
					config = File.join(PROJECT, '/config.rb')

					@compass_root = PROJECT if File.exist?(config) || false

					return @compass_root
				end
				return false
			end

			def sass_bin
				@sass_bin ||= options[:engine] || type
			end

			def compass_bin
				@compass_bin ||= ENV["TM_COMPASS"] || "compass"
			end
  
			def output_filename
				@output_filename ||= options[:output] || (FILEPATH[/(.*)\.#{type}/,1] + ".css")
			end

		end
	end
end