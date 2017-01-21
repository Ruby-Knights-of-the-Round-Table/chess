class Game < ActiveRecord::Base

  def change_turn
    if turn == white_player_id
      self.turn = black_player_id
    else
      self.turn = white_player_id
    end
      save
  end

  belongs_to :white_player, class_name: 'Player', foreign_key: 'white_player_id'
  belongs_to :black_player, class_name: 'Player', foreign_key: 'black_player_id'

  has_many :pieces

  scope :available, -> { where(black_player_id: nil) }

  def place_pieces_in_database(white_player, black_player)

    #white backrow pieces
    piece = Rook.create(game_id: id, player_id: white_player_id, x_position: 0, y_position: 0)
    Move.create(piece_id: piece.id, x: 0, y: 0, turn: 0 )
    piece = Rook.create(game_id: id, player_id: white_player_id, x_position: 7, y_position: 0)
    Move.create(piece_id: piece.id, x: 7, y: 0, turn: 0 )

    piece = Knight.create(game_id: id, player_id: white_player_id, x_position: 1, y_position: 0)
    Move.create(piece_id: piece.id, x: 1, y: 0, turn: 0 )
    piece = Knight.create(game_id: id, player_id: white_player_id, x_position: 6, y_position: 0)
    Move.create(piece_id: piece.id, x: 6, y: 0, turn: 0 )

    piece = Bishop.create(game_id: id, player_id: white_player_id, x_position: 2, y_position: 0)
    Move.create(piece_id: piece.id, x: 2, y: 0, turn: 0 )
    piece = Bishop.create(game_id: id, player_id: white_player_id, x_position: 5, y_position: 0)
    Move.create(piece_id: piece.id, x: 5, y: 0, turn: 0 )

    piece = Queen.create(game_id: id, player_id: white_player_id, x_position: 3, y_position: 0)
    Move.create(piece_id: piece.id, x: 3, y: 0, turn: 0 )
    piece = King.create(game_id: id, player_id: white_player_id, x_position: 4, y_position: 0)
    Move.create(piece_id: piece.id, x: 4, y: 0, turn: 0 )

    #black backrow pieces
    piece = Rook.create(game_id: id, player_id: black_player_id, x_position: 0, y_position: 7)
    Move.create(piece_id: piece.id, x: 0, y: 7, turn: 0 )
    piece = Rook.create(game_id: id, player_id: black_player_id, x_position: 7, y_position: 7)
    Move.create(piece_id: piece.id, x: 7, y: 7, turn: 0 )

    piece = Knight.create(game_id: id, player_id: black_player_id, x_position: 1, y_position: 7)
    Move.create(piece_id: piece.id, x: 1, y: 7, turn: 0 )
    piece = Knight.create(game_id: id, player_id: black_player_id, x_position: 6, y_position: 7)
    Move.create(piece_id: piece.id, x: 6, y: 7, turn: 0 )

    piece = Bishop.create(game_id: id, player_id: black_player_id, x_position: 2, y_position: 7)
    Move.create(piece_id: piece.id, x: 2, y: 7, turn: 0 )
    piece = Bishop.create(game_id: id, player_id: black_player_id, x_position: 5, y_position: 7)
    Move.create(piece_id: piece.id, x: 5, y: 7, turn: 0 )

    piece = Queen.create(game_id: id, player_id: black_player_id, x_position: 3, y_position: 7)
    Move.create(piece_id: piece.id, x: 3, y: 7, turn: 0 )
    piece = King.create(game_id: id, player_id: black_player_id, x_position: 4, y_position: 7)
    Move.create(piece_id: piece.id, x: 4, y: 7, turn: 0 )

    #white pawns
    (0..7).each do |i|
      piece = Pawn.create(game_id: id, player_id: white_player_id, x_position: i, y_position: 1)
      Move.create(piece_id: piece.id, x: i, y: 1, turn: 0 )
    end

    #black pawns
    (0..7).each do |i|
      piece = Pawn.create(game_id: id, player_id: black_player_id, x_position: i, y_position: 6)
      Move.create(piece_id: piece.id, x: i, y: 6, turn: 0 )
    end
  end

  def moves
    # q = "select p.email, c.type, m.turn from players p, pieces c, moves m  where m.piece_id = c.id and c.player_id = p.id"
    # r = ActiveRecord::Base.connection.execute(q)
    # r.values
    query = "SELECT pieces.type, moves.turn, pieces.game_id, moves.y, moves.x FROM players, pieces, moves WHERE moves.piece_id = pieces.id AND pieces.player_id = players.id AND pieces.game_id = #{self.id} AND moves.x = moves.x AND moves.y = moves.y"
    results = ActiveRecord::Base.connection.execute(query)
    results.values  # [["Rook", "0"], ["phagmann1@gmail.com", "Rook", "0"],... [ [ type, turn#, y, x, piece_id]]

  end

  #down the road, we will need a mcuh faster way to easily access piece data thats not through the database
  def pieces_as_array
    pieces = self.pieces.where(captured_piece: false)
    piece_array = [
                    [0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0]
                  ]
    pieces.each do |piece|
      if piece.game.white_player_id == piece.player_id then color = piece.game.white_player_id  else color = piece.game.black_player_id  end
      piece_array[piece.y_position][piece.x_position] = color
    end
    return piece_array
  end

  def occupied_space?(y, x)
    pieces = self.pieces
    pieces.onboard.where(y_position: y, x_position: x).any?
  end

end
