class EquipesController < ApplicationController
  def index
    @equipes = Equipe.all
  end

  def show
    	#TODO rajouter le filtre pour trouver les joueurs dont la date de in de contrat < date courante
    @joueurs = Joueur.find(:all, :include => [:equipes => :contrats], 
                    		 :conditions => ["equipes.id = ?", params[:id]])

  end
end
