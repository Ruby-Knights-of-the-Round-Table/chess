class GamesController < ApplicationController
    before_action :authenticate_player!
    # if_check? ( be in kings model? ) (completed!)
    #    iterate over each of the enemy pieces and see if their moves possible shares the kings space
    #    maybe return the pices that do this
    # prevent_check_moves ( TODO )
    #    from the possible moves, see if this move can undo the check
    #    if if_check? is null, then end this program
    #
    # if_checkmate
    #    changes database value of 'winner_id' if there is a checkmate, or if none of current_player pieces can undo check.
    def index
        @games = Game.where(white_player_id: current_player.id) + Game.where(black_player_id: current_player.id)
        @all_games = Game.all
    end

    def new
        @game = Game.new
    end

    def show
        @game = Game.find(params[:id])
        @board = @game.pieces_as_array
    end

    def create
        @game = Game.create(game_params)
        @game.white_player_id = current_player.id
        @game.save
        @game.place_pieces_in_database(current_player.id, nil)

        set_firebase(gameID: @game.id,
                    gameName: @game.game_name)

        redirect_to( game_path(@game) )
    end

    def destroy
        @game = Game.find(params[:id])
        @game.destroy

        # delete_firebase(gameId: @game.id,
        #                 first_player_email: @game.white_player.email)

        redirect_to(games_path)
    end

    def join
        @game = Game.find(params[:id])
        if @game.white_player_id != nil && current_player.id != @game.white_player_id
          @game.black_player_id = current_player.id
          @game.turn = @game.white_player_id
          @game.save
          @game.pieces.where(player_id: nil).update_all(player_id: current_player.id)

          update_firebase(first_player_email: @game.white_player.email)

          redirect_to(game_path(@game))
        end
    end


    private

    def game_params
      params.require(:game).permit(:game_name, :white_player_id, :black_player_id, :winner_id, :turn  )
    end

    def set_firebase(data)
      base_uri = 'https://ruby-knights.firebaseio.com'
      firebase = Firebase::Client.new(base_uri)
      response = firebase.set("game#{@game.id}", data)
    end

    # def delete_firebase(data)
    #   base_uri = 'https://ruby-knights.firebaseio.com'
    #   firebase = Firebase::Client.new(base_uri)
    #   response = firebase.remove("game#{@game.id}", data)
    # end

    def update_firebase(data)
      base_uri = 'https://ruby-knights.firebaseio.com'
      firebase = Firebase::Client.new(base_uri)
      response = firebase.update("game#{@game.id}", data)
    end

end
