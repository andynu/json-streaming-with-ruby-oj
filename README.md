# json-streaming-with-ruby-oj


If you have a huge json file, more than you want to load into memory all at once, then you need to stream it.

Here are two examples.
- array_streamer.rb reads the customers-array.json which is one huge array, and emits each element of the array to a provided proc.
- hash_streamer.rb reads the customers-hash.json which is one huge hash, and emits each key/value pair of the outer hash to a provided proc as a hash with just that key/value in it.


