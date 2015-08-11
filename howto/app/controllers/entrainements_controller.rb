class EntrainementsController < ApplicationController
  def show
	@login = Equipe.find_by_sql(["SELECT users.login as login, users.email as email FROM users
								 WHERE users.equipe_id = ?",current_team]);
    #@joueurs = Joueur.find(:all, :include => [:equipes => :contrats], 
	#					:conditions => ["equipes.id = ?", current_team], :order=>"numero")
	@club = Club.find(params[:id],:include => [ :equipe])
	   @joueurs = Joueur.find_by_sql (["SELECT joueurs. * , count( stats.id_joueur ) AS nbmatch, avg( stats.note ) AS avgnote, (
										SELECT stats.note AS lastnote
										FROM stats, joueurs
										WHERE stats.id_joueur = joueurs.id
										ORDER BY stats.id DESC
										LIMIT 1
										) AS lastnote
										FROM joueurs
										LEFT OUTER JOIN stats ON joueurs.id = stats.id_joueur, equipes, contrats
										WHERE equipes.id = ?
										AND equipes.id = contrats.equipe_id
										AND contrats.joueur_id = joueurs.id
										GROUP BY joueurs.id
										ORDER BY joueurs.numero",current_team])	
	
	
	@classement = Classement.find_by_sql(["SELECT equipes.nom as equipe, equipes.id as equipeID, points, victoire,defaite,nul,bp,bc, nb_journee, divisions.nom, divisions.id as divID  
										FROM equipes, historiques, saisons, classements, divisions
										WHERE historiques.id = classements.historique_id 
										AND historiques.saison_id = saisons.id
										AND equipes.id = historiques.equipe_id
										AND saisons.division_id = divisions.id
										AND saisons.division_id = (SELECT saisons.division_id FROM equipes, historiques, saisons
										WHERE historiques.saison_id = saisons.id
										AND historiques.equipe_id = equipes.id
										AND equipes.id = ? ) ORDER BY points DESC,(bp-bc) DESC",  current_team])
	@agenda = Saison.find_by_sql(["SELECT equipe1.nom AS equipe1Nom, equipe2.nom equipe2Nom, matchs.score1, matchs.score2,
									matchs.num_journee,matchs.id, matchs.equipe1_id as equipe1ID , matchs.equipe2_id  as equipe2ID
									FROM equipes AS equipe1, equipes AS equipe2, matchs, saisons, annees
									WHERE matchs.saison_id = saisons.id
									AND matchs.num_journee = annees.journee
									AND equipe2.id = matchs.equipe2_id
									AND equipe1.id = matchs.equipe1_id
									AND saisons.division_id = (
									SELECT saisons.division_id
									FROM equipes, historiques, saisons
									WHERE historiques.saison_id = saisons.id
									AND historiques.equipe_id = equipes.id
									AND equipes.id =?)",  current_team])

	@calendrier = Saison.find_by_sql(["SELECT equipe1.nom AS equipe1Nom, matchs.score1, matchs.score2, equipe2.nom  AS equipe2Nom, 
									matchs.num_journee,matchs.id,  equipe1.id as equipe1ID , equipe2.id  as equipe2ID  
									FROM equipes AS equipe1, equipes AS equipe2, matchs, saisons
									WHERE matchs.saison_id = saisons.id
									AND equipe2.id = matchs.equipe2_id
									AND equipe1.id = matchs.equipe1_id
									AND (equipe1.id = ?
									OR	equipe2.id = ?)
									AND saisons.division_id = (
									SELECT saisons.division_id
									FROM equipes, historiques, saisons
									WHERE historiques.saison_id = saisons.id
									AND historiques.equipe_id = equipes.id
									AND equipes.id =?)",  current_team ,  current_team,  current_team])


  
  
  
  	
  if not current_user
	@user_session = UserSession.new
  end

  end

def valider

redirect_to '/'
end


end
