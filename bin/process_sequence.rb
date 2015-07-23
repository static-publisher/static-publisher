#!/usr/bin/env ruby

require_relative '../lib/admin/simple_database'
require_relative '../lib/sequence_processor'

sequences = SimpleDatabase.new(ENV['MONGOLAB_URI'])[:data][:sequences]
ARGV.each { |i| SequenceProcessor.process(sequences[i.to_i]) }
