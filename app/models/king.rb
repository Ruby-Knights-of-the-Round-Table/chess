class King < Piece
    def color
        if Game.find(self.game_id).white_player_id === self.player_id then return "&#9812;" else return "&#9818;" end
    end
end
