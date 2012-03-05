class TMSass
	def self.compile
		SassEngine.new().execute!("Compile project")
	end

	def self.config
		SassEngine.new().compass_config!("Creating Compass Config")
	end

	def self.project
		SassEngine.new().compass_create!("Creating Compass Project")
	end

	def self.validate
		SassEngine.new().validate!("Validating Project")
	end

	def self.stats
		SassEngine.new().status!("Project Stats")
	end

  def self.convert(type)
    SassEngine.new().convert!(type)
  end

end

class SassEngine
	def initialize
		@filename = ENV['TM_FILEPATH']
		@project = ENV['TM_PROJECT_DIRECTORY']
	end
  
	def execute!(title)
		compile!
		render!(title)
		preview!
	end

	def compass_create!(title)
		create!
		render!(title)
	end

	def compass_config!(title)
		config!
		render!(title)
	end

	def validate!(title)
		valid!
		render!(title)
	end

	def status!(title)
		stats!
		render!(title)
	end

  def convert!(type)
    require 'rubygems'
    require 'sass/css'; 

    puts Sass::CSS.new(ENV['TM_SELECTED_TEXT']).render(type)
  end

private
	def render!(title)
	  require File.join(ENV["TM_SUPPORT_PATH"], "lib/web_preview")

	  html_header(title)

	  puts '<pre>'
	  puts @result
	  puts '</pre>'

	  html_footer
	end
  
	def compile!
		if compass_root
		  @result = `#{compass_bin} compile #{@compass_root.gsub(' ','\ ')} --boring 2>&1`
		else
		  command = options.empty? ? "cat" : "tail -n +2"
		  @result = `#{command} #{escape(@filename)} | #{engine} --style #{style} #{flags} > #{escape(output_filename)} 2>&1`
		end
	end
  
	def valid!
		if compass_root
			@result = `#{compass_bin} validate #{@compass_root} --boring 2>&1`
		else
			command = options.empty? ? "cat" : "tail -n +2"
			@result = `#{engine} -c #{escape(@filename)} 2>&1`
		end
	end

	def stats!
		if compass_root
			@result = `#{compass_bin} stats #{@compass_root} --boring 2>&1`
		end
	end

	def create!
		@result = `#{compass_bin} create #{@project} --app=stand_alone --environment=development --sass-dir=sass --css-dir=css --images-dir=img --javascripts-dir=js --output-style=expanded --no-line-comments --boring 2>&1`
	end

	def config!
		@result = `#{compass_bin} config config.rb --app=stand_alone --environment=development --sass-dir=sass --css-dir=css --images-dir=img --javascripts-dir=js --output-style=expanded --no-line-comments --boring 2>&1`
	end

	def preview!
		Kernel.system("open -g #{escape(preview_filename)}") if process_status.exitstatus.zero? && preview_filename
	end
  
	def escape(s)
		"\"#{s.gsub('"', '\"')}\""
	end
  
	def process_status
		$?
	end
  
	def options
		return {} unless File.file?(@filename)
		first_line = File.open(@filename) {|f| f.readline unless f.eof} || ''
		return {} unless first_line.match(/\s*\/\/\s*(.+:.+)/)
  
		$1.split(',').inject({}) do |hash, pair|
			k,v = pair.split(':')
			hash[k.strip.to_sym] = v.strip if k && v
			hash
		end
	end

	alias :options_no_memo :options
	def options; @options ||= options_no_memo end
  
	def type
		@type ||= @filename[/.+\.(.+)/,1].to_sym
	end
  
	def flags
		options[:flags] || "-s"
	end

	def engine
		options[:engine] || type
	end

	def style
		options[:style] || "compact"
	end

	def compass_root
		if ENV["TM_COMPASS"] != "false"
			config = File.join(@project, '/config.rb')

			@compass_root = @project if File.exist?(config) || false

			return @compass_root
		end
		return false
	end

	def compass_bin
		@compass_bin ||= ENV["TM_COMPASS"] || "compass"
	end
  
	def output_filename
		@output_filename ||= options[:output] || (@filename[/(.*)\.#{type}/,1] + ".css")
	end

	def preview_filename
		return if options[:preview] == "none"
		@preview_filename ||= File.join(File.split(@filename)[0], options[:preview]) if options[:preview]
	end

end