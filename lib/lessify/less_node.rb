
class LessNode
	attr_accessor :selector, :parent, :child_nodes, :declarations, :dec_array
	
	def initialize(selector, parent, declarations = "")
		@selector = selector
		@parent = parent
		@declarations = declarations.strip
		@child_nodes = []
		update_declarations_array
		parent.child_nodes.push(self) unless parent.nil?
	end
	
	def update_declarations_array
		@dec_array = declarations.split(";").map { |d| d.strip }
	end
	
	def has_child?(selector)
		@child_nodes.map { |cnode| cnode.selector == selector }.reduce(:|)
	end
	
	def child(selector)
		@child_nodes.find { |cnode| cnode.selector == selector }
	end
	
	def add_child(selector_string, declarations)
		selectors = selector_string.strip.split(" ")
		node = self
		selectors.each do |sel|
			if node.has_child?(sel)
				node = node.child(sel)
			else
				newNode = LessNode.new(sel, node)
				node = newNode
			end
		end		
		node.declarations += (" " + declarations.strip)
		node.declarations.strip!
		node.update_declarations_array
		return node
	end
	
	def to_scss(prefix = "", options = {})
		tab = options['tab'] || "\t"
		print_declarations = options[:print_declarations]
		print_declarations = true if print_declarations.nil?
		
		str = prefix + selector + " {"
		if (@child_nodes.size==0) && (!print_declarations || declarations.strip.size==0)
			str += "}\n"
		else
			str += "\n"
			str += (prefix + tab + declarations + "\n") if (print_declarations && declarations.strip.size>0)
			@child_nodes.each { |cnode| str += cnode.to_scss(prefix + tab, options) }
			str += prefix + "}\n"
		end
	end
	
	# Search through the tree for selector
	def find(selector)
		node = child(selector)
		return node unless node.nil?
		@child_nodes.each { |cnode| 
			n = cnode.find(selector)
			return n unless n.nil?
		}
		return nil
	end

	def move(sel_parent, sel_child)
		parent_node = find(sel_parent)
		raise "#{sel_parent} not found" if parent_node.nil?
		
		child_node = find(sel_child)
		raise "#{sel_child} not found" if child_node.nil?
		
		node = parent_node
		until node.nil?
			raise "Move will create a cycle in the tree" if node == child_node
			node = node.parent
		end
		child_node.parent.child_nodes.delete(child_node)
		parent_node.child_nodes.push(child_node)
		child_node.parent = parent_node
	end
	
	def print_ancestry(selector)
		node = find(selector)
		puts "Printing ancestry for #{node}..."
		until node.nil?
			puts "\t#{node.to_s}"
			node = node.parent
		end
	end
	
end

