class Knight < Piece
    def color
        if Game.find(self.game_id).white_player_id === self.player_id then return "&#9816;" else return "&#9822;" end
    end

    
end
