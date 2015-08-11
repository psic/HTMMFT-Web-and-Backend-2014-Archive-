class MonEquipeController < ApplicationController
  def index
	@login = Equipe.find_by_sql(["SELECT users.login as login, users.email as email FROM users
								 WHERE users.equipe_id = ?",current_team]);
    #@joueurs = Joueur.find(:all, :include => [:equipes => :contrats], 
	#					:conditions => ["equipes.id = ?", current_team], :order=>"numero")
	
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
	
	@couleur = Club.find_by_sql(["SELECT clubs.couleur1 as couleur1, clubs.couleur2 as couleur2 FROM equipes, clubs
								WHERE equipes.club_id = clubs.id
								AND equipes.id = ?", current_team])
								
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


  
  # On cherche l'id de la tactique de l'equipe
@match = Saison.find_by_sql(["SELECT matchs.id, matchs.equipe1_id, matchs.equipe2_id
									FROM matchs, annees
									WHERE num_journee = annees.journee
									AND (equipe1_id =? OR equipe2_id =?)",  current_team, current_team])

if @match[0].equipe1_id == current_team
	@fdm = Saison.find_by_sql(["SELECT tactique_equipe1
									FROM matchs
									WHERE id = ?", @match[0].id])
	tact_id = @fdm[0].tactique_equipe1
else
	@fdm= Saison.find_by_sql(["SELECT tactique_equipe2
									FROM matchs
									WHERE id = ?", @match[0].id])
	tact_id = @fdm[0].tactique_equipe2
end

# S'il y a deja une tactique, on a la charge
@tact=[]
@remp=[]
if tact_id != nil
	(1..11).each do |i|
	 @tact[i] = Saison.find_by_sql(["SELECT positions.x as posx, id_joueur, numero,positions.y as posy FROM tactiques, positions, joueurs
								WHERE tactiques.position_j#{i}_id = positions.id
								AND positions.id_joueur = joueurs.id
								AND tactiques.id = ?",tact_id ])
	end
	(1..5).each do |i|
	 @remp[i] = Saison.find_by_sql(["SELECT remplacant#{i}_id as idRemp, numero FROM tactiques, joueurs
								WHERE remplacant#{i}_id = joueurs.id
								AND tactiques.id = ?",tact_id ])
	end
end
  
  	
  if not current_user
	@user_session = UserSession.new
  end
  render 'equipes/show', :joueurs=>@joueurs
  end

def valider
tact = []
remp = []
trouve = false
req_debut = "INSERT INTO tactiques ("
req_fin = "VALUES ("

# On cherche l'id de la tactique de l'equipe
@match = Saison.find_by_sql(["SELECT matchs.id, matchs.equipe1_id, matchs.equipe2_id
									FROM matchs, annees
									WHERE num_journee = annees.journee
									AND (equipe1_id =? OR equipe2_id =?)",  current_team, current_team])

if @match[0].equipe1_id == current_team
	@fdm = Saison.find_by_sql(["SELECT tactique_equipe1
									FROM matchs
									WHERE id = ?", @match[0].id])
	tact_id = @fdm[0].tactique_equipe1
else
	@fdm= Saison.find_by_sql(["SELECT tactique_equipe2
									FROM matchs
									WHERE id = ?", @match[0].id])
	tact_id = @fdm[0].tactique_equipe2
end

# S'il y a deja une tactique, on la supprime

if tact_id != nil
	 logger.debug " *** Suppression tactique ***"
	(1..11).each do |i|
	 tact = Saison.find_by_sql(["SELECT position_j#{i}_id as position FROM tactiques
								WHERE id = ?",tact_id ])
		unless tact.empty?
			if tact[0].position != nil
				Saison.connection.execute ("DELETE FROM positions WHERE id = #{tact[0].position}")
			end
		end
	end
	Saison.connection.execute ("DELETE FROM tactiques WHERE id = #{tact_id}")
end

# On cree un nouvelle tactique
	logger.debug " *** Creation tactique ***"
	 (1..11).each do |i| 
		x=  params[:"jx_#{i}"]
		y=  params[:"jy_#{i}"]
		j= params[:"j_#{i}"]
		if x != "" &&  y != "" && j != ""
			logger.debug "insert position x,y  #{x} , #{y} joueur : #{j}"
			tact[i]= Saison.connection.insert_sql("INSERT INTO positions (x,y,id_joueur) VALUES (#{x},#{y},#{j})")
			req_debut += "position_j#{i}_id,"
			req_fin += "#{tact[i]},"
			trouve=true
		end
	end 
	(1..5).each do |i| 
		remp[i]=  params[:"r_#{i}"]
		if remp[i] != ""
			req_debut += "remplacant#{i}_id,"
			req_fin += "#{remp[i]},"
			trouve=true
		end
	end 
	
	if trouve==true
		req = req_debut[0...-1] + ")" + req_fin[0...-1] + ")"
		else
		req = req_debut + ")" + req_fin + ")"
	end
	logger.debug " Requete #{req}"
	tact_id = Saison.connection.insert_sql(req)
	
#On met à jour le match 
if @match[0].equipe1_id == current_team
	Saison.connection.execute("UPDATE matchs SET tactique_equipe1 =	#{tact_id}
									WHERE id = #{@match[0].id}")
else
	Saison.connection.execute("UPDATE matchs SET tactique_equipe2 = #{tact_id}
									WHERE id = #{@match[0].id}")
end

redirect_to '/'
end


end
