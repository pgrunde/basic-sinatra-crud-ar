class Fuck < ActiveRecord::Migration
  def up
    def up
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
