require 'spec_helper'

describe Lessify do

	it "should load css" do
		lessify = Lessify.new(:css => '#test { aaa: 11; }')
		lessify.should_not be_nil
	end

	it "should fail if options doesn't contain :css, :file and :url" do
		lambda { Lessify.new }.should raise_error RuntimeError
	end

	it "should print SCSS" do
		css = <<CSSRAW
			#a b c { abc: 1; }
			#a b d { abd: 2; }
			#a d   { ad:  3; }
			#e     { e:   4; }
CSSRAW

		lessify = Lessify.new( :css => css )
		pattern_without_declarations = generate_regex_pattern([ '\\*', '{', '#a', '{', 'b', '{', 'c', '{', '}', 'd', '{', '}', '}', 'd', '{', '}', '}', '#e', '{', '}', '}' ])
		lessify.to_scss(:print_declarations => false).should match pattern_without_declarations
		#puts lessify.to_scss(:print_declarations => false)
		
		pattern = generate_regex_pattern([ '\\*', '{', '#a', '{', 'b', '{', 'c', '{', 'abc: 1;', '}', 'd', '{', 'abd: 2;', '}', '}', 'd', '{', 'ad: 3;', '}', '}', '#e', '{', 'e: 4;', '}', '}' ])
		lessify.to_scss.should match pattern
	end
end
