require "sinatra"
require "active_record"
require "./lib/database_connection"

class App < Sinatra::Application
  def initialize
    super
    @database_connection = GschoolDatabseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    "Hello"
  end
end
