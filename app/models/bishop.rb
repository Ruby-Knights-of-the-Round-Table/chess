class Bishop < Piece
    def color
        if Game.find(self.game_id).white_player_id === self.player_id then return "&#9815;" else return "&#9821;" end
    end
end
