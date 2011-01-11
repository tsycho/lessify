require 'css_parser'
require 'lessify'

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

end

def generate_regex_pattern(str_array)
	pattern = '^\s*' + str_array.join('\s*') + '\s*$'
	return Regexp.new(pattern)
end

