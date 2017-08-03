require 'sinatra'
require 'json'
require 'yaml'
require_relative 'lib/admin/simple_database'
require_relative 'lib/admin/auth_helpers'
require_relative 'lib/admin/config_files'

helpers AuthHelpers

configure do
  set :db, SimpleDatabase.new(ENV['MONGODB_URI'])
  settings.db.create_if_empty(:user, name: 'admin', password: 'admin')
  settings.db.create_if_empty(:config, ConfigFiles.seed)
  set :schema, ConfigFiles.schema.to_json
  set :form, ConfigFiles.form.to_json
  `git config --global user.name "Static Publisher"` if `git config user.name`.empty?
  `git config --global user.email "static-publisher@example.com"` if `git config user.email`.empty?
end

get '/' do
  redirect '/admin'
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

post '/config' do
  protected!
  settings.db.set(:config, JSON.parse(request.body.read))
  halt 200
end

post '*' do |path|
  spawn("ruby #{File.expand_path('../bin/static_publisher.rb', __FILE__)} #{path}")
  halt 200
end
