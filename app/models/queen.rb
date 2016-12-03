class Queen < Piece
    def color
        if Game.find(self.game_id).white_player_id === self.player_id then return "&#9813;" else return "&#9819;" end
    end
end
