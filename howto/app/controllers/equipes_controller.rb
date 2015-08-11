class EquipesController < ApplicationController
  def test
  @classement = Classement.find_by_sql(["SELECT equipes.nom as equipe, equipes.id as equipeID, points, victoire,defaite,nul,bp,bc, nb_journee,
										divisions.nom ,divisions.id as divID
										FROM equipes, historiques, saisons, classements, divisions
										WHERE historiques.id = classements.historique_id 
										AND historiques.saison_id = saisons.id
										AND equipes.id = historiques.equipe_id
										AND saisons.division_id = divisions.id
										AND saisons.division_id = (SELECT saisons.division_id FROM equipes, historiques, saisons
										WHERE historiques.saison_id = saisons.id
										AND historiques.equipe_id = equipes.id
										AND equipes.id = ?)  ORDER BY points DESC,(bp-bc) DESC", 1])
	@agenda = Saison.find_by_sql(["SELECT equipe1.nom AS equipe1Nom, equipe2.nom equipe2Nom,  matchs.score1, matchs.score2,
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
									AND equipes.id =?)",  1])

	@calendrier = Saison.find_by_sql(["SELECT equipe1.nom AS equipe1Nom, matchs.score1, matchs.score2, equipe2.nom  AS equipe2Nom, 
										matchs.num_journee,matchs.id  , equipe1.id as equipe1ID , equipe2.id  as equipe2ID  
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
									AND equipes.id =?)",  1 ,  1,  1])

  
  
   if not current_user
	@user_session = UserSession.new
  end
  
  
  @couleur1 = Club.find_by_sql(["SELECT clubs.couleur1 as couleur1, clubs.couleur2 as couleur2 
								FROM equipes, clubs, matchs
								WHERE equipes.club_id = clubs.id
								AND equipes.id = matchs.equipe1_id
								AND matchs.id = ?", 114])
	
	@couleur2 = Club.find_by_sql(["SELECT clubs.couleur1 as couleur1, clubs.couleur2 as couleur2 
								FROM equipes, clubs, matchs
								WHERE equipes.club_id = clubs.id
								AND equipes.id = matchs.equipe2_id
								AND matchs.id = ?", 114])
  
    
  # On cherche l'id de la tactique de l'equipe1
	@fdm1 = Saison.find_by_sql(["SELECT tactique_equipe1
									FROM matchs
									WHERE id = ?", 114])
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
									WHERE id = ?", 114])
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

  
  
  
  
  
  
  
  
  
  
  end
  
  
  
  
  
  def index
    @equipes = Equipe.all
     if not current_user
	@user_session = UserSession.new
  end
  end

  def show
  
  if params[:id].to_i == current_team
   redirect_to '/'
  
  else
  @login = Equipe.find_by_sql(["SELECT users.login as login, users.email as email FROM users
								 WHERE users.equipe_id = ?", params[:id]]);
								 
    	#TODO rajouter le filtre pour trouver les joueurs dont la date de in de contrat < date courante
    #@joueurs = Joueur.find(:all, :include => [:equipes => :contrats], 
     #               		 :conditions => ["equipes.id = ?", params[:id]], :order=>"numero")
     
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
										ORDER BY joueurs.numero", params[:id]])
     
     
    @couleur = Club.find_by_sql(["SELECT clubs.couleur1 as couleur1, clubs.couleur2 as couleur2 FROM equipes, clubs
								WHERE equipes.club_id = clubs.id
								AND equipes.id = ?", params[:id]])
	@classement = Classement.find_by_sql(["SELECT equipes.nom as equipe, equipes.id as equipeID, points, victoire,defaite,nul,bp,bc, nb_journee,
										divisions.nom ,divisions.id as divID
										FROM equipes, historiques, saisons, classements, divisions
										WHERE historiques.id = classements.historique_id 
										AND historiques.saison_id = saisons.id
										AND equipes.id = historiques.equipe_id
										AND saisons.division_id = divisions.id
										AND saisons.division_id = (SELECT saisons.division_id FROM equipes, historiques, saisons
										WHERE historiques.saison_id = saisons.id
										AND historiques.equipe_id = equipes.id
										AND equipes.id = ?)  ORDER BY points DESC,(bp-bc) DESC",  params[:id]])
	@agenda = Saison.find_by_sql(["SELECT equipe1.nom AS equipe1Nom, equipe2.nom equipe2Nom,  matchs.score1, matchs.score2,
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
									AND equipes.id =?)",  params[:id]])

	@calendrier = Saison.find_by_sql(["SELECT equipe1.nom AS equipe1Nom, matchs.score1, matchs.score2, equipe2.nom  AS equipe2Nom, 
										matchs.num_journee,matchs.id  , equipe1.id as equipe1ID , equipe2.id  as equipe2ID  
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
									AND equipes.id =?)",  params[:id] ,  params[:id],  params[:id]])

 #On cherche l'id de la tactique de l'equipe
@match = Saison.find_by_sql(["SELECT matchs.id, matchs.equipe1_id, matchs.equipe2_id
									FROM matchs, annees
									WHERE num_journee = annees.journee
									AND (equipe1_id =? OR equipe2_id =?)",  params[:id], params[:id]])

if @match[0].equipe1_id == params[:id].to_i
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
end
  
  
   if not current_user
	@user_session = UserSession.new
  end
  
  
  end
end
