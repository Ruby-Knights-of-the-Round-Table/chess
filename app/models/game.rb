class Game < ActiveRecord::Base
  belongs_to :player
  has_many :pieces
  def place_pieces_in_database(player1,player2)

    #white backrow pieces
    Piece.create(game_id: self.id, player_id: player1, x_position: 0, y_position: 0, type: "Rook")
    Piece.create(game_id: self.id, player_id: player1, x_position: 1, y_position: 0, type: "Knight")
    Piece.create(game_id: self.id, player_id: player1, x_position: 2, y_position: 0, type: "Bishop")
    Piece.create(game_id: self.id, player_id: player1, x_position: 3, y_position: 0, type: "Queen")
    Piece.create(game_id: self.id, player_id: player1, x_position: 4, y_position: 0, type: "King")
    Piece.create(game_id: self.id, player_id: player1, x_position: 5, y_position: 0, type: "Bishop")
    Piece.create(game_id: self.id, player_id: player1, x_position: 6, y_position: 0, type: "Knight")
    Piece.create(game_id: self.id, player_id: player1, x_position: 7, y_position: 0, type: "Rook")

    #black backrow pieces
    Piece.create(game_id: self.id, player_id: player2, x_position: 0, y_position: 7, type: "Rook")
    Piece.create(game_id: self.id, player_id: player2, x_position: 1, y_position: 7, type: "Knight")
    Piece.create(game_id: self.id, player_id: player2, x_position: 2, y_position: 7, type: "Bishop")
    Piece.create(game_id: self.id, player_id: player2, x_position: 3, y_position: 7, type: "Queen")
    Piece.create(game_id: self.id, player_id: player2, x_position: 4, y_position: 7, type: "King")
    Piece.create(game_id: self.id, player_id: player2, x_position: 5, y_position: 7, type: "Bishop")
    Piece.create(game_id: self.id, player_id: player2, x_position: 6, y_position: 7, type: "Knight")
    Piece.create(game_id: self.id, player_id: player2, x_position: 7, y_position: 7, type: "Rook")

    [1,6].each do |col|
        8.times do |row|
            if col < 4
                #white pawns
                Piece.create(game_id: self.id, player_id: player1, x_position: row, y_position: col, type: "Pawn")
            else
                #black pawns
                Piece.create(game_id: self.id, player_id: player2, x_position: row, y_position: col, type: "Pawn")
            end


        end
    end

  end
end
