class Pawn < Piece
    def color
        if Game.find(self.game_id).white_player_id === self.player_id then return "&#9817;" else return "&#9823;" end
    end
end
