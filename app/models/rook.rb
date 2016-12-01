class Rook < Piece
    def color
        if Game.find(self.game_id).white_player_id === self.player_id then return "&#9814;" else return "&#9820;" end
    end
end
