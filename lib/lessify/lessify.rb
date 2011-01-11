require 'lessify'
require 'css_parser'

class Lessify
	include CssParser
	attr_accessor :parser, :root, :nodes

	# options are parsed in the following order:
	# if :file is given, the file is loaded and parsed
	# else, if :url is given, the url is loaded and parsed
	# else, if :css is given, the css is directly parsed
	# One of the above should be present, else constructor will throw an error
	def initialize(options = {})

		@parser = CssParser::Parser.new

		if options[:file] != nil
			@parser.load_file!(options[:file])
		elsif options[:url] != nil
			@parser.load_uri!(options[:url])
		elsif options[:css] != nil
			@parser.add_block!(options[:css])
		else
			raise "Lessify::initialize load error => options should contain one of :file, :url or :css"
		end

		@root = LessNode.new("*", nil)
		@nodes = []
		@parser.each_selector do |selector, declarations, specificity|
			node = @root.add_child(selector, declarations)
			@nodes.push(node)
		end
	end

	def to_scss(options={})
		return @root.to_scss("", options)
	end
end
