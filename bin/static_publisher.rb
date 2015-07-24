#!/usr/bin/env ruby

require_relative '../lib/admin/simple_database'
require_relative '../lib/sequence_processor'

puts "Static Publisher - path: #{ARGV[0]}"
sequences = SimpleDatabase.new(ENV['MONGOLAB_URI'])[:config][:sequences]
sequences.each { |s| SequenceProcessor.process(s) if s['route'] == ARGV[0] }
