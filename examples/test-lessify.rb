require 'lessify'

l = Lessify.new(:file => 'test.css')
puts l.to_scss
