require 'mongo'

Mongo::Logger.logger.level = Logger::WARN

class SimpleDatabase
  def initialize(url)
    @db_client = Mongo::Client.new(url)
    fail(DatabaseNotFound) unless database_exists?
  end

  attr_reader :db_client

  def create_if_empty(collection, default)
    db_client[collection].insert_one(default) if empty?(collection)
  end

  def [](collection)
    db_client[collection].find.first
  end

  def set(collection, opts)
    db_client[collection].find.find_one_and_replace(opts)
  end

  private

  def database_exists?
    !db_client.cluster.servers.empty?
  end

  def empty?(collection)
    db_client[collection].find.count == 0
  end
end

class DatabaseNotFound < StandardError; end
