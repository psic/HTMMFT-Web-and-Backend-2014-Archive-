class StatsController < ApplicationController

  def show

   
	@statsE1 = Joueur.find_by_sql(["SELECT `ballon+` as bp, `ballon-` as bm, `passe+` as pp, `passe-` as pm, `drible+` as dp, `drible-` as dm, 
									`tackle+` as tcp, `tackle-` as tcm, `tir+` as trp, `tir-` as trm,but,  joueurs.numero as num,
									 joueurs.nom as nom, joueurs.prenom as prenom 
								  FROM joueurs, stats, feuilles_de_matchs, matchs
								  WHERE matchs.fdm_equipe1 = feuilles_de_matchs.id
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
								  AND joueurs.id = stats.id_joueur
								  AND matchs.id = ? ORDER BY num" ,params[:id]])
	
	
	@statsE2 = Joueur.find_by_sql(["SELECT `ballon+` as bp, `ballon-` as bm, `passe+` as pp, `passe-` as pm, `drible+` as dp, `drible-` as dm, 
									`tackle+` as tcp, `tackle-` as tcm, `tir+` as trp, `tir-` as trm,but,  joueurs.numero as num,
									 joueurs.nom as nom, joueurs.prenom as prenom 
								  FROM joueurs, stats, feuilles_de_matchs, matchs
								  WHERE matchs.fdm_equipe2 = feuilles_de_matchs.id
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
								  AND joueurs.id = stats.id_joueur
								  AND matchs.id = ? ORDER BY num" ,params[:id]])
		
	@E1 = Classement.find_by_sql(["SELECT equipes.nom as equipe, matchs.equipe1_id as equipeID, matchs.score1 as score
							FROM equipes, matchs
							WHERE matchs.equipe1_id = equipes.id
							 AND matchs.id = ?",params[:id]]) 
	
	@E2 = Classement.find_by_sql(["SELECT equipes.nom as equipe, matchs.equipe2_id as equipeID, matchs.score2 as score
							FROM equipes, matchs
							WHERE matchs.equipe2_id = equipes.id
							 AND matchs.id = ?",params[:id]])
								
	@couleur1 = Club.find_by_sql(["SELECT clubs.couleur1 as couleur1, clubs.couleur2 as couleur2 
								FROM equipes, clubs, matchs
								WHERE equipes.club_id = clubs.id
								AND equipes.id = matchs.equipe1_id
								AND matchs.id = ?", params[:id]])
	
	@couleur2 = Club.find_by_sql(["SELECT clubs.couleur1 as couleur1, clubs.couleur2 as couleur2 
								FROM equipes, clubs, matchs
								WHERE equipes.club_id = clubs.id
								AND equipes.id = matchs.equipe2_id
								AND matchs.id = ?", params[:id]])
								
	@div = Club.find_by_sql(["SELECT divisions.nom , divisions.id
								FROM equipes, clubs, matchs, divisions, historiques, saisons
								WHERE historiques.equipe_id = matchs.equipe1_id
								AND historiques.saison_id = saisons.id
								AND saisons.division_id = divisions.id
								AND matchs.id = ?", params[:id]])
								
								

  
  # On cherche l'id de la tactique de l'equipe1
	@fdm1 = Saison.find_by_sql(["SELECT tactique_equipe1
									FROM matchs
									WHERE id = ?", params[:id]])
	tact1_id = @fdm1[0].tactique_equipe1

# S'il y a deja une tactique, on a la charge
@tact1=[]
@remp1=[]
if tact1_id != nil
	(1..11).each do |i|
	 @tact1[i] = Saison.find_by_sql(["SELECT positions.x as posx, id_joueur, numero,positions.y as posy FROM tactiques, positions, joueurs
								WHERE tactiques.position_j#{i}_id = positions.id
								AND positions.id_joueur = joueurs.id
								AND tactiques.id = ?",tact1_id ])
	end
	(1..5).each do |i|
	 @remp1[i] = Saison.find_by_sql(["SELECT remplacant#{i}_id as idRemp, numero FROM tactiques, joueurs
								WHERE remplacant#{i}_id = joueurs.id
								AND tactiques.id = ?",tact1_id ])
	end
end

# On cherche l'id de la tactique de l'equipe2
	@fdm2 = Saison.find_by_sql(["SELECT tactique_equipe2
									FROM matchs
									WHERE id = ?", params[:id]])
	tact2_id = @fdm2[0].tactique_equipe2

# S'il y a deja une tactique, on a la charge
@tact2=[]
@remp2=[]
if tact2_id != nil
	(1..11).each do |i|
	 @tact2[i] = Saison.find_by_sql(["SELECT positions.x as posx, id_joueur, numero,positions.y as posy FROM tactiques, positions, joueurs
								WHERE tactiques.position_j#{i}_id = positions.id
								AND positions.id_joueur = joueurs.id
								AND tactiques.id = ?",tact2_id ])
	end
	(1..5).each do |i|
	 @remp2[i] = Saison.find_by_sql(["SELECT remplacant#{i}_id as idRemp, numero FROM tactiques, joueurs
								WHERE remplacant#{i}_id = joueurs.id
								AND tactiques.id = ?",tact2_id ])
	end
end
  
  
  
  	
  if not current_user
	@user_session = UserSession.new
  end

  
  end



end
