#!/usr/bin/env ruby -wKU
# encoding: utf-8

class NoSassDirError < StandardError; end

module SASS
	module Reader
		class << self
			def compile_file(filepath, project)
				msg = "\nConverting #{filepath} to #{output_filename(filepath, project)} ..."
				Sass::compile_file(filepath, output_filename(filepath, project), options(filepath, project))
				msg += "\nDone"
			rescue Sass::SyntaxError => e
				msg += "\nSass syntax error!"
				msg += "\n#{filepath}, Line #{e.sass_line}: #{e}"
				msg
			end

			def compile_project(directory, project, max_depth=4)
				Dir.chdir(directory)

				i = 1
				until Dir.getwd.match(/scss\/?$/) do
					raise NoSassDirError if (i > max_depth) or (Dir.getwd == project)
					Dir.chdir('../')
					i += 1
				end

				msg = "\nReady to compile all files under #{Dir.getwd}"

				sass_files = Dir.open('.') do |d|
					d.find_all { |f| f.match /^[^_].*\.scss$/ }
				end

				sass_files.each do |sass|
					msg += compile_file("#{Dir.getwd}/"+sass, project)
				end
				msg
			rescue NoSassDirError
				msg += "\nCan't find sass dir!"
				msg
			end

			def compass_validate(project)
				`#{compass_bin} validate #{@compass_root} --boring 2>&1` if compass_root(project)
			end

			def compass_stats(project)
				`#{compass_bin} stats #{@compass_root} --boring 2>&1` if compass_root(project)
			end

			def compass_project(project)
				`#{compass_bin} create #{project} --app=stand_alone --environment=development --sass-dir=scss --css-dir=css --images-dir=img --javascripts-dir=js --output-style=expanded --no-line-comments --boring 2>&1`
			end

			def compass_config
				`#{compass_bin} config config.rb --app=stand_alone --environment=development --sass-dir=scss --css-dir=css --images-dir=img --javascripts-dir=js --output-style=expanded --no-line-comments --boring 2>&1`
			end

			def options(filepath, project)
				hash = defaults(project)
				return hash unless File.file?(filepath)
				first_line = File.open(filepath) {|f| f.readline unless f.eof} || ''
				return hash unless first_line.match(/\s*\/\/\s*(.+:.+)/)
  
				$1.split(',').inject({}) do |hash, pair|
					k,v = pair.split(':')
					hash[k.strip.to_sym] = v.strip.to_sym if k && v
				end
				hash
			end
		private
			def defaults(project)
				if compass_root(project)
					Compass.add_project_configuration Compass.detect_configuration_file(@compass_root)
					hash = Compass.sass_engine_options;
				else
					hash = {}
				end
			end

			def type(filepath)
				@type = filepath[/.+\.(.+)/, 1].to_sym
			end

			def compass_root(project)
				@compass_root = project if Compass.detect_configuration_file(project) || false
			end

			def compass_bin
				@compass_bin ||= ENV["TM_COMPASS"] || "compass"
			end
  
			def output_filename(filepath, project)
				file = (filepath[/(.*)\.#{type(filepath)}/,1] + ".css").gsub(/\/scss\//, '/css/')
				@output_filename = options(filepath, project)[:output] || file
			end

		end
	end
end