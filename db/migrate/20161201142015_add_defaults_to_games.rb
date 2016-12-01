class AddDefaultsToGames < ActiveRecord::Migration
  def change
    remove_column :games, :winner_id, :integer
    remove_column :games, :turn, :string

    add_column :games, :winner_id, :integer, default: 0
    add_column :games, :turn, :integer, default: 0

  end
end
