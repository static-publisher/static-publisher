#!/usr/bin/env ruby

require_relative '../lib/admin/simple_database'
require_relative '../lib/hook_processor'

hooks = SimpleDatabase.new(ENV['MONGOLAB_URI'])[:data][:hooks]
ARGV.each { |i| HookProcessor.process(hooks[i.to_i]) }
