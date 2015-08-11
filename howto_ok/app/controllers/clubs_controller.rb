class ClubsController < ApplicationController
  def show
    @club = Club.find(params[:id])
  end

  def index
    @clubs = Club.all
  end
end
