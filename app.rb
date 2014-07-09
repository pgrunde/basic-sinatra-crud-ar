require "sinatra"
require "active_record"
require "./lib/database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = DatabaseConnection.new(ENV["RACK_ENV"])
  end

  get "/" do
    erb :root, :layout => :main_layout
  end

  get "/register/" do
    erb :register, :layout => :main_layout
  end

  post "/register/" do
    database_connection.sql("INSERT INTO users (username, password) VALUES (#{params[:username]}, #{params[:password]})")
    flash[:register_notice] = "Thank you for registering"
    redirect "/"
  end
end