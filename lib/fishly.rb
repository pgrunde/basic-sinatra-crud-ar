require "gschool_database_connection"

class Fishly
  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  # USER METHODS

  def get_user(id)
    @database_connection.sql("SELECT username FROM users WHERE id=#{id}").first["username"]
  end

  def reg_check(name)
    @database_connection.sql("SELECT username FROM users WHERE username='#{name}'") != []
  end

  def get_users(id)
    @database_connection.sql("SELECT * FROM users WHERE id <> #{id}")
  end

  def get_all_users
    @database_connection.sql("select * from users")
  end

  def insert_user(username,password)
    @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{username}', '#{password}')")
  end

  def user_delete(username)
    @database_connection.sql("DELETE FROM users WHERE username = '#{username}'")
  end

  # FISH METHODS

  def fav_fish_arr(id)
    @database_connection.sql(
      "SELECT fish.name as fish_name FROM favorites " +
        "INNER JOIN users on users.id = favorites.users_id " +
        "INNER JOIN fish on fish.id = favorites.fish_id " +
        "WHERE users.id = #{id}"
    ).uniq
  end

  def search_fish(name)
    @database_connection.sql("select * from fish where name LIKE '%#{name}%'")
  end

  def fish_arr(id)
    @database_connection.sql("SELECT * FROM fish WHERE users_id = '#{id}'")
  end

  def insert_fish(users_id, name, wiki)
    @database_connection.sql("INSERT INTO fish (users_id, name, wiki) VALUES (#{users_id},'#{name}','#{wiki}')")
  end

  def delete_fish(id)
    @database_connection.sql("DELETE FROM fish WHERE id = '#{id}'")
  end

  # FAVORITES METHODS

  def insert_favorites(users_id,fish_id)
    @database_connection.sql("INSERT INTO favorites (users_id, fish_id) VALUES ('#{users_id}','#{fish_id}')")
  end

  def delete_favorites(users_id,fish_id)
    @database_connection.sql("DELETE FROM favorites WHERE fish_id = '#{fish_id}' and users_id = '#{users_id}'")
  end

end