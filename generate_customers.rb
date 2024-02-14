#!/usr/bin/env ruby
require 'json'
require 'faker'

n = 20_000
File.open('customers.json', 'w') do |f|
  f.write("[")
  
  n.times do |i|
    #f << "\"#{i}\":"
    f << {
      name: Faker::Name.name,
      email: Faker::Internet.email,
      address: Faker::Address.street_address 
    }.to_json

    f.write(",\n") unless i == n - 1
    print '.' if i % 1_000 == 0
    puts if i % 10_000 == 0
  end
  
  f.write("]")
end
