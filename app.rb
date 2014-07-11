require "sinatra"
require "active_record"
require "./lib/database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    if session[:user_id]
      @username = @database_connection.sql("SELECT username FROM users WHERE id=#{session[:user_id]};").first["username"]
      @user_arr = @database_connection.sql("SELECT username FROM users;").map {|hash| hash["username"] if hash["username"] != @username}
      @user_arr.delete(nil)

      @fish_arr = @database_connection.sql("SELECT name, wiki FROM fish;")
    end
    if params[:sort] == "asc"
      @user_arr.sort!
    elsif params[:sort] == "desc"
      @user_arr.sort! { |x,y| y <=> x }
    end

    erb :root, :locals => {:username => @username, :user_arr => @user_arr, :fish_arr => @fish_arr}, :layout => :main_layout
  end

  get "/register/" do
    erb :register, :layout => :main_layout
  end

  post "/delete/" do
    @username = @database_connection.sql("SELECT username FROM users WHERE id=#{session[:user_id]};").first["username"]
    @user_arr = @database_connection.sql("SELECT username FROM users;").map {|hash| hash["username"] if hash["username"] != @username}
    @user_arr.delete(nil)
    to_delete = params[:delete]
    if to_delete == @username
      redirect "/"
    else
      begin
        @database_connection.sql("DELETE FROM users WHERE username = '#{to_delete}'")
        redirect "/"
      rescue
        redirect "/"
      end
    end
  end

  post "/fish/" do
    @database_connection.sql("INSERT INTO fish (users_id, name, wiki) VALUES (#{session[:user_id]},'#{params[:name]}','#{params[:wiki]}')")
    redirect "/"
  end

  post "/register/" do
    if params[:password] == "" && params[:username] == ""
      flash[:login_fail] = "Please enter a username and password."
      redirect "/register/"
    elsif params[:password] == ""
      flash[:login_fail] = "Please enter a password."
      redirect "/register/"
    elsif params[:username] == ""
      flash[:login_fail] = "Please enter a username."
      redirect "/register/"
    end

    begin
      @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{params[:username]}', '#{params[:password]}')")
      flash[:register_notice] = "Thank you for registering"
      redirect "/"
    rescue
      flash[:login_fail] = "That name is taken."
      redirect "/register/"
    end
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
