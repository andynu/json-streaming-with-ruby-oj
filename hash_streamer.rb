#!/usr/bin/env ruby
require 'oj'
require 'json'

# This is a custom handler for Oj that will stream a JSON object to a processor
# as it is parsed. This is useful for large JSON objects that you don't want to
# load into memory all at once.
#
# Usage:
#   jsonio = File.open('customers-hash.json', 'r')
#   processor = proc { |result| p result }
#   Oj.sc_parse(HashHandler.new(processor), jsonio)
#
# The processor will be called with each hash object in the JSON file.
#
# Note: This is a very basic example and does not handle all JSON types.
# For a more complete example, see the Oj::ScHandler documentation.
# https://www.rubydoc.info/gems/oj/Oj/ScHandler
class HashHandler < ::Oj::ScHandler
  def initialize(processor)
    @processor = processor
    @hash_depth = 0
  end

  def hash_start
    @hash_depth += 1
    {}
  end

  def hash_set(h,k,v)
    if @hash_depth == 1
      @processor.call(k => v)
    else
      h[k] = v
    end
  end

  def hash_end
    @hash_depth -= 1
  end

  def array_start
    []
  end

  def array_append(a,v)
    a << v
  end

  def error(message, line, column)
    p "ERROR: #{message}"
  end
end

if __FILE__ == $0
  jsonio = File.open('customers-hash.json', 'r')
  processor = proc { |result| p result }
  Oj.sc_parse(HashHandler.new(processor), jsonio)
end


