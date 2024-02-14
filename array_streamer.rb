#!/usr/bin/env ruby
require 'oj'
require 'json'

# This is a custom handler for Oj that will stream a JSON array to a processor
# as it is parsed. This is useful for large JSON arrays that you don't want to
# load into memory all at once.
#
# Usage:
#   jsonio = File.open('customers-array.json', 'r')
#   processor = proc { |result| p result }
#   Oj.sc_parse(ArrayHandler.new(processor), jsonio)
#
# The processor will be called with each array object in the JSON file.
#
# Note: This is a very basic example and does not handle all JSON types.
# For a more complete example, see the Oj::ScHandler documentation.
# https://www.rubydoc.info/gems/oj/Oj/ScHandler
class ArrayHandler < ::Oj::ScHandler
  def initialize(processor)
    @processor = processor
    @array_depth = 0
  end

  def hash_start
    {}
  end

  def hash_set(h,k,v)
    h[k] = v
  end

  def array_start
    @array_depth += 1
    []
  end

  def array_end
    @array_depth -= 1
  end

  def array_append(a,v)
    if @array_depth == 1
      @processor.call(v)
    else
      a << v
    end
  end

  def error(message, line, column)
    p "ERROR: #{message}"
  end
end

if __FILE__ == $0
  jsonio = File.open('customers-array.json', 'r')
  processor = proc { |result| p result }
  Oj.sc_parse(ArrayHandler.new(processor), jsonio)
end
