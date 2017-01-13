class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.integer :piece_id
      t.integer :turn
      t.integer :x
      t.integer :y

      t.timestamps
    end
  end
end
