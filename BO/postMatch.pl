#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;
use Net::SMTP;
#use Statistics::Lite qw(:all);

#Ce script  calcule le classement pour la journée en cours, avance la journée de 1 et copie les tactiques de la journée courante vers la prochaine
#Envoie d'un mail au joueur

my $database="howto";
#my $hostname="88.167.71.144";
#my $hostname="192.168.30.15";
my $hostname="127.0.0.1";
#my $login = "football";
#my $mdp = "!M4n4g3r";

my $login = "root";
my $mdp = "cacapipi";


my $dsn = "DBI:mysql:database=$database;host=$hostname";
my $dbh = DBI->connect($dsn, $login, $mdp) or die "Echec connexion";



my @match = ();
  
  my $requeteMatch;
    
  my $sthMatch;
  my $stJournee;
 
  
  $requeteMatch = "SELECT matchs.id, matchs.equipe1_id, matchs.equipe2_id , matchs.score1, matchs.score2, 
					matchs.tactique_equipe1, matchs.tactique_equipe2
                    FROM matchs, annees WHERE num_journee = annees.journee ";
 
  my $requeteNextMatch="SELECT matchs.id , matchs.equipe1_id, matchs.equipe2_id 
						from matchs,annees 
						WHERE (matchs.equipe1_id = ? OR matchs.equipe2_id = ?) 
						AND matchs.num_journee = annees.journee + 1";	
  
  my $requeteJournee="SELECT journee from annees";
  
my $requeteUPDJournee="UPDATE annees SET journee= ?";


my $requeteClassement ="SELECT * from classements, saisons, equipes ,historiques, divisions WHERE 
										historiques.id = classements.historique_id 
										AND historiques.saison_id = saisons.id
										AND equipes.id = historiques.equipe_id
										AND saisons.division_id = divisions.id
										AND equipes.id = ?";
										
my $requeteUPDClassement = "UPDATE classements SET points = ?, victoire = ?, defaite = ?, nul = ?, bp = ?, bc = ?, ext_victoire = ?, ext_defaite = ?,
							ext_nul= ?,	ext_points= ?, ext_bp= ?, ext_bc = ?, dom_victoire = ?,	dom_defaite = ?, dom_nul= ?, dom_points= ?,	dom_bp= ?,
							dom_bc= ?, nb_journee = ? WHERE id = ?"; 														


my $requeteTact = "SELECT * FROM tactiques WHERE id = ?";
my $requetePos = "SELECT x,y, id_joueur FROM positions WHERE id = ?";
my $requeteNextPos = "INSERT INTO positions (x,y,id_joueur) VALUES (?,?,?)";
my $requeteNextTact = "INSERT INTO tactiques (position_j1_id,position_j2_id,position_j3_id, position_j4_id,position_j5_id, position_j6_id,
						position_j7_id,position_j8_id,position_j9_id,position_j10_id,position_j11_id,remplacant1_id,remplacant2_id,remplacant3_id,
						remplacant4_id,remplacant5_id) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"; 

my $requeteUPDPosNextMatchE1 = "UPDATE matchs SET matchs.tactique_equipe1 = ? where id = ? ";
my $requeteUPDPosNextMatchE2 = "UPDATE matchs SET matchs.tactique_equipe2 = ? where id = ? ";

my $requeteJoueur = "SELECT login, email, equipes.nom, divisions.nom from users, equipes, historiques, saisons, divisions
						where users.equipe_id = ?
						AND users.equipe_id = equipes.id
						AND  historiques.saison_id = saisons.id
						AND equipes.id = historiques.equipe_id
						AND saisons.division_id = divisions.id";


my $strequeteJoueur = $dbh->prepare($requeteJoueur);

my $strequeteUPDPosNextMatchE1 = $dbh->prepare($requeteUPDPosNextMatchE1);
my $strequeteUPDPosNextMatchE2 = $dbh->prepare($requeteUPDPosNextMatchE2);
my $stNextMatch = $dbh->prepare($requeteNextMatch);
my $stNextTact = $dbh->prepare($requeteNextTact);
my $stNextPos = $dbh->prepare($requeteNextPos);
my $stPos = $dbh->prepare($requetePos);
my $stTact = $dbh->prepare($requeteTact);
 my $stClassement = $dbh->prepare($requeteClassement);				
 my $stUPDClassement = $dbh->prepare($requeteUPDClassement);
 my $stUPDJournee = $dbh->prepare($requeteUPDJournee);

  #requete Update moral et condition Joueurs
  my $requeteUPDJoueur = "UPDATE joueurs SET  moral = ? , cond =? WHERE id = ?";
	my $stUPDJoueur = $dbh->prepare($requeteUPDJoueur);	
	
	my $requeteCaracJoueur = "SELECT joueurs.age,joueurs.xp,joueurs.physique,joueurs.mental,joueurs.cond,joueurs.moral,joueurs.id FROM joueurs, contrats, equipes
							WHERE contrats.joueur_id = joueurs.id
							AND contrats.equipe_id = equipes.id
							AND equipes.id = ?";
		
		#0 age,
		#1 xp,
		#2 physique,
		#3 mental,
		#4 cond,
		#5 moral							
		#6 id
		
	my $stCaracJoueur = $dbh->prepare($requeteCaracJoueur);

  $sthMatch = $dbh->prepare($requeteMatch);
  
  $stJournee = $dbh->prepare($requeteJournee);
 
  my $Journee;
  my @Journee_tab =();
$stJournee->execute();
@Journee_tab = $stJournee->fetchrow_array;
$Journee = $Journee_tab[0];
$sthMatch->execute();

#Pour chaque match de la journée X (en dur dans la requete)
while(@match = $sthMatch->fetchrow_array)
{

print "\n\n===============================================      Match : $match[0] ================================== \n";
##############  calculer le classement ###################@@

 my @E1Classement = ();
 my @E2Classement = ();

 $stClassement->execute($match[1]);
 @E1Classement = $stClassement->fetchrow_array;

 $stClassement->execute($match[2]);
 @E2Classement = $stClassement->fetchrow_array;

 
 my $E1points = 0;
 my $E1victoire = 0;
 my $E1nul = 0;
 my $E1defaite = 0;
 my $E2points = 0;
 my $E2victoire = 0;
 my $E2nul = 0;
 my $E2defaite = 0;
 my $E1But = 0;
 my $E2But = 0;
 
 $E1But = $match[3];
 $E2But = $match[4];
 
 if ($E1But > $E2But){
	 $E1points = 3;
	 $E1victoire = 1;
	 $E2defaite = 1;
 }
 else
 {
	if ($E1But < $E2But){
	 $E2points = 3;
	 $E2victoire = 1;
	 $E1defaite = 1;
	}
	else{
	 $E1points = 1;
	 $E2points = 1;
	 $E1nul = 1;
	 $E2nul = 1;
	}
 }
 #points = ?, victoire = ?, defaite = ?, nul = ?, bp = ?, bc = ?, ext_victoire = ?, ext_defaite 
 #ext_nul= ?,	ext_points= ?, ext_bp= ?, ext_bc = ?, dom_victoire = ?,	dom_defaite = ?, dom_nul= ?, dom_points= ?,	dom_bp= ?,
 #dom_bc= ?, nb_journee = ? WHERE id = ?
 #id 	points 	victoire 	defaite 	nul 	bp 	bc 	ext_victoire 	ext_defaite 	ext_nul 	ext_points 	ext_bp 	ext_bc 	
 #dom_victoire 	dom_defaite 	dom_nul 	dom_points 	dom_bp 	dom_bc 	historique_id 	nb_journee

 $stUPDClassement->execute( $E1Classement[1] +$E1points, $E1Classement[2] + $E1victoire, $E1Classement[3] + $E1defaite, $E1Classement[4] + $E1nul,
					$E1Classement[5] + $match[3] , $E1Classement[6] + $match[4], $E1Classement[7], $E1Classement[8], $E1Classement[9],
					$E1Classement[10], $E1Classement[11], $E1Classement[12], $E1Classement[13] + $E1victoire, $E1Classement[14] + $E1defaite,
					$E1Classement[15] + $E1nul, $E1Classement[16] + $E1points, $E1Classement[17] +  $match[3], $E1Classement[18] +  $match[4],
					$Journee,$E1Classement[0] );
					
					
 $stUPDClassement->execute( $E2Classement[1] +$E2points, $E2Classement[2] + $E2victoire, $E2Classement[3] + $E2defaite, $E2Classement[4] + $E2nul,
					$E2Classement[5] + $match[4] , $E2Classement[6] + $match[3], $E2Classement[7] +  $E2victoire , $E2Classement[8] + $E2defaite , 
					$E2Classement[9] + $E2nul, $E2Classement[10] + $E2points , $E2Classement[11] +  $match[4], $E2Classement[12] +  $match[3],
					$E2Classement[13] , $E2Classement[14] ,	$E2Classement[15]  , $E2Classement[16] , $E2Classement[17], $E2Classement[18]  ,
					$Journee,$E2Classement[0] );
					
 
 ##############  copier la tactique de la journée N vers la journée N+1 ###################@@
 my @E1Tact = ();
 my @E2Tact = ();
 my @Pos = (); 
 my @nextPos = ();
 my @remp = ();
 my $tactID;
 my @nextmatch = ();
 
 print "Equipe 1 \n";
 #Equipe1
 $stTact->execute($match[5]);
 @E1Tact = $stTact->fetchrow_array;
  for(my $i = 1; $i<=11; $i++){
	$stPos->execute($E1Tact[$i]);
	@Pos = $stPos->fetchrow_array;
	if (not defined ($Pos[2])  ){
		print "Pas de joueur pour la position $i \n";
	}
	else{	
		if (not defined($Pos[0]) || not defined ($Pos[1] ))
		{
			print "x ou y null pour la position $i du joueur $Pos[2] \n";
		}
		else
		{
			print "$Pos[0] , $Pos[1] , $Pos[2] \n";
		}
			$stNextPos-> execute($Pos[0],$Pos[1],$Pos[2]);	
			push(@nextPos, $dbh->{'mysql_insertid'});
	}
  }
 push(@remp,$E1Tact[12]);
 push(@remp,$E1Tact[13]);
 push(@remp,$E1Tact[14]);
 push(@remp,$E1Tact[15]);
 push(@remp,$E1Tact[16]);	

$stNextMatch->execute($match[1],$match[1]);
@nextmatch = $stNextMatch->fetchrow_array;

$stNextTact->execute($nextPos[0],$nextPos[1],$nextPos[2],$nextPos[3],$nextPos[4],$nextPos[5],$nextPos[6],$nextPos[7],$nextPos[8],$nextPos[9],$nextPos[10],$remp[0],$remp[1],$remp[2],$remp[3],$remp[4]);
$tactID = $dbh->{'mysql_insertid'};
if ($match[1] == $nextmatch[1]){
 $strequeteUPDPosNextMatchE1->execute($tactID,$nextmatch[0]);	
}
else
{
 $strequeteUPDPosNextMatchE2->execute($tactID,$nextmatch[0]);	
}

# la fatigue physique et mental
$stCaracJoueur->execute($match[1]);
#my @joueur_tab = $stCaracJoueur->fetchrow_array();
my @joueur_tab =();
		#0 age,
		#1 xp,
		#2 physique,
		#3 mental,
		#4 cond,
		#5 moral							
		#6 id
while (@joueur_tab =  $stCaracJoueur->fetchrow_array()){

	my $mental = 0;
	my $mentalModificateur = 1 - ( (  (2* (rand($joueur_tab[3])/100)) +  (rand($joueur_tab[1])/100) )/3);
	my $condition = int ($joueur_tab[4] + 30 + 10 * ( (rand($joueur_tab[2])/100) )) ;

	print "  $joueur_tab[4] : $joueur_tab[2]  ||  $joueur_tab[5] : $joueur_tab[3] / $joueur_tab[1] / \n";	
	
	if ($E1But > $E2But){
		my $test = rand( $joueur_tab[3]);
		my $lvl = rand(25);
		
		if ($test > $lvl){
			$mentalModificateur =  ( (  (2* (rand($joueur_tab[3])/100)) +  (rand($joueur_tab[1])/100) )/3);
			$mental = int ($joueur_tab[5] + 4 / $mentalModificateur);
		}
		else{
			$mental = int ($joueur_tab[5] - 10 * $mentalModificateur);
		}
	    #$mental = int ($E1moral_tab[$i] + 25 * $mentalModificateur);
	}
	else{
		if ($E1But < $E2But){
			my $test = rand( $joueur_tab[3]);
			my $lvl = rand(75);
		
			if ($test > $lvl){
				$mentalModificateur =  ( (  (2* (rand($joueur_tab[3])/100)) +  (rand($joueur_tab[1])/100) )/3);
				$mental = int ($joueur_tab[5] + 1 / $mentalModificateur);
			}
			else{
				$mental = int ($joueur_tab[5] - 30 * $mentalModificateur);
			}
		}
		else{
			my $test = rand( $joueur_tab[3]);
			my $lvl = rand(50);
		
			if ($test > $lvl){
				$mentalModificateur =  ( (  (2* (rand($joueur_tab[3])/100)) +  (rand($joueur_tab[1])/100) )/3);
				$mental = int ($joueur_tab[5] + 2 / $mentalModificateur);
			}
			else{
				$mental = int ($joueur_tab[5] - 20 * $mentalModificateur);
			}
		}
	}
	
	
	
	if ($mental < 20){
		$mental = $mental + rand($joueur_tab[3]);
	}
	
	if ($mental > 100){
		$mental = 100;
	}
	
	if ($condition < 0){
		$condition = 0;
	}
	
	if ($condition > 100){
		$condition = 100;
	}

	
#   my $requeteUPDJoueur = "UPDATE joueurs SET  moral = ? , cond =? WHERE id = ?";
$stUPDJoueur->execute ($mental, $condition ,$joueur_tab[6] );
print "  Condition : $condition  / Moral : $mental  pour le joueur $joueur_tab[6] \n";

}

#Equipe2

 @Pos = (); 
 @nextPos = ();
 @remp = ();
print "Equipe 2 \n";
$stTact->execute($match[6]);
 @E2Tact = $stTact->fetchrow_array;
  for(my $i = 1; $i<=11; $i++){
	$stPos->execute($E2Tact[$i]);
	@Pos = $stPos->fetchrow_array;
	print "$Pos[0] , $Pos[1] , $Pos[2] \n";
	$stNextPos-> execute($Pos[0],$Pos[1],$Pos[2]);	
	push(@nextPos, $dbh->{'mysql_insertid'});
  }
 push(@remp,$E2Tact[12]);
 push(@remp,$E2Tact[13]);
 push(@remp,$E2Tact[14]);
 push(@remp,$E2Tact[15]);
 push(@remp,$E2Tact[16]);	

$stNextMatch->execute($match[2],$match[2]);
@nextmatch = $stNextMatch->fetchrow_array;

$stNextTact->execute($nextPos[0],$nextPos[1],$nextPos[2],$nextPos[3],$nextPos[4],$nextPos[5],$nextPos[6],$nextPos[7],$nextPos[8],$nextPos[9],$nextPos[10],$remp[0],$remp[1],$remp[2],$remp[3],$remp[4]);
$tactID = $dbh->{'mysql_insertid'};
if ($match[2] == $nextmatch[1]){
 $strequeteUPDPosNextMatchE1->execute($tactID,$nextmatch[0]);	
}
else
{
 $strequeteUPDPosNextMatchE2->execute($tactID,$nextmatch[0]);	
}


# la fatigue physique et mental
$stCaracJoueur->execute($match[2]);
#my @joueur_tab = $stCaracJoueur->fetchrow_array();
#my @joueur_tab =();
		#0 age,
		#1 xp,
		#2 physique,
		#3 mental,
		#4 cond,
		#5 moral							
		#6 id
while (@joueur_tab =  $stCaracJoueur->fetchrow_array()){

	my $mental = 0;
	my $mentalModificateur = 1 - ( (  (2* (rand($joueur_tab[3])/100)) +  (rand($joueur_tab[1])/100) )/3);
	my $condition = int ($joueur_tab[4] + 30 + 10 * ( (rand($joueur_tab[2])/100) )) ;

	print "  $joueur_tab[4] : $joueur_tab[2]  ||  $joueur_tab[5] : $joueur_tab[3] / $joueur_tab[1] / \n";	
	
	if ($E1But < $E2But){
		my $test = rand( $joueur_tab[3]);
		my $lvl = rand(25);
		
		if ($test > $lvl){
			$mentalModificateur =  ( (  (2* (rand($joueur_tab[3])/100)) +  (rand($joueur_tab[1])/100) )/3);
			$mental = int ($joueur_tab[5] + 4 / $mentalModificateur);
		}
		else{
			$mental = int ($joueur_tab[5] - 10 * $mentalModificateur);
		}
	    #$mental = int ($E1moral_tab[$i] + 25 * $mentalModificateur);
	}
	else{
		if ($E1But > $E2But){
			my $test = rand( $joueur_tab[3]);
			my $lvl = rand(75);
		
			if ($test > $lvl){
				$mentalModificateur =  ( (  (2* (rand($joueur_tab[3])/100)) +  (rand($joueur_tab[1])/100) )/3);
				$mental = int ($joueur_tab[5] + 1 / $mentalModificateur);
			}
			else{
				$mental = int ($joueur_tab[5] - 30 * $mentalModificateur);
			}
		}
		else{
			my $test = rand( $joueur_tab[3]);
			my $lvl = rand(50);
		
			if ($test > $lvl){
				$mentalModificateur =  ( (  (2* (rand($joueur_tab[3])/100)) +  (rand($joueur_tab[1])/100) )/3);
				$mental = int ($joueur_tab[5] + 2 / $mentalModificateur);
			}
			else{
				$mental = int ($joueur_tab[5] - 20 * $mentalModificateur);
			}
		}
	}
	
	
	if ($mental < 20){
		$mental = $mental + rand($joueur_tab[3]);
	}
	
	if ($mental > 100){
		$mental = 100;
	}
	
	if ($condition < 0){
		$condition = 0;
	}
	
	if ($condition > 100){
		$condition = 100;
	}
	

	
#   my $requeteUPDJoueur = "UPDATE joueurs SET  moral = ? , cond =? WHERE id = ?";
$stUPDJoueur->execute ($mental, $condition ,$joueur_tab[6] );
print "  Condition : $condition  / Moral : $mental  pour le joueur $joueur_tab[6] \n";

}




########### Send mail au joueur avec les resultats et le rappel du password	

		$strequeteJoueur->execute($match[1]);
		my @JoueurE1 = $strequeteJoueur->fetchrow_array; 
		$strequeteJoueur->execute($match[2]);
		my @JoueurE2 = $strequeteJoueur->fetchrow_array;

		
		
		my $messageVictoire="Bravi, Bravo!! Vous avez gagné votre match comptant pour la journée n° $Journee du championnat";
		my $messageDefaite="Oh flûte alors! Vous avez perdu votre match comptant pour la journée n° $Journee du championnat";
		my $messageNul="Une journée moyennement moyenne pour votre équipe qui a fait un match nul pour la n° $Journee du championnat";
		my $messageFin="Connectez vous sur http://www.howtomanagemyfootballteam.com/stats/$match[0] pour voir ce qui s'est réellement passé\n\n L'équipe de HTMMFT
						\n\n" .
						"Suivez toute l'actualité du site sur http://www.facebook.com/Howtomanagemyfootballteamcom \n\n".
						 "P.S : Bientôt, pour ceux qui ont perdu leur mot de passe, un formulaire sera en place pour le retrouver";
		my $messageScore=" sur le score de $E1But - $E2But \n";
		
		

		
		
		#TODO, recuperer les infos de la deuxième equipe qui n'est pas forcement une equipe avec un user
		#TODO NextMatch : Annoncer le prochain match, donne le mail du prochain adversaire
		
		my $serveursmtp = "smtp.free.fr";
		my $from = 'webmaster@howtomanagemyfootballteam.com';
		
		if(defined($JoueurE1[0])){
		
		my $messageE1="Bonjour $JoueurE1[0],\n\n";
		my $sujetE1="Résultat de journée n° $Journee pour $JoueurE1[2] de la division $JoueurE1[3]";
		my $messageEquipe1=" $JoueurE1[3] avec l'équipe $JoueurE1[2]";
		if ($E1But > $E2But){
			$messageE1 .= $messageVictoire;
		}
		else
		{
			if ($E1But < $E2But){
				$messageE1 .= $messageDefaite;
			}
			else{
				$messageE1 .= $messageNul;
			}
		}
		$messageE1 .=  $messageEquipe1 . $messageScore . $messageFin;
		
		
		
		
		
		my $smtp = Net::SMTP->new($serveursmtp, Debug => 1) 
          or print "Pas de connexion SMTP(1): $!\n";
        $smtp->mail($from)
          or print "Erreur: MAIL FROM(1)\n";
        $smtp->to($JoueurE1[1])
          or print "Erreur: RCPT TO(1)\n";
        $smtp->data()
          or print "Erreur: DATA(1)\n";
        $smtp->datasend("From: HTMMFT <$from>\n");   # en-tête
		$smtp->datasend("To: $JoueurE1[1]\n");   # en-tête
		$smtp->datasend("Subject: [HTMMFT] $sujetE1 \n");           # en-tête
        $smtp->datasend("MIME-Version: 1.0\n");
        $smtp->datasend("Content-Type: text/plain; charset=UTF-8\n");
        $smtp->datasend($messageE1)
          or print "Impossible d'envoyer le message(1)\n";
        $smtp->dataend()
          or print "Erreur (fin de DATA(1))\n";
        $smtp->quit()
          or print "Erreur: QUIT(1)\n";
          
          sleep(1);
		}
		
		if (defined($JoueurE2[0])){
			my $messageE2 ="Bonjour $JoueurE2[0],\n\n";
			my $messageEquipe2=" $JoueurE2[3] avec l'équipe $JoueurE2[2]";
			if ($E1But > $E2But){
			$messageE2 .= $messageDefaite;
		}
		else
		{
			if ($E1But < $E2But){
				$messageE2 .= $messageVictoire;
			}
			else{
				$messageE2 .= $messageNul;
			}
		}
			my $sujetE2="Résultat de journée n° $Journee pour $JoueurE2[2] de la division $JoueurE2[3]";
			$messageE2 .= $messageEquipe2 . $messageScore . $messageFin;
			my $smtp = Net::SMTP->new($serveursmtp, Debug => 1) 
          or print "Pas de connexion SMTP(2): $!\n";
        $smtp->mail($from)
          or print "Erreur: MAIL FROM(2)\n";
        $smtp->to($JoueurE2[1])
          or print "Erreur: RCPT TO(2)\n";
        $smtp->data()
          or print "Erreur: DATA(2)\n";
        $smtp->datasend("From: HTMMFT <$from>\n");   # en-tête
		$smtp->datasend("To: $JoueurE2[1]\n");   # en-tête
		$smtp->datasend("Subject: [HTMMFT] $sujetE2 \n");           # en-tête
         $smtp->datasend("MIME-Version: 1.0\n");
        $smtp->datasend("Content-Type: text/plain; charset=UTF-8\n");
        $smtp->datasend($messageE2)
          or print "Impossible d'envoyer le message(2)\n";
        $smtp->dataend()
          or print "Erreur (fin de DATA(2))\n";
        $smtp->quit()
          or print "Erreur: QUIT(2)\n";
          
          sleep(1);
		}
	
		
	
}	
	
##############  avancer la journée de 1 ###################@@



$stUPDJournee->execute($Journee + 1);
