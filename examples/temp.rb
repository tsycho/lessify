require 'lessify'

# This is not a real example.
# Part of this code should be folded into the lessify gem

rootNode = LessNode.new("*", nil)
dec_hash = { }
nodes = []

parser = CssParser::Parser.new
parser.load_uri!(ARGV[0] || 'test.css')
parser.each_selector do |selector, declarations, specificity|
	node = rootNode.add_child(selector, declarations)
	nodes.push(node)
	dec_array = node.dec_array
	dec_array.each { |d| 
		val = dec_hash[d] || 0
		dec_hash[d] = (val+1)
	}	
end

if ARGV[0] == 'style.css'
	rootNode.move("#outer-container", "#outer-glow-top")
	rootNode.move("#outer-container", "#container")
	rootNode.move("#container", "#container-pattern")
	rootNode.move("#container-pattern", "#top-navigation")
	rootNode.move("#top-navigation", "#topnav")
	
	rootNode.move("#container-pattern", "#header")
	rootNode.move("#header", "#slider")
	rootNode.move("#slider", "#slider-navigation")
	
	rootNode.move("#container-pattern", "#footer")
end

#puts rootNode.to_string("", { 'tab' => '  ', 'print_declarations'=> true })

dec_hash.each { |k,v| puts "#{k}\t=> #{v}" if v>3 }
