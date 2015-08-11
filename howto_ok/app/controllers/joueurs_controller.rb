class JoueursController < ApplicationController
  def index
    @joueurs = Joueur.all
  end

  def show
     @joueur = Joueur.find(params[:id], :include => [:contrats, :equipes])
  end
end
