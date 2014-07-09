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
    if session[:user_id]
      @username = @database_connection.sql("SELECT username FROM users WHERE id=#{session[:user_id]};").first["username"]
    end

    erb :root, :locals => {:username => @username}, :layout => :main_layout
  end

  get "/register/" do
    erb :register, :layout => :main_layout
  end

  post "/register/" do
    @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{params[:username]}', '#{params[:password]}')")
    flash[:register_notice] = "Thank you for registering"
    redirect "/"
  end

  post "/login/" do
    user_hashes_arr = @database_connection.sql("select * from users;")
    user_hash = user_hashes_arr.detect do |hash|
      params[:username] == hash["username"] && params[:password] == hash["password"]
    end

    if user_hash
      session[:user_id] = user_hash["id"]
    end

    redirect "/"
  end

  get "/logout/" do
    session[:user_id] = nil
    redirect "/"
  end

end