class New < ActiveRecord::Migration
  def up
    def up
      create_table :users do |t|
        t.string :username
        t.string :password
      end


      create_table :fish do |t|
        t.string :users_id
        t.string :name
        t.string :wiki
      end

      create_table :favorites do |t|
        t.integer :users_id
        t.integer :fish_id
      end
    end

    def down
      drop_table :users
      drop_table :fish
      drop_table :favorites
    end
  end

end
