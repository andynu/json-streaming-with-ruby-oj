#!/usr/bin/env ruby
require 'oj'
require 'json'

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

jsonio = File.open('customers-hash.json', 'r')
processor = proc { |result| p result }
Oj.sc_parse(HashHandler.new(processor), jsonio)


