class MonEquipeController < ApplicationController
  def index
 #   @mon_equipes = MonEquipe.all
    @joueurs = Joueur.find(:all, :include => [:equipes => :contrats], 
                    		 :conditions => ["equipes.id = ?", current_user.equipe_id])
     @div= Saison.find_by_sql(["SELECT saisons.division_id FROM equipes, historiques, saisons
										WHERE historiques.saison_id = saisons.id
										AND historiques.equipe_id = equipes.id
										AND equipes.id = ?",1])
	#rajouter un ORDER BY									
    @classement = Classement.find_by_sql(["SELECT equipes.nom as equipe, points, victoire,defaite,nul,bp,bc, divisions.nom  FROM equipes, historiques, saisons, classements, divisions
										WHERE historiques.id = classements.historique_id 
										AND historiques.saison_id = saisons.id
										AND equipes.id = historiques.equipe_id
										AND saisons.division_id = divisions.id
										AND saisons.division_id = (SELECT saisons.division_id FROM equipes, historiques, saisons
										WHERE historiques.saison_id = saisons.id
										AND historiques.equipe_id = equipes.id
										AND equipes.id = ?)",  current_user.equipe_id])
	
  render 'equipes/show', :joueurs=>@joueurs
  end

end
