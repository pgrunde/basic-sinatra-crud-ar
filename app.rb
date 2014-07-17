require "sinatra"
require "rack-flash"
require "gschool_database_connection"
require_relative "./lib/fishly"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @db = Fishly.new
  end

  get "/" do
    if session[:user_id]
      username = @db.get_user(session[:user_id])

      users = @db.get_users(session[:user_id])

      fav_fish_arr = @db.fav_fish_arr(session[:user_id])

      fish_arr = @db.fish_arr(session[:user_id])

      if params[:sort] == "asc"
        users.sort_by! {|user| user["username"]}
      elsif params[:sort] == "desc"
        users.sort_by! {|user| user["username"]}.reverse!
      end
      if session[:clicked_user_id]
        click_user_fish = @db.fish_arr(session[:clicked_user_id])
      else
        click_user_fish = []
      end

      erb :logged_in, :locals => {:username => username,
                                  :user_arr => users,
                                  :fish_arr => fish_arr,
                                  :click_user_fish => click_user_fish,
                                  :fav_fish_arr => fav_fish_arr}, :layout => :main_layout
    else
      erb :logged_out, :layout => :main_layout
    end
  end

  get "/fish/" do
    erb :create_fish, :layout => :main_layout
  end

  get "/register/" do
    erb :register, :layout => :main_layout
  end

  delete "/delete/:username" do
    @db.user_delete(params[:username])
    redirect "/"
  end

  post "/fish/" do
    unless session[:user_id]
      redirect "/"
    end

    if params[:name] == "" && params[:wiki] == ""
      flash[:notice] = "Please enter a name and wikipedia page."
      redirect "/fish/"
    elsif params[:name] == ""
      flash[:notice] = "Please enter a name."
      redirect "/fish/"
    elsif params[:wiki] == ""
      flash[:notice] = "Please enter a wikipedia page."
      redirect "/fish/"
    end

    @db.insert_fish(session[:user_id], params[:name], params[:wiki])
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
    elsif @db.reg_check(params[:username])
      flash[:login_fail] = "That name is taken."
      redirect "/register/"
    else
      @db.insert_user(params[:username], params[:password])
      flash[:register_notice] = "Thank you for registering"
      redirect "/"
    end
  end

  post "/login/" do
    user_hashes_arr = @db.get_all_users
    user_hash = user_hashes_arr.detect do |hash|
      params[:username] == hash["username"] && params[:password] == hash["password"]
    end

    if user_hash
      session[:user_id] = user_hash["id"]
      session[:clicked_user_id] = nil
    end

    redirect "/"
  end

  get "/favorites/:id" do
    @db.insert_favorites(session[:user_id], params[:id])
    redirect "/"
  end

  get "/unfavorite/:id" do
    @db.delete_favorites(params[:id])
    redirect "/"
  end

  get "/logout/" do
    session[:user_id] = nil
    redirect "/"
  end

  get "/:click_id" do
    session[:clicked_user_id] = params[:click_id]
    redirect "/"
  end

end
