require 'sinatra'
require 'json'
require 'yaml'
require_relative 'lib/admin/simple_database'
require_relative 'lib/admin/auth_helpers'
require_relative 'lib/admin/config_files'
require_relative 'lib/sequence_matcher'

helpers AuthHelpers

configure do
  set :db, SimpleDatabase.new(ENV['MONGOLAB_URI'])
  settings.db.create_if_empty(:user, name: 'admin', password: 'admin')
  settings.db.create_if_empty(:data, ConfigFiles.seed)
  set :schema, ConfigFiles.schema.to_json
  set :form, ConfigFiles.form.to_json
  `git config --global user.name "Static Publisher"` if `git config user.name`.empty?
  `git config --global user.email "static-publisher@example.com"` if `git config user.email`.empty?
end

get '/admin' do
  protected!
  erb :admin
end

post '/user' do
  protected!
  settings.db.set(:user, params)
  redirect '/admin'
end

post '/data' do
  protected!
  settings.db.set(:data, JSON.parse(request.body.read))
  halt 200
end

post '*' do |path|
  request.body.rewind
  body = request.body.read
  gh_signature = request.env['HTTP_X_HUB_SIGNATURE']
  sequences = settings.db[:data][:sequences]
  indexes = SequenceMatcher.matching_indexes(sequences, path, body, gh_signature)

  if indexes.any?
    process_sequence = File.expand_path('../bin/process_sequence.rb', __FILE__)
    spawn("ruby #{process_sequence} #{indexes.join(' ')}")
    halt 200
  else
    halt 404
  end
end
