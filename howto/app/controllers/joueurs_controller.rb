class JoueursController < ApplicationController
  def index
   # @joueurs = Joueur.all
    @joueurs = Joueurs.find_by_sql (["SELECT joueurs. * , count( stats.id_joueur ) , avg( stats.note ) , (
									SELECT stats.note AS lastnote
									FROM stats
									WHERE stats.id_joueur =230
									ORDER BY id DESC
									LIMIT 1
									) AS lastnote
									FROM joueurs, stats
									WHERE joueurs.id = stats.id_joueur
									AND joueurs.id =?",params[:id]])

    @classement = Classement.find_by_sql(["SELECT equipes.nom as equipe, equipes.id as equipeID, points, victoire,defaite,nul,bp,bc,
										nb_journee,  divisions.nom,divisions.id as divID 
										 FROM equipes, historiques, saisons, classements, divisions
										WHERE historiques.id = classements.historique_id 
										AND historiques.saison_id = saisons.id
										AND equipes.id = historiques.equipe_id
										AND saisons.division_id = divisions.id
										AND saisons.division_id = (SELECT saisons.division_id FROM equipes, historiques, saisons
										WHERE historiques.saison_id = saisons.id
										AND historiques.equipe_id = equipes.id
										AND equipes.id = ?)  ORDER BY points DESC,(bp-bc) DESC",  current_team])
  if not current_user
	@user_session = UserSession.new
  end
  end

  def show
     @joueur = Joueur.find(params[:id], :include => [:contrats,:equipes])
	 @equipe = Equipe.find_by_sql(["SELECT equipes.id 
										FROM equipes, historiques, saisons, contrats, joueurs
										WHERE historiques.saison_id = saisons.id
										AND historiques.equipe_id = equipes.id
										AND equipes.id = contrats.equipe_id
										AND joueurs.id = contrats.joueur_id
										AND joueurs.id = ?",  params[:id]])
									
	@stats = Joueur.find_by_sql(["SELECT `ballon+` AS bp, `ballon-` AS bm, `passe+` AS pp, `passe-` AS pm, `drible+` AS dp, `drible-` AS dm, `tackle+` AS tcp, `tackle-` AS tcm, `tir+` AS trp, `tir-` AS trm, but, id_joueur, note, matchs.num_journee
									FROM  stats, matchs,feuilles_de_matchs
									WHERE  stats.id_joueur = ?
									AND ( stats.id = feuilles_de_matchs.stats_j1_id
										  OR stats.id = feuilles_de_matchs.stats_j2_id
										  OR stats.id = feuilles_de_matchs.stats_j3_id
										  OR stats.id = feuilles_de_matchs.stats_j4_id
										  OR stats.id = feuilles_de_matchs.stats_j5_id
										  OR stats.id = feuilles_de_matchs.stats_j6_id
										  OR stats.id = feuilles_de_matchs.stats_j7_id
										  OR stats.id = feuilles_de_matchs.stats_j8_id
										  OR stats.id = feuilles_de_matchs.stats_j9_id
										  OR stats.id = feuilles_de_matchs.stats_j10_id
										  OR stats.id = feuilles_de_matchs.stats_j11_id)
									  AND ( feuilles_de_matchs.id =matchs.fdm_equipe1 
										OR feuilles_de_matchs.id =matchs.fdm_equipe2)" ,params[:id]])
	
	@pos = Joueur.find_by_sql(["SELECT x,y, matchs.num_journee
								FROM positions, tactiques, matchs
								WHERE id_joueur = ? 
								AND (positions.id = tactiques.position_j1_id
								  OR positions.id = tactiques.position_j2_id
								  OR positions.id = tactiques.position_j3_id
								  OR positions.id = tactiques.position_j4_id
								  OR positions.id = tactiques.position_j5_id
								  OR positions.id = tactiques.position_j6_id
								  OR positions.id = tactiques.position_j7_id
								  OR positions.id = tactiques.position_j8_id
								  OR positions.id = tactiques.position_j9_id
								  OR positions.id = tactiques.position_j10_id
								  OR positions.id = tactiques.position_j11_id)
								AND ( tactiques.id =matchs.tactique_equipe1 
									  OR tactiques.id =matchs.tactique_equipe2)", params[:id]])
									  
    @couleur= Club.find_by_sql(["SELECT clubs.couleur1 as couleur1, clubs.couleur2 as couleur2 
								FROM equipes, clubs
								WHERE equipes.club_id = clubs.id
								AND equipes.id = ?", @equipe[0].id])
	

  if not current_user
	@user_session = UserSession.new
  end
  end
end
