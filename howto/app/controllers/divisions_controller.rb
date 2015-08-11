class DivisionsController < ApplicationController
  def index
#    @divisions = Division.all
						
	
	@divisionN = Division.find_by_sql(["SELECT equipes.nom as equipe, equipes.id as equipeID, 
										users.id as userID, users.email , users.login 
										FROM equipes, historiques, saisons,users, divisions
										WHERE historiques.saison_id = saisons.id
										AND equipes.id = users.equipe_id
										AND equipes.id = historiques.equipe_id
										AND saisons.division_id = divisions.id
										AND divisions.nom ='Nord'"])
  
   @divisionNE = Division.find_by_sql(["SELECT equipes.nom as equipe, equipes.id as equipeID, 
										users.id as userID, users.email , users.login 
										FROM equipes, historiques, saisons,users, divisions
										WHERE historiques.saison_id = saisons.id
										AND equipes.id = users.equipe_id
										AND equipes.id = historiques.equipe_id
										AND saisons.division_id = divisions.id
										AND divisions.nom ='Nord-Est'"])
  
  @divisionE = Division.find_by_sql(["SELECT equipes.nom as equipe, equipes.id as equipeID, 
										users.id as userID, users.email , users.login 
										FROM equipes, historiques, saisons,users, divisions
										WHERE historiques.saison_id = saisons.id
										AND equipes.id = users.equipe_id
										AND equipes.id = historiques.equipe_id
										AND saisons.division_id = divisions.id
										AND divisions.nom ='Est'"])
  
  @divisionSE = Division.find_by_sql(["SELECT equipes.nom as equipe, equipes.id as equipeID, 
										users.id as userID, users.email , users.login 
										FROM equipes, historiques, saisons,users, divisions
										WHERE historiques.saison_id = saisons.id
										AND equipes.id = users.equipe_id
										AND equipes.id = historiques.equipe_id
										AND saisons.division_id = divisions.id
										AND divisions.nom ='Sud-Est'"])
  
  @divisionS = Division.find_by_sql(["SELECT equipes.nom as equipe, equipes.id as equipeID, 
										users.id as userID, users.email , users.login 
										FROM equipes, historiques, saisons,users, divisions
										WHERE historiques.saison_id = saisons.id
										AND equipes.id = users.equipe_id
										AND equipes.id = historiques.equipe_id
										AND saisons.division_id = divisions.id
										AND divisions.nom ='Sud'"])
  
  @divisionSO = Division.find_by_sql(["SELECT equipes.nom as equipe, equipes.id as equipeID, 
										users.id as userID, users.email , users.login 
										FROM equipes, historiques, saisons,users, divisions
										WHERE historiques.saison_id = saisons.id
										AND equipes.id = users.equipe_id
										AND equipes.id = historiques.equipe_id
										AND saisons.division_id = divisions.id
										AND divisions.nom ='Sud-Ouest'"])
  
  @divisionO = Division.find_by_sql(["SELECT equipes.nom as equipe, equipes.id as equipeID, 
										users.id as userID, users.email , users.login 
										FROM equipes, historiques, saisons,users, divisions
										WHERE historiques.saison_id = saisons.id
										AND equipes.id = users.equipe_id
										AND equipes.id = historiques.equipe_id
										AND saisons.division_id = divisions.id
										AND divisions.nom ='Ouest'"])
  
  @divisionNO = Division.find_by_sql(["SELECT equipes.nom as equipe, equipes.id as equipeID, 
										users.id as userID, users.email , users.login 
										FROM equipes, historiques, saisons,users, divisions
										WHERE historiques.saison_id = saisons.id
										AND equipes.id = users.equipe_id
										AND equipes.id = historiques.equipe_id
										AND saisons.division_id = divisions.id
										AND divisions.nom ='Nord-Ouest'"])
	
					
	 if not current_user
	@user_session = UserSession.new
	end
  
  end

  def show
  #   @equipe = Equipe.find(:all, :include => [:saisons => :historiques],
	#			:conditions =>["saisons.division_id =?",params[:id]])
     @division = Division.find(params[:id])
    
    
    	@saison = Saison.find_by_sql(["SELECT equipe1.nom AS equipe1Nom, equipe2.nom equipe2Nom, matchs.score1, matchs.score2,
									matchs.num_journee,matchs.id, matchs.equipe1_id, matchs.equipe2_id    
									FROM equipes AS equipe1, equipes AS equipe2, matchs, saisons
									WHERE matchs.saison_id = saisons.id
									AND equipe2.id = matchs.equipe2_id
									AND equipe1.id = matchs.equipe1_id
									AND saisons.division_id = ?",  params[:id]])
	
	 if not current_user
	@user_session = UserSession.new
	end
    
  end

 def list
  #   @equipe = Equipe.find(:all, :include => [:saisons => :historiques],
	#			:conditions =>["saisons.division_id =?",params[:id]])
     @division = Division.find(params[:id])
    
    	
									
	@topbut = Joueur.find_by_sql(["SELECT joueurs.id, joueurs.nom, joueurs.prenom, joueurs.numero, SUM(stats.`but`) as buts, AVG(stats.`but`) as avgbuts, COUNT(stats.id) as count, equipes.nom as equipe
									FROM stats, joueurs, equipes, contrats, historiques, saisons
									WHERE stats.id_joueur = joueurs.id
									AND equipes.id = contrats.equipe_id
									AND joueurs.id = contrats.joueur_id
									AND equipes.id = historiques.equipe_id
									AND saisons.id = historiques.saison_id
									AND saisons.division_id = ?
									GROUP BY joueurs.id
									ORDER BY buts DESC
									LIMIT 0 , 10",params[:id]])
									
										
	@toptir = Joueur.find_by_sql(["SELECT joueurs.id, joueurs.nom, joueurs.prenom, joueurs.numero, SUM(stats.`tir+`) as buts, AVG(stats.`tir+`) as avgbuts, COUNT(stats.id) as count,  equipes.nom as equipe
									FROM stats, joueurs, equipes, contrats, historiques, saisons
									WHERE stats.id_joueur = joueurs.id
									AND equipes.id = contrats.equipe_id
									AND joueurs.id = contrats.joueur_id
									AND equipes.id = historiques.equipe_id
									AND saisons.id = historiques.saison_id
									AND saisons.division_id = ?				
									GROUP BY joueurs.id
									ORDER BY avgbuts DESC
									LIMIT 0 , 10",params[:id]])
									
		
									
	@topballon = Joueur.find_by_sql(["SELECT joueurs.id, joueurs.nom, joueurs.prenom, joueurs.numero, SUM(stats.`ballon+`) as ballon, AVG(stats.`ballon+`) as avgballon, COUNT(stats.id) as count , equipes.nom as equipe
									FROM stats, joueurs, equipes, contrats, historiques, saisons
									WHERE stats.id_joueur = joueurs.id
									AND equipes.id = contrats.equipe_id
									AND joueurs.id = contrats.joueur_id
									AND equipes.id = historiques.equipe_id
									AND saisons.id = historiques.saison_id
									AND saisons.division_id = ?
									GROUP BY joueurs.id
									ORDER BY avgballon DESC
									LIMIT 0 , 10",params[:id]])
									
	
									
	@toppasse = Joueur.find_by_sql(["SELECT joueurs.id, joueurs.nom, joueurs.prenom, joueurs.numero, SUM(stats.`passe+`) as passe, AVG(stats.`passe+`) as avgpasse, COUNT(stats.id) as count , equipes.nom as equipe
									FROM stats, joueurs, equipes, contrats, historiques, saisons
									WHERE stats.id_joueur = joueurs.id
									AND equipes.id = contrats.equipe_id
									AND joueurs.id = contrats.joueur_id
									AND equipes.id = historiques.equipe_id
									AND saisons.id = historiques.saison_id
									AND saisons.division_id = ?
									GROUP BY joueurs.id
									ORDER BY avgpasse DESC
									LIMIT 0 , 10",params[:id]])

									
	@toptackle = Joueur.find_by_sql(["SELECT joueurs.id, joueurs.nom, joueurs.prenom, joueurs.numero, SUM(stats.`tackle+`) as tackle, AVG(stats.`tackle+`) as avgtackle, COUNT(stats.id) as count , equipes.nom as equipe
									FROM stats, joueurs, equipes, contrats, historiques, saisons
									WHERE stats.id_joueur = joueurs.id
									AND equipes.id = contrats.equipe_id
									AND joueurs.id = contrats.joueur_id
									AND equipes.id = historiques.equipe_id
									AND saisons.id = historiques.saison_id
									AND saisons.division_id = ?
									GROUP BY joueurs.id
									ORDER BY avgtackle DESC
									LIMIT 0 , 10",params[:id]])

									
	@topdrible = Joueur.find_by_sql(["SELECT joueurs.id, joueurs.nom, joueurs.prenom, joueurs.numero, SUM(stats.`drible+`) as drible, AVG(stats.`drible+`) as avgdrible, COUNT(stats.id) as count , equipes.nom as equipe
									FROM stats, joueurs, equipes, contrats, historiques, saisons
									WHERE stats.id_joueur = joueurs.id
									AND equipes.id = contrats.equipe_id
									AND joueurs.id = contrats.joueur_id
									AND equipes.id = historiques.equipe_id
									AND saisons.id = historiques.saison_id
									AND saisons.division_id = ?
									GROUP BY joueurs.id
									ORDER BY avgdrible DESC
									LIMIT 0 , 10",params[:id]])


									
															

	 if not current_user
	@user_session = UserSession.new
	end
    
  end






end
