require 'spec_helper'

describe LessNode do

	before(:each) do
		@node = LessNode.new("*", nil)
		declarations = " aaa: a1; bbb: b2;   "
		@node2 = LessNode.new("node2", @node, declarations)
		@node3 = @node.add_child("node2 node3", declarations)
		@node3 = @node.add_child("node2 node3", "ccc: c3;")
	end

	it "should create a new LessNode object with default parameters" do
		node = LessNode.new("*", nil)
		node.selector.should == "*"
		node.parent.should be_nil
		node.declarations.should == ""
		node.dec_array.should == []
		node.child_nodes.should == []
	end

	it "should create parent-child relationships when a child node is added" do
		@node2.parent.should == @node
		@node.child_nodes[0].should == @node2
	end

	it "should load declarations, and remove extraneous whitespace, from constructor" do
		@node2.declarations.should == "aaa: a1; bbb: b2;"
		@node2.dec_array.size.should == 2
		@node2.dec_array[0].should == "aaa: a1"
		@node2.dec_array[1].should == "bbb: b2"
	end

	it "should load and append declarations, and remove extraneous whitespace, from add_child" do
		@node3.declarations.should == "aaa: a1; bbb: b2; ccc: c3;"
		@node3.dec_array.size.should == 3
		@node3.dec_array[0].should == "aaa: a1"
		@node3.dec_array[1].should == "bbb: b2"
		@node3.dec_array[2].should == "ccc: c3"
	end

	it "should add child nodes heirarchically" do
		@node.child_nodes.should == [@node2]
		@node2.child_nodes.should == [@node3]
		@node3.parent.should == @node2
	end

	it "should be able to find nodes" do
		@node.has_child?("node2").should be_true
		@node2.has_child?("node3").should be_true
		@node.has_child?("node3").should be_false

		@node.child("node2").should == @node2
		@node.child("node3").should be_nil
		@node2.child("node3").should == @node3

		@node.find("node2").should == @node2
		@node.find("node3").should == @node3
	end

	it "should be able to move nodes when the move is legal" do
		new_node = LessNode.new("newNode", @node)
		@node.move("node2", "newNode")
		@node2.has_child?("newNode").should be_true
		@node2.child("newNode").should == new_node
		new_node.parent.should == @node2
	end

	it "should raise error if an illegal move is tried" do
		lambda { @node.move("node3", "node2") }.should raise_error RuntimeError
	end

	it "should not create duplicates or fail if a child node is moved to its parent" do
		@node.move("node2", "node3")
		@node2.child_nodes.size.should == 1
		@node2.child_nodes[0] == @node3
		@node3.parent.should == @node2
	end

	it "should print SCSS without declarations if print_declarations=>false" do
		@node3.to_scss("", :print_declarations => false).should match generate_regex_pattern(["node3", "{", "}"]) 
		@node2.to_scss("", :print_declarations => false).should match generate_regex_pattern(["node2", "{", "node3", "{", "}", "}"])
		@node.to_scss( "", :print_declarations => false).should match generate_regex_pattern(['\\*', "{", "node2", "{", "node3", "{", "}", "}", "}"])

		@node.selector = "node"
		@node.to_scss( "", :print_declarations => false).should match generate_regex_pattern(['node', "{", "node2", "{", "node3", "{", "}", "}", "}"])
	end

	it "should print SCSS with declarations" do
		@node3.to_scss("").should match generate_regex_pattern(["node3", "{", "aaa: a1;", "bbb: b2;", "ccc: c3;", "}"]) 
		@node2.to_scss("").should match generate_regex_pattern(["node2", "{", "aaa: a1;", "bbb: b2;", "node3", "{", "aaa: a1;", "bbb: b2;", "ccc: c3;", "}", "}"]) 
	end

	it "should print SCSS with prefix" do
		@node3.to_scss("--", :print_declarations => false).should match generate_regex_pattern(["--node3", "{", "}"]) 
		@node3.to_scss("--").should match generate_regex_pattern(["--node3", "{", "--", "aaa: a1;", "bbb: b2;", "ccc: c3;", "--}"]) 
	end
end
