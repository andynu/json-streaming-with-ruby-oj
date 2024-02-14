#!/usr/bin/env ruby
require 'oj'
require 'json'

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
