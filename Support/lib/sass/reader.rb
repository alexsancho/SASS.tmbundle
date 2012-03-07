#!/usr/bin/env ruby -wKU
# encoding: utf-8

module SASS
	module Reader
		class << self
			def compile_file
				msg = "Converting #{FILEPATH} to #{output_filename} ..."
				Sass::compile_file(FILEPATH, output_filename, options)
				msg += "\nDone"
			rescue Sass::SyntaxError => e
				msg += "\nSass syntax error!"
				msg += "\n#{FILEPATH}, Line #{e.sass_line}: #{e}"
				msg
			end
  
			def validate_compass
				if compass_root
					`#{compass_bin} validate #{@compass_root} --boring 2>&1`
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
				hash = defaults
				return hash unless File.file?(FILEPATH)
				first_line = File.open(FILEPATH) {|f| f.readline unless f.eof} || ''
				return hash unless first_line.match(/\s*\/\/\s*(.+:.+)/)
  
				$1.split(',').inject({}) do |hash, pair|
					k,v = pair.split(':')
					hash[k.strip.to_sym] = v.strip.to_sym if k && v
				end
				hash
			end
		private
			def defaults
				if compass_root
					Compass.add_project_configuration Compass.detect_configuration_file(compass_root)
					hash = Compass.sass_engine_options;
				else
					hash = {}
				end
			end

			def type
				@type ||= FILEPATH[/.+\.(.+)/, 1].to_sym
			end

			def compass_root
				if ENV["TM_COMPASS"] != "false"
					@compass_root = PROJECT if Compass.detect_configuration_file(PROJECT) || false

					return @compass_root
				end
				return false
			end

			def compass_bin
				@compass_bin ||= ENV["TM_COMPASS"] || "compass"
			end
  
			def output_filename
				file = (FILEPATH[/(.*)\.#{type}/,1] + ".css").gsub(/\/sass\//, '/css/')
				@output_filename ||= options[:output] || file
			end

		end
	end
end