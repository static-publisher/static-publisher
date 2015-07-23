require 'sinatra'
require 'json'
require 'yaml'
require_relative 'lib/admin/simple_database'
require_relative 'lib/admin/auth_helpers'
require_relative 'lib/admin/config_files'
require_relative 'lib/hook_matcher'

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
  hooks = settings.db[:data][:hooks]
  indexes = HookMatcher.matching_indexes(hooks, path, body, gh_signature)

  if indexes.any?
    process_hook = File.expand_path('../bin/process_hook.rb', __FILE__)
    spawn("ruby #{process_hook} #{indexes.join(' ')}")
    halt 200
  else
    halt 404
  end
end
