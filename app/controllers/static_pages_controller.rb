class StaticPagesController < ApplicationController
  # Below is for testing before_action for player
  before_action :authenticate_player!
end
