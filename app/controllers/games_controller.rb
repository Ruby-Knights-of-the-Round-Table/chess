class GamesController < ApplicationController
    before_action :authenticate_player!

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
                    gameName: @game.game_name,
                    available: true,
                    gameCreatedAt: Time.now.to_s)

        redirect_to(game_path(@game))
    end

    def destroy
        @game = Game.find(params[:id])
        @game.destroy

        set_firebase(deletedGame: true,
                     gameID: @game.id)

        redirect_to(games_path)
    end

    def join
        @game = Game.find(params[:id])
        if @game.white_player_id != nil && current_player.id != @game.white_player_id
          @game.black_player_id = current_player.id
          @game.turn = @game.white_player_id
          @game.save
          @game.pieces.where(player_id: nil).update_all(player_id: current_player.id)

          update_firebase(first_player_email: @game.white_player.email,
                          available: false)

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

    def update_firebase(data)
      base_uri = 'https://ruby-knights.firebaseio.com'
      firebase = Firebase::Client.new(base_uri)
      response = firebase.update("game#{@game.id}", data)
    end

end
