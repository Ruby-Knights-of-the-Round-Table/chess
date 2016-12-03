class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|
      t.integer :game_id
      t.integer :player_id

      t.string :type

      t.integer :x_position
      t.integer :y_position

      t.boolean :selected, default: false
      t.boolean :captured_piece, default: false

      t.timestamps
    end
  end
end
