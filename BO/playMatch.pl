#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;
#use Statistics::Lite qw(:all);

#Ce script resoud les matchs

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

my @listeMatch = ();
my @result = ();
my @listePosition1 = ();
my @listePosition2 = ();
  
  my $requeteMatch;
  my $requeteTactiqueEquipe1;
  my $requeteTactiqueEquipe2;
  my $requetePositions;
  my $requetePosition;
  my $requeteScore; 
    
  my $sthMatch;
  my $stTactiqueEquipe1;
  my $stTactiqueEquipe2;
  my $stPositions;
  my $stPosition;
  my $stScore;
  
  #my $min_x = 40;
  my $min_x = 30;
  my $min_y = 10 ;
  #my $max_x = $min_x + 640;
  my $max_x = $min_x + 660;
  my $max_y = $min_y + 430;
  my $mid_x = ($max_x - $min_x) /2;
  my $mid_y = ($max_y - $min_y) /2;
  my $gch_y = $min_y + (($max_y - $min_y) /6 )*2;
  my $drt_y = $max_y - (($max_y - $min_y) /6 )*2;
   
  my $i;
  
  $requeteMatch = "SELECT matchs.id FROM matchs, annees WHERE matchs.num_journee = annees.journee";
  $requeteTactiqueEquipe1 = "SELECT tactique_equipe1 FROM matchs WHERE matchs.id = ?";
  $requeteTactiqueEquipe2 = "SELECT tactique_equipe2 FROM matchs WHERE matchs.id = ?";
  $requetePositions = "SELECT position_j1_id, position_j2_id, position_j3_id, position_j4_id, position_j5_id, position_j6_id,
						position_j7_id, position_j8_id, position_j9_id, position_j10_id, position_j11_id FROM tactiques 
						WHERE tactiques.id = ?";
						
  $requetePosition = "SELECT id_joueur, x, y FROM positions WHERE id = ?";
  $requeteScore = "UPDATE matchs SET  score1 = ? , score2=? WHERE id = ?";	
  $sthMatch = $dbh->prepare($requeteMatch);
  $stTactiqueEquipe1 = $dbh->prepare($requeteTactiqueEquipe1);
  $stTactiqueEquipe2 = $dbh->prepare($requeteTactiqueEquipe2);
  $stPositions = $dbh->prepare($requetePositions);
  $stPosition = $dbh->prepare($requetePosition);
  $stScore = $dbh->prepare($requeteScore);

$sthMatch->execute();

while(@result = $sthMatch->fetchrow_array)
{
	push(@listeMatch, $result[0]);
}

#Pour chaque match de la journée X (en dur dans la requete)
foreach my $match (@listeMatch){
	print " \n ***********************************************          Match n° : $match          **********************************************************\n";
		$stTactiqueEquipe1->execute($match);
		$stTactiqueEquipe2->execute($match);
		#On recupere la tactique de l'equipe 1
		while( my @result_tac1 = $stTactiqueEquipe1->fetchrow_array)
		{
			if (defined($result_tac1[0])){
				$stPositions->execute($result_tac1[0]);
				while(my @result_poss1 = $stPositions->fetchrow_array)
				{
					$i=0;
					foreach my $position (@result_poss1){						
						$stPosition->execute($position);
						while(my @result_pos1 = $stPosition->fetchrow_array){
							$listePosition1[$i][0] = $result_pos1[0];
							$listePosition1[$i][1] = $result_pos1[1];
							$listePosition1[$i][2] = $result_pos1[2];
						}
					$i++;
					}	
				}
			}			
		}
		#On recupere la tactique de l'equipe 2
		while( my @result_tac2 = $stTactiqueEquipe2->fetchrow_array)
		{
			if (defined($result_tac2[0])){
				$stPositions->execute($result_tac2[0]);
				while(my @result_poss2 = $stPositions->fetchrow_array)
				{
					$i=0;
					foreach my $position (@result_poss2){						
						$stPosition->execute($position);
						while(my @result_pos2 = $stPosition->fetchrow_array){
							$listePosition2[$i][0] = $result_pos2[0];
							$listePosition2[$i][1] = $result_pos2[1];
							$listePosition2[$i][2] = $result_pos2[2];
						}
					$i++;
					}					
				}
			}			
		}
		
		#A ce stade on a la liste des joueurs et des leur positions dans listePosition1(id_joueur, x, y) et listePosition2...
		#Reste a faire les calculs, ecrire les stats, avancer la journée de 1, et copier la tactique de la journée N vers la journée N+1
		
		#Il faut calculer le nombre de ballon par match en comparant la somme des tactique et des technique et du physique de chaque onze titulaire.
		
		my $requeteBallons;
		my $stBallons;
		my $SPhy_E1 = 0;
		my $SPhy_E2 = 0;
		my $STec_E1 = 0;
		my $STec_E2 = 0;
		my $STac_E1 = 0;
		my $STac_E2 = 0;
		my $STac = 0;
		my $STec = 0;
		my $SPhy = 0;
		
		my $nb_ballon;
		my @J =(0,0,0);
		$requeteBallons = "SELECT tactique,technique,physique FROM joueurs
							WHERE id = ?";
		$stBallons = $dbh->prepare($requeteBallons);
		foreach my $joueur (@listePosition1){
			$stBallons->execute(@$joueur[0]);
			@J = $stBallons->fetchrow_array;
			$SPhy_E1 += $J[2];
			$STec_E1 += $J[1];
			$STac_E1 += $J[0];
		}
		
		foreach my $joueur (@listePosition2){
			$stBallons->execute(@$joueur[0]);
			@J = $stBallons->fetchrow_array;
			$SPhy_E2 += $J[2];
			$STec_E2 += $J[1];
			$STac_E2 += $J[0];
		}
		$nb_ballon = (($SPhy_E1 + $SPhy_E2) / (11*2*100)) *  (250 + rand(150));
		print "\n Le nombre de ballon pour le match est $nb_ballon \n";
		
		$nb_ballon = $nb_ballon - ( rand ((1- ($STac_E1 + $STac_E2) /(11*2*100) )*50)) -  (rand ((1- ($STec_E1 + $STec_E2) /(11*2*100) )*100));
		
		print "\n Le nombre de ballon corrigé pour le match est $nb_ballon\n";
		
		#Debut des calculs
		my $JprobaRecup =0;
		my $JprobaRecup_gch =0;
		my $JprobaRecup_drt =0;
		my $JprobaRecup_ctr=0;
		my $JprobaConserv=0;
		my $JprobaConserv_gch=0;
		my $JprobaConserv_drt=0;
		my $JprobaConserv_ctr=0;
	
		
		my $E1probaRecup=0;
		my $E1probaRecup_gch=0;
		my $E1probaRecup_drt=0;
		my $E1probaRecup_ctr=0;		
		my $E1probaConserv=0;
		my $E1probaConserv_gch=0;
		my $E1probaConserv_drt=0;
		my $E1probaConserv_ctr=0;
	
		
		my $E2probaRecup=0;
		my $E2probaRecup_gch=0;
		my $E2probaRecup_drt=0;
		my $E2probaRecup_ctr=0;		
		my $E2probaConserv=0;
		my $E2probaConserv_gch=0;
		my $E2probaConserv_drt=0;
		my $E2probaConserv_ctr=0;
		
		my @E1probaRecup_gch_tab =();
		my @E1probaRecup_drt_tab =();
		my @E1probaRecup_ctr_tab =();		
		my @E1probaConserv_gch_tab =();
		my @E1probaConserv_drt_tab =();
		my @E1probaConserv_ctr_tab =();
		
		my @E2probaRecup_gch_tab =();
		my @E2probaRecup_drt_tab =();
		my @E2probaRecup_ctr_tab =();		
		my @E2probaConserv_gch_tab =();
		my @E2probaConserv_drt_tab =();
		my @E2probaConserv_ctr_tab =();
		#================================
		my $JprobaDef =0;
		my $JprobaDef_gch =0;
		my $JprobaDef_drt =0;
		my $JprobaDef_ctr =0;
		my $JprobaAtq =0;
		my $JprobaAtq_gch =0;
		my $JprobaAtq_drt =0;
		my $JprobaAtq_ctr =0;
	
		
		my $E1probaDef =0;
		my $E1probaDef_gch =0;
		my $E1probaDef_drt =0;
		my $E1probaDef_ctr =0;		
		my $E1probaAtq =0;
		my $E1probaAtq_gch =0;
		my $E1probaAtq_drt =0;
		my $E1probaAtq_ctr =0;
	
		
		my $E2probaDef =0;
		my $E2probaDef_gch =0;
		my $E2probaDef_drt =0;
		my $E2probaDef_ctr =0;		
		my $E2probaAtq =0;
		my $E2probaAtq_gch =0;
		my $E2probaAtq_drt =0;
		my $E2probaAtq_ctr =0;
		
		my @E1probaDef_gch_tab =();
		my @E1probaDef_drt_tab =();
		my @E1probaDef_ctr_tab =();		
		my @E1probaAtq_gch_tab =();
		my @E1probaAtq_drt_tab =();
		my @E1probaAtq_ctr_tab =();
		
		my @E2probaDef_gch_tab =();
		my @E2probaDef_drt_tab =();
		my @E2probaDef_ctr_tab =();		
		my @E2probaAtq_gch_tab =();
		my @E2probaAtq_drt_tab =();
		my @E2probaAtq_ctr_tab =();
		
		my $E1probaGardien =0;
		my $E2probaGardien =0;	
		my $E1Gardien =0;
		my $E2Gardien =0;
		my $Pos_x_min =0;
	
	#DEBUG purpose
		my @E1probaRecup_tab =();		
		my @E1probaConserv_tab =();
		my @E1probaDef_tab =();		
		my @E1probaAtq_tab =();
	
		my @E2probaRecup_tab =();		
		my @E2probaConserv_tab =();
		my @E2probaDef_tab =();		
		my @E2probaAtq_tab =();
		
		my $requeteJoueur;
		my $stJoueur;
		my @DetailJoueur =();
		
	#### La fatigue mental et physique.
		#1 xp,
		#5 physique,
		#7 mental,
		#13 cond,
		#15 moral		
		my @E1xp_tab =();
		my @E1physique_tab=();
		my @E1mental_tab=();
		my @E1cond_tab=();
		my @E1moral_tab=();
		
		my @E2xp_tab =();
		my @E2physique_tab=();
		my @E2mental_tab=();
		my @E2cond_tab=();
		my @E2moral_tab=();
		
		$requeteJoueur = "SELECT age,xp,talent,tactique,technique,physique,vitesse,mental,off,def,drt,ctr,gch,cond,blessure,moral FROM joueurs
							WHERE id = ?";
		
		#0 age,
		#1 xp,
		#2 talent,
		#3 tactique,
		#4 technique,
		#5 physique,
		#6 vitesse,
		#7 mental,
		#8 off,
		#9 def,
		#10 drt,
		#11 ctr,
		#12 gch,
		#13 cond,
		#14 blessure,
		#15 moral							
		$stJoueur = $dbh->prepare($requeteJoueur);		
		
		#requete Stat
		
  my $requetestat = "INSERT INTO stats (`ballon+`, `ballon-`, `passe+`, `passe-`, `drible+`, `drible-`, `tackle+`, `tackle-`, `tir+`, `tir-`,but, `id_joueur`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
   my $requetefdm = "INSERT INTO feuilles_de_matchs (stats_j1_id,stats_j2_id,stats_j3_id,stats_j4_id,stats_j5_id,stats_j6_id,stats_j7_id,stats_j8_id,stats_j9_id,stats_j10_id,stats_j11_id)
					VALUES (?,?,?,?,?,?,?,?,?,?,?)";
   my $requetefdm_match="UPDATE matchs SET fdm_equipe1 = ? , fdm_equipe2 = ? WHERE id = ?";
   my $sthStat= $dbh->prepare($requetestat);
  my $sthFdm= $dbh->prepare($requetefdm);
  my $sthFdm_match= $dbh->prepare($requetefdm_match);			
  
  #requete Update moral et condition Joueurs
  my $requeteUPDJoueur = "UPDATE joueurs SET  moral = ? , cond =? WHERE id = ?";
	my $stUPDJoueur = $dbh->prepare($requeteUPDJoueur);	
		
		print " \n\n		----------------------------------------           Equipe 	1----------------------------------- \n";
		$Pos_x_min = $max_x;
		
		
	foreach my $joueur (@listePosition1){
		$stJoueur->execute(@$joueur[0]);
		@DetailJoueur = $stJoueur->fetchrow_array;
		my $formeMatch = ($DetailJoueur[13] + $DetailJoueur[15] + $DetailJoueur[2]  +rand(50) + 50) / 400;		
		my $multipl_bonus =0;
		#Calcul des bonus de "bon" positionnement des joueurs
			my $bonus_x =0;
		my $bonus_x_atq=0;
		my $bonus_x_def=0;
		my $bonus_y =0; 
		my $diff_x = abs($mid_x - @$joueur[1]); #min
		my $diff_x_def = $max_x - @$joueur[1]; #max
		my $diff_x_atq = @$joueur[1] - $min_x ; #max
		my $diff_y = abs($mid_y - @$joueur[2]); #min
		my $diff_gch_y = abs($gch_y - @$joueur[2]); #max
		my $diff_drt_y = abs($drt_y - @$joueur[2]); #max
		
		$bonus_x_atq = ((($diff_x_atq / $max_x))* $DetailJoueur[8]) / 100;
		$bonus_x_def = (( ($diff_x_def / $max_x))* $DetailJoueur[9]) / 100;
			
		if (@$joueur[1] > $mid_x){
			$bonus_x =  ((1 - ($diff_x / $max_x)) * $DetailJoueur[8]) / 100;
		}
		else
		{
			$bonus_x =  ((1-  ($diff_x / $max_x)) * $DetailJoueur[9])/ 100;
		}
		
		$JprobaRecup = (($bonus_x*2 )* (1+$formeMatch )* (1+(1-($diff_x / $max_x) * $DetailJoueur[3])/100 )* (1+ ( $DetailJoueur[3] * 3 + $DetailJoueur[5]*2 + $DetailJoueur[4] )/600 ) * (1+ ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500)) / 6;		
		$JprobaConserv = (($bonus_x*2) *(1+ $formeMatch )* (1+(1-($diff_x / $max_x) * $DetailJoueur[3])/100) *  (1+( $DetailJoueur[3] * 2+ $DetailJoueur[4] * 3 )/500) * (1+($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500))/6;		
		$JprobaAtq = (($bonus_x_atq*2) * (1+$formeMatch) * (1+(($diff_x_atq / $max_x) * $DetailJoueur[3])/100) *  (1+( $DetailJoueur[3] * 2 + $DetailJoueur[4] * 3 +  $DetailJoueur[6] * 5 )/1000 )*(1+ ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500))/6;		
		$JprobaDef = (($bonus_x_def*2 )* (1+$formeMatch) *(1+ (($diff_x_def / $max_x) * $DetailJoueur[3])/100 )* (1+ ( $DetailJoueur[3] * 2+ $DetailJoueur[4] * 3 +   $DetailJoueur[6] * 5)/1000) * (1+($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500))/6;		
		
		if (@$joueur[2] < $gch_y){
			#le joueur est à gauche
			$bonus_y =   ((($diff_gch_y / $max_y)* $DetailJoueur[12])/100);
			#Cacul des stats pour gauche (avec bonus) et droite et centre			
			$JprobaRecup_gch = ( $JprobaRecup * 3 *( 1+ $bonus_y))/4;
			$JprobaRecup_drt =  $JprobaRecup;
			$JprobaRecup_ctr = ($JprobaRecup * (1 + $bonus_y))/2 ;		
			
			$JprobaConserv_gch = ($JprobaConserv * 3 *(1+ $bonus_y))/4;
			$JprobaConserv_drt = $JprobaConserv;
			$JprobaConserv_ctr = ($JprobaConserv * (1+ $bonus_y))/2;	
						
			$JprobaAtq_gch = ($JprobaAtq * 3 * ( (1 + $bonus_y) * ($DetailJoueur[6]/100)))/4 ;
			$JprobaAtq_drt = $JprobaAtq;
			$JprobaAtq_ctr = ($JprobaAtq * (1 + $bonus_y))/2;			
			
			$JprobaDef_gch = ($JprobaDef * 3 *( (1+ $bonus_y) * ($DetailJoueur[6]/100)))/4 ;
			$JprobaDef_drt = $JprobaDef;
			$JprobaDef_ctr = ($JprobaDef * (1 + $bonus_y))/2;
		}
		else{
			if (@$joueur[2] > $drt_y){
				#le joueur est à droite
				$bonus_y =  ((($diff_drt_y / $max_y)* $DetailJoueur[10])/100);			
				$JprobaRecup_gch = $JprobaRecup;
				$JprobaRecup_drt = ( $JprobaRecup * 3 *( 1+ $bonus_y))/4;
				$JprobaRecup_ctr = ($JprobaRecup * (1 + $bonus_y))/2 ;	
				
				$JprobaConserv_drt = ($JprobaConserv * 3 *(1+ $bonus_y))/4;
				$JprobaConserv_gch = $JprobaConserv;
				$JprobaConserv_ctr = ($JprobaConserv * (1+ $bonus_y))/2;			
				
				$JprobaAtq_gch = $JprobaAtq ;
				$JprobaAtq_drt = ($JprobaAtq * 3 * ( (1 + $bonus_y )* ($DetailJoueur[6]/100)))/4 ;
				$JprobaAtq_ctr = ($JprobaAtq * (1 + $bonus_y))/2;	
				
				$JprobaDef_gch =$JprobaDef ;
				$JprobaDef_drt = ($JprobaDef * 3 *(( 1+ $bonus_y) * ($DetailJoueur[6]/100)))/4 ;
				$JprobaDef_ctr = ($JprobaDef * (1 + $bonus_y))/2;		
			}
			else
			{
				#le joueur joue au centre	
				$bonus_y = 1 -((( $diff_y / $max_y )* $DetailJoueur[11])/100);		
				$JprobaRecup_gch = ($JprobaRecup * (1+ $bonus_y))/2;
				$JprobaRecup_drt = ($JprobaRecup * (1+ $bonus_y))/2;
				$JprobaRecup_ctr = ($JprobaRecup * 2 *(1+ $bonus_y))/3 ;				
			
				$JprobaConserv_ctr = ($JprobaConserv  * 2 *(1+ $bonus_y))/3 ;
				$JprobaConserv_gch = ($JprobaConserv * (1+ $bonus_y ))/2;
				$JprobaConserv_drt =  ($JprobaConserv * (1+ $bonus_y ))/2;				
			
				$JprobaAtq_gch =  ($JprobaAtq * ( (1+ $bonus_y )* $DetailJoueur[6]/100))/2;
				$JprobaAtq_drt =  ($JprobaAtq * ( (1+$bonus_y) * $DetailJoueur[6]/100))/2;
				$JprobaAtq_ctr =  ($JprobaAtq * 2* (1+$bonus_y))/3;
			
				$JprobaDef_gch =  ($JprobaDef *( (1+ $bonus_y )* $DetailJoueur[6]/100))/2;
				$JprobaDef_drt =  ($JprobaDef *( (1+ $bonus_y) * $DetailJoueur[6]/100))/2;
				$JprobaDef_ctr =  ($JprobaDef * 2 * (1+$bonus_y))/3;
			
			}
		}
		#Gardien
		if (@$joueur[1]  < $Pos_x_min){
			$E1probaGardien =(  (1+ $bonus_x_def*2) * (1+ $bonus_y*2) * (1+ (($diff_x_def/ $max_x) * $DetailJoueur[3])/100 ) * (1+ $formeMatch) * (1+ ( $DetailJoueur[5] * 2+ $DetailJoueur[4] * 3 +  $DetailJoueur[1] * 2 +  $DetailJoueur[7] * 4)/1100) * (1+ ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500)) /7;		 
			$E1Gardien = @$joueur[0] ;
			$Pos_x_min = @$joueur[1];
#			print "\n Gardien : $E1probaGardien \n";
		}
		
	print "Joueur n° @$joueur[0] : @$joueur[1], @$joueur[2] \n Bonus x: $bonus_x | x_def : $bonus_x_def | x_atq : $bonus_x_atq | y: $bonus_y\n Recup : $JprobaRecup_gch | $JprobaRecup_ctr | $JprobaRecup_drt \n Conserv : $JprobaConserv_gch | $JprobaConserv_ctr | $JprobaConserv_drt \n Def : $JprobaDef_gch  | $JprobaDef_ctr | $JprobaDef_drt \n Atq : $JprobaAtq_gch  | $JprobaAtq_ctr  | $JprobaAtq_drt \n\n";
		$E1probaRecup_gch += $JprobaRecup_gch ;
		$E1probaRecup_drt += $JprobaRecup_drt;
		$E1probaRecup_ctr += $JprobaRecup_ctr;
		push @E1probaRecup_gch_tab , $JprobaRecup_gch;
		push @E1probaRecup_drt_tab , $JprobaRecup_drt;
		push @E1probaRecup_ctr_tab , $JprobaRecup_ctr;	
		
		$E1probaConserv_gch += $JprobaConserv_gch ;
		$E1probaConserv_drt += $JprobaConserv_drt;
		$E1probaConserv_ctr += $JprobaConserv_ctr;
		push @E1probaConserv_gch_tab , $JprobaConserv_gch;
		push @E1probaConserv_drt_tab , $JprobaConserv_drt;
		push @E1probaConserv_ctr_tab , $JprobaConserv_ctr;	
		
		$E1probaAtq_gch += $JprobaAtq_gch ;
		$E1probaAtq_drt += $JprobaAtq_drt;
		$E1probaAtq_ctr += $JprobaAtq_ctr;
		push @E1probaAtq_gch_tab , $JprobaAtq_gch;
		push @E1probaAtq_drt_tab , $JprobaAtq_drt;
		push @E1probaAtq_ctr_tab , $JprobaAtq_ctr;	
		
		$E1probaDef_gch += $JprobaDef_gch ;
		$E1probaDef_drt += $JprobaDef_drt;
		$E1probaDef_ctr += $JprobaDef_ctr;
		push @E1probaDef_gch_tab , $JprobaDef_gch;
		push @E1probaDef_drt_tab , $JprobaDef_drt;
		push @E1probaDef_ctr_tab , $JprobaDef_ctr;	
		
		#Debug purpose
		push @E1probaDef_tab , $JprobaDef;	
		push @E1probaAtq_tab , $JprobaAtq;	
		push @E1probaConserv_tab , $JprobaConserv;
		push @E1probaRecup_tab , $JprobaRecup;
		
		#### La fatigue mental et physique.
		#1 xp,
		#5 physique,
		#7 mental,
		#13 cond,
		#15 moral	
		push @E1xp_tab, $DetailJoueur[1];
		push @E1physique_tab , $DetailJoueur[5];
		push @E1mental_tab, $DetailJoueur[7];
		push @E1cond_tab, $DetailJoueur[13];
		push @E1moral_tab, $DetailJoueur[15];		
		
	}
	$E1probaRecup_gch = $E1probaRecup_gch /11 ;
	$E1probaRecup_drt = $E1probaRecup_drt/11;
	$E1probaRecup_ctr = $E1probaRecup_ctr /11;
	print "\n Recup :   $E1probaRecup_gch	| $E1probaRecup_ctr	| $E1probaRecup_drt \n";
	
	$E1probaConserv_gch = $E1probaConserv_gch /11 ;
	$E1probaConserv_drt = $E1probaConserv_drt/11;
	$E1probaConserv_ctr = $E1probaConserv_ctr /11;
	print " Conserv :  $E1probaConserv_gch	| $E1probaConserv_ctr	| $E1probaConserv_drt \n";
	
	$E1probaAtq_gch = $E1probaAtq_gch /11 ;
	$E1probaAtq_drt = $E1probaAtq_drt/11;
	$E1probaAtq_ctr = $E1probaAtq_ctr /11;
	print " Atq :  $E1probaAtq_gch	| $E1probaAtq_ctr	| $E1probaAtq_drt \n";
	
	$E1probaDef_gch = $E1probaDef_gch /11 ;
	$E1probaDef_drt = $E1probaDef_drt/11;
	$E1probaDef_ctr = $E1probaDef_ctr /11;
	print " Def :  $E1probaDef_gch	| $E1probaDef_ctr	| $E1probaDef_drt \n";
	
	
	print " \n\n		----------------------------------------           Equipe 2		----------------------------------- \n";
		$Pos_x_min = $max_x;
		
		
	foreach my $joueur (@listePosition2){
		$stJoueur->execute(@$joueur[0]);
		@DetailJoueur = $stJoueur->fetchrow_array;
		my $formeMatch = ($DetailJoueur[13] + $DetailJoueur[15] + $DetailJoueur[2]  +rand(50) + 50) / 400;		
		my $multipl_bonus =0;
		#Calcul des bonus de "bon" positionnement des joueurs
		my $bonus_x =0;
		my $bonus_x_atq=0;
		my $bonus_x_def=0;
		my $bonus_y =0; 
		my $diff_x = abs($mid_x - @$joueur[1]);#min
		my $diff_x_def = $max_x - @$joueur[1];#max
		my $diff_x_atq = @$joueur[1] - $min_x ;#max
		my $diff_y = abs($mid_y - @$joueur[2]);#min
		my $diff_gch_y = abs($gch_y - @$joueur[2]);#max
		my $diff_drt_y = abs($drt_y - @$joueur[2]);#max
		
		$bonus_x_atq = ((($diff_x_atq / $max_x))* $DetailJoueur[8]) / 100;
		$bonus_x_def = ((($diff_x_def / $max_x))* $DetailJoueur[9]) / 100;
			
		if (@$joueur[1] > $mid_x){
			$bonus_x =  ((1 - ($diff_x / $max_x)) * $DetailJoueur[8]) / 100;
		}
		else
		{
			$bonus_x =  ((1 - ($diff_x / $max_x)) * $DetailJoueur[9])/ 100;
		}
		
		$JprobaRecup = (($bonus_x*2 )* (1+$formeMatch )* (1+(1-($diff_x / $max_x) * $DetailJoueur[3])/100 )* (1+ ( $DetailJoueur[3] * 3 + $DetailJoueur[5]*2 + $DetailJoueur[4] )/600 ) * (1+ ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500)) / 6;		
		$JprobaConserv = (($bonus_x*2) *(1+ $formeMatch )* (1+(1-($diff_x / $max_x) * $DetailJoueur[3])/100) *  (1+( $DetailJoueur[3] * 2+ $DetailJoueur[4] * 3 )/500) * (1+($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500))/6;		
		$JprobaAtq = (($bonus_x_atq*2) * (1+$formeMatch) * (1+(($diff_x_atq / $max_x) * $DetailJoueur[3])/100) *  (1+( $DetailJoueur[3] * 2 + $DetailJoueur[4] * 3 +  $DetailJoueur[6] * 5 )/1000 )*(1+ ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500))/6;		
		$JprobaDef = (($bonus_x_def*2 )* (1+$formeMatch) *(1+ (($diff_x_def / $max_x) * $DetailJoueur[3])/100 )* (1+ ( $DetailJoueur[3] * 2+ $DetailJoueur[4] * 3 +   $DetailJoueur[6] * 5)/1000) * (1+($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500))/6;		
		
		if (@$joueur[2] < $gch_y){
			#le joueur est à gauche
			$bonus_y =   ((($diff_gch_y / $max_y)* $DetailJoueur[12])/100);
			#Cacul des stats pour gauche (avec bonus) et droite et centre			
			$JprobaRecup_gch = ( $JprobaRecup * 3 *( 1+ $bonus_y))/4;
			$JprobaRecup_drt =  $JprobaRecup;
			$JprobaRecup_ctr = ($JprobaRecup * (1 + $bonus_y))/2 ;		
			
			$JprobaConserv_gch = ($JprobaConserv * 3 *(1+ $bonus_y))/4;
			$JprobaConserv_drt = $JprobaConserv;
			$JprobaConserv_ctr = ($JprobaConserv * (1+ $bonus_y))/2;	
						
			$JprobaAtq_gch = ($JprobaAtq * 3 * ( (1 + $bonus_y) * ($DetailJoueur[6]/100)))/4 ;
			$JprobaAtq_drt = $JprobaAtq;
			$JprobaAtq_ctr = ($JprobaAtq * (1 + $bonus_y))/2;			
			
			$JprobaDef_gch = ($JprobaDef * 3 *( (1+ $bonus_y) * ($DetailJoueur[6]/100)))/4 ;
			$JprobaDef_drt = $JprobaDef;
			$JprobaDef_ctr = ($JprobaDef * (1 + $bonus_y))/2;
		}
		else{
			if (@$joueur[2] > $drt_y){
				#le joueur est à droite
				$bonus_y =  ((($diff_drt_y / $max_y)* $DetailJoueur[10])/100);			
				$JprobaRecup_gch = $JprobaRecup;
				$JprobaRecup_drt = ( $JprobaRecup * 3 *( 1+ $bonus_y))/4;
				$JprobaRecup_ctr = ($JprobaRecup * (1 + $bonus_y))/2 ;	
				
				$JprobaConserv_drt = ($JprobaConserv * 3 *(1+ $bonus_y))/4;
				$JprobaConserv_gch = $JprobaConserv;
				$JprobaConserv_ctr = ($JprobaConserv * (1+ $bonus_y))/2;			
				
				$JprobaAtq_gch = $JprobaAtq ;
				$JprobaAtq_drt = ($JprobaAtq * 3 * ( (1 + $bonus_y )* ($DetailJoueur[6]/100)))/4 ;
				$JprobaAtq_ctr = ($JprobaAtq * (1 + $bonus_y))/2;	
				
				$JprobaDef_gch =$JprobaDef ;
				$JprobaDef_drt = ($JprobaDef * 3 *(( 1+ $bonus_y) * ($DetailJoueur[6]/100)))/4 ;
				$JprobaDef_ctr = ($JprobaDef * (1 + $bonus_y))/2;		
			}
			else
			{
				#le joueur joue au centre	
				$bonus_y = 1 -((( $diff_y / $max_y )* $DetailJoueur[11])/100);		
				$JprobaRecup_gch = ($JprobaRecup * (1+ $bonus_y))/2;
				$JprobaRecup_drt = ($JprobaRecup * (1+ $bonus_y))/2;
				$JprobaRecup_ctr = ($JprobaRecup * 2 *(1+ $bonus_y))/3 ;				
			
				$JprobaConserv_ctr = ($JprobaConserv  * 2 *(1+ $bonus_y))/3 ;
				$JprobaConserv_gch = ($JprobaConserv * (1+ $bonus_y ))/2;
				$JprobaConserv_drt =  ($JprobaConserv * (1+ $bonus_y ))/2;				
			
				$JprobaAtq_gch =  ($JprobaAtq * ( (1+ $bonus_y )* $DetailJoueur[6]/100))/2;
				$JprobaAtq_drt =  ($JprobaAtq * ( (1+$bonus_y) * $DetailJoueur[6]/100))/2;
				$JprobaAtq_ctr =  ($JprobaAtq * 2* (1+$bonus_y))/3;
			
				$JprobaDef_gch =  ($JprobaDef *( (1+ $bonus_y )* $DetailJoueur[6]/100))/2;
				$JprobaDef_drt =  ($JprobaDef *( (1+ $bonus_y) * $DetailJoueur[6]/100))/2;
				$JprobaDef_ctr =  ($JprobaDef * 2 * (1+$bonus_y))/3;		
			}
		}
		#Gardien
		if (@$joueur[1]  < $Pos_x_min){
			$E2probaGardien =(  (1+ $bonus_x_def*2) * (1+ $bonus_y*2) * (1+ ( ($diff_x_def/ $max_x) * $DetailJoueur[3])/100 ) * (1+ $formeMatch) * (1+ ( $DetailJoueur[5] * 2+ $DetailJoueur[4] * 3 +  $DetailJoueur[1] * 2 +  $DetailJoueur[7] * 4)/1100) * (1+ ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500)) /7;		 
			$E2Gardien = @$joueur[0] ;
			$Pos_x_min = @$joueur[1];
#			print "\n Gardien : $E2probaGardien \n";
		}
		
		print "Joueur n° @$joueur[0] : @$joueur[1], @$joueur[2] \n Bonus x: $bonus_x | x_def : $bonus_x_def | x_atq : $bonus_x_atq | y: $bonus_y\n Recup : $JprobaRecup_gch | $JprobaRecup_ctr | $JprobaRecup_drt \n Conserv : $JprobaConserv_gch | $JprobaConserv_ctr | $JprobaConserv_drt \n Def : $JprobaDef_gch  | $JprobaDef_ctr | $JprobaDef_drt \n Atq : $JprobaAtq_gch  | $JprobaAtq_ctr  | $JprobaAtq_drt \n\n";
		$E2probaRecup_gch += $JprobaRecup_gch ;
		$E2probaRecup_drt += $JprobaRecup_drt;
		$E2probaRecup_ctr += $JprobaRecup_ctr;
		push @E2probaRecup_gch_tab , $JprobaRecup_gch;
		push @E2probaRecup_drt_tab , $JprobaRecup_drt;
		push @E2probaRecup_ctr_tab , $JprobaRecup_ctr;	
		
		$E2probaConserv_gch += $JprobaConserv_gch ;
		$E2probaConserv_drt += $JprobaConserv_drt;
		$E2probaConserv_ctr += $JprobaConserv_ctr;
		push @E2probaConserv_gch_tab , $JprobaConserv_gch;
		push @E2probaConserv_drt_tab , $JprobaConserv_drt;
		push @E2probaConserv_ctr_tab , $JprobaConserv_ctr;	
		
		$E2probaAtq_gch += $JprobaAtq_gch ;
		$E2probaAtq_drt += $JprobaAtq_drt;
		$E2probaAtq_ctr += $JprobaAtq_ctr;
		push @E2probaAtq_gch_tab , $JprobaAtq_gch;
		push @E2probaAtq_drt_tab , $JprobaAtq_drt;
		push @E2probaAtq_ctr_tab , $JprobaAtq_ctr;	
		
		$E2probaDef_gch += $JprobaDef_gch ;
		$E2probaDef_drt += $JprobaDef_drt;
		$E2probaDef_ctr += $JprobaDef_ctr;
		push @E2probaDef_gch_tab , $JprobaDef_gch;
		push @E2probaDef_drt_tab , $JprobaDef_drt;
		push @E2probaDef_ctr_tab , $JprobaDef_ctr;	
		
		#Debug purpose
		push @E2probaDef_tab , $JprobaDef;	
		push @E2probaAtq_tab , $JprobaAtq;	
		push @E2probaConserv_tab , $JprobaConserv;
		push @E2probaRecup_tab , $JprobaRecup;		
		
			#### La fatigue mental et physique.
		#1 xp,
		#5 physique,
		#7 mental,
		#13 cond,
		#15 moral	
		push @E2xp_tab, $DetailJoueur[1];
		push @E2physique_tab , $DetailJoueur[5];
		push @E2mental_tab, $DetailJoueur[7];
		push @E2cond_tab, $DetailJoueur[13];
		push @E2moral_tab, $DetailJoueur[15];	
		
	}
	$E2probaRecup_gch = $E2probaRecup_gch /11 ;
	$E2probaRecup_drt = $E2probaRecup_drt/11;
	$E2probaRecup_ctr = $E2probaRecup_ctr /11;
	print "\n Recup :   $E2probaRecup_gch	| $E2probaRecup_ctr	| $E2probaRecup_drt \n";
	
	$E2probaConserv_gch = $E2probaConserv_gch /11 ;
	$E2probaConserv_drt = $E2probaConserv_drt/11;
	$E2probaConserv_ctr = $E2probaConserv_ctr /11;
	print " Conserv :  $E2probaConserv_gch	| $E2probaConserv_ctr	| $E2probaConserv_drt \n";
	
	$E2probaAtq_gch = $E2probaAtq_gch /11 ;
	$E2probaAtq_drt = $E2probaAtq_drt/11;
	$E2probaAtq_ctr = $E2probaAtq_ctr /11;
	print " Atq :  $E2probaAtq_gch	| $E2probaAtq_ctr	| $E2probaAtq_drt \n";
	
	$E2probaDef_gch = $E2probaDef_gch /11 ;
	$E2probaDef_drt = $E2probaDef_drt/11;
	$E2probaDef_ctr = $E2probaDef_ctr /11;
	print " Def :  $E2probaDef_gch	| $E2probaDef_ctr	| $E2probaDef_drt \n";
	
	#Repartition des ballons joues
	
	print "\n\n  =======================================		Les ballons jouées		========================================\n\n";
	
	my $unite_ballon =0;
	my $E1diffConserv_ctr =0;
	my $E2diffConserv_ctr =0;
	my $E1ballonConserv_ctr =0;
	my $E2ballonConserv_ctr =0;
	
	my $E1diffConserv_drt =0;
	my $E2diffConserv_drt =0;
	my $E1ballonConserv_drt =0;
	my $E2ballonConserv_drt =0;
	
	my $E1diffConserv_gch =0;
	my $E2diffConserv_gch =0;
	my $E1ballonConserv_gch =0;
	my $E2ballonConserv_gch =0;
	
	my $nb_ballon_cote = $nb_ballon /2;
	
	my $E1ballonOff_ctr =0;
	my $E1ballonOff_drt =0;
	my $E1ballonOff_gch =0;
	
	my $E2ballonOff_ctr =0;
	my $E2ballonOff_drt =0;
	my $E2ballonOff_gch =0;
		
	#=============
	
	my $E1diffAtq_ctr =0;
	my $E2diffAtq_ctr =0;
	my $E1ballonAtq_ctr =0;
	my $E2ballonAtq_ctr =0;
	
	my $E1diffAtq_drt =0;
	my $E2diffAtq_drt =0;
	my $E1ballonAtq_drt =0;
	my $E2ballonAtq_drt =0;
	
	my $E1diffAtq_gch =0;
	my $E2diffAtq_gch =0;
	my $E1ballonAtq_gch =0;
	my $E2ballonAtq_gch =0;
	
	my $E1ballonOccaz_ctr =0;
	my $E1ballonOccaz_drt =0;
	my $E1ballonOccaz_gch =0;
	
	my $E2ballonOccaz_ctr =0;
	my $E2ballonOccaz_drt =0;
	my $E2ballonOccaz_gch =0;
	
	#--------------------
	
	my $E1diffOccaz_ctr =0;
	my $E2diffOccaz_ctr =0;
	my $E1ballonOccazTir_ctr =0;
	my $E2ballonOccazTir_ctr =0;
	
	my $E1diffOccaz_drt =0;
	my $E2diffOccaz_drt =0;
	my $E1ballonOccazTir_drt =0;
	my $E2ballonOccazTir_drt =0;
	
	my $E1diffOccaz_gch =0;
	my $E2diffOccaz_gch =0;
	my $E1ballonOccazTir_gch =0;
	my $E2ballonOccazTir_gch =0;
	
	my $E1ballonTir_ctr =0;
	my $E1ballonTir_drt =0;
	my $E1ballonTir_gch =0;
	
	my $E2ballonTir_ctr =0;
	my $E2ballonTir_drt =0;
	my $E2ballonTir_gch =0;
	
	
	
	#$E1diffConserv_ctr = ($E1probaConserv_ctr - $E2probaRecup_ctr)*100;
	#$E2diffConserv_ctr = ($E2probaConserv_ctr - $E1probaRecup_ctr)*100;
	$E1diffConserv_ctr = ($E1probaConserv_ctr*100) / ( $E2probaRecup_ctr*100);
	$E2diffConserv_ctr = ($E2probaConserv_ctr*100) / ( $E1probaRecup_ctr*100);
	$unite_ballon = $nb_ballon / (abs($E1diffConserv_ctr) + abs($E2diffConserv_ctr));
	$E1ballonConserv_ctr = int (abs($unite_ballon * $E1diffConserv_ctr) );
	$E2ballonConserv_ctr = int(abs($unite_ballon * $E2diffConserv_ctr) );
	print "CENTRE : $E1ballonConserv_ctr ballons /Equipe1 ($E1diffConserv_ctr)| $E2ballonConserv_ctr ballons /Equipe2($E2diffConserv_ctr)  sur $nb_ballon \n";
	
	$E1diffConserv_drt = ($E1probaConserv_drt*100) / ( $E2probaRecup_gch*100);
	$E2diffConserv_gch= ($E2probaConserv_gch*100) / ( $E1probaRecup_drt*100);
	$unite_ballon = $nb_ballon_cote / (abs($E1diffConserv_drt) + abs($E2diffConserv_gch));
	$E1ballonConserv_drt = int (abs($unite_ballon * $E1diffConserv_drt) );
	$E2ballonConserv_gch = int(abs($unite_ballon * $E2diffConserv_gch) );
	print "DROITE $E1ballonConserv_drt ballons /Equipe1 ($E1diffConserv_drt)| $E2ballonConserv_gch ballons /Equipe2($E2diffConserv_gch)  sur $nb_ballon_cote \n";
	
	$E1diffConserv_gch = ($E1probaConserv_gch*100) / ( $E2probaRecup_drt*100);
	$E2diffConserv_drt= ($E2probaConserv_drt*100) / ( $E1probaRecup_gch*100);
	$unite_ballon = $nb_ballon_cote/ (abs($E1diffConserv_gch) + abs($E2diffConserv_drt));
	$E1ballonConserv_gch = int (abs($unite_ballon * $E1diffConserv_gch) );
	$E2ballonConserv_drt = int(abs($unite_ballon * $E2diffConserv_drt) );
	print "GAUCHE $E1ballonConserv_gch ballons /Equipe1 ($E1diffConserv_gch)| $E2ballonConserv_drt ballons /Equipe2($E2diffConserv_drt)  sur $nb_ballon_cote \n";

    $E1ballonOff_ctr = int ($E1ballonConserv_ctr /3 + $E1ballonConserv_gch /4 + $E1ballonConserv_drt /4 ); 
    $E1ballonOff_drt = int ($E1ballonConserv_ctr /3 + $E1ballonConserv_gch /4 + $E1ballonConserv_drt /2 ); 
	$E1ballonOff_gch = int ($E1ballonConserv_ctr /3 + $E1ballonConserv_gch /2 + $E1ballonConserv_drt /4 );
	
	$E2ballonOff_ctr = int ($E2ballonConserv_ctr /3 + $E2ballonConserv_gch /4 + $E2ballonConserv_drt /4 ); 
    $E2ballonOff_drt = int ($E2ballonConserv_ctr /3 + $E2ballonConserv_gch /4 + $E2ballonConserv_drt /2 ); 
	$E2ballonOff_gch = int ($E2ballonConserv_ctr /3 + $E2ballonConserv_gch /2 + $E2ballonConserv_drt /4 );
	
	print "\n*********************************** Ballon d'attaque  ***************************************************\n";
	print "*		Equipe 1 : $E1ballonOff_gch		|		$E1ballonOff_ctr		|		$E1ballonOff_drt		*\n";
	print "*		Equipe 2 : $E2ballonOff_gch		|		$E2ballonOff_ctr		|		$E2ballonOff_drt		*\n";
	print "*********************************************************************************************************\n";

	$E1diffAtq_ctr = ($E1probaAtq_ctr*100) / ( $E2probaDef_ctr*100 + $E2probaRecup_ctr*100);
	$E2diffAtq_ctr = ($E2probaAtq_ctr*100) / ( $E1probaDef_ctr*100 + $E2probaRecup_ctr*100);
	$unite_ballon = $E1ballonOff_ctr/ (abs($E1diffAtq_ctr) + abs($E2diffAtq_ctr));
	$E1ballonAtq_ctr = int (abs($unite_ballon * $E1diffAtq_ctr) );
	$unite_ballon = $E2ballonOff_ctr/ (abs($E1diffAtq_ctr) + abs($E2diffAtq_ctr));
	$E2ballonAtq_ctr = int(abs($unite_ballon * $E2diffAtq_ctr) );
	print "ATTAQUE CENTRE : $E1ballonAtq_ctr ballons /Equipe1 ($E1diffAtq_ctr) sur $E1ballonOff_ctr	 | $E2ballonAtq_ctr ballons /Equipe2($E2diffAtq_ctr)  sur $E2ballonOff_ctr	 \n";
		
	$E1diffAtq_drt = ($E1probaAtq_drt*100) / ( $E2probaDef_gch*100 + $E2probaRecup_gch*100 );
	$E2diffAtq_gch= ($E2probaAtq_gch*100) / ( $E1probaDef_drt*100 + $E2probaRecup_drt*100 );
	$unite_ballon = $E1ballonOff_drt / (abs($E1diffAtq_drt) + abs($E2diffAtq_gch));
	$E1ballonAtq_drt = int (abs($unite_ballon * $E1diffAtq_drt) );
	$unite_ballon = $E2ballonOff_gch	 / (abs($E1diffAtq_drt) + abs($E2diffAtq_gch));
	$E2ballonAtq_gch = int(abs($unite_ballon * $E2diffAtq_gch) );
	print "ATTAQUE DROITE $E1ballonAtq_drt ballons /Equipe1 ($E1diffAtq_drt) sur $E1ballonOff_drt | $E2ballonAtq_gch ballons /Equipe2($E2diffAtq_gch)  sur $E2ballonOff_gch \n";
	
	$E1diffAtq_gch = ($E1probaAtq_gch*100) / ( $E2probaDef_drt*100 + $E2probaRecup_drt*100 );
	$E2diffAtq_drt= ($E2probaAtq_drt*100) / ( $E1probaDef_gch*100 + $E2probaRecup_gch*100 );
	$unite_ballon = $E1ballonOff_gch / (abs($E1diffAtq_gch) + abs($E2diffAtq_drt));
	$E1ballonAtq_gch = int (abs($unite_ballon * $E1diffAtq_gch) );
	$unite_ballon = $E2ballonOff_drt	 / (abs($E1diffAtq_gch) + abs($E2diffAtq_drt));
	$E2ballonAtq_drt = int(abs($unite_ballon * $E2diffAtq_drt) );
	print "ATTAQUE GAUCHE $E1ballonAtq_gch ballons /Equipe1 ($E1diffAtq_gch) sur $E1ballonOff_gch	 | $E2ballonAtq_drt ballons /Equipe2($E2diffAtq_drt)  sur $E2ballonOff_drt \n";
	 
	$E1ballonOccaz_ctr = int ($E1ballonAtq_ctr /2 + $E1ballonAtq_gch /3 + $E1ballonAtq_drt /3 ); 
    $E1ballonOccaz_drt = int ($E1ballonAtq_ctr /4 + $E1ballonAtq_gch /6 + $E1ballonAtq_drt /2 ); 
	$E1ballonOccaz_gch = int ($E1ballonAtq_ctr /4 + $E1ballonAtq_gch /2 + $E1ballonAtq_drt /6 );
	
	$E2ballonOccaz_ctr = int ($E2ballonAtq_ctr /2 + $E2ballonAtq_gch /3 + $E2ballonAtq_drt /3 ); 
    $E2ballonOccaz_drt = int ($E2ballonAtq_ctr /4 + $E2ballonAtq_gch /6 + $E2ballonAtq_drt /2 ); 
	$E2ballonOccaz_gch = int ($E2ballonAtq_ctr /4 + $E2ballonAtq_gch /2 + $E2ballonAtq_drt /6 );
	
	print "\n***********************************   Ballon d'occaz   ***************************************************\n";
	print "*		Equipe 1 : $E1ballonOccaz_gch		|		$E1ballonOccaz_ctr		|		$E1ballonOccaz_drt		*\n";
	print "*		Equipe 2 : $E2ballonOccaz_gch		|		$E2ballonOccaz_ctr		|		$E2ballonOccaz_drt		*\n";
	print "*********************************************************************************************************\n";

	$E1diffOccaz_ctr = ($E1probaAtq_ctr*100) / ( $E2probaDef_ctr*100 );
	$E2diffOccaz_ctr = ($E2probaAtq_ctr*100) / ( $E1probaDef_ctr*100 );
	$unite_ballon = $E1ballonOccaz_ctr/ (abs($E1diffOccaz_ctr) + abs($E2diffOccaz_ctr));
	$E1ballonOccazTir_ctr = int (abs($unite_ballon * $E1diffOccaz_ctr) );
	$unite_ballon = $E2ballonOccaz_ctr/ (abs($E1diffOccaz_ctr) + abs($E2diffOccaz_ctr));
	$E2ballonOccazTir_ctr = int(abs($unite_ballon * $E2diffOccaz_ctr) );
	print "OCCAZ CENTRE : $E1ballonOccazTir_ctr ballons /Equipe1 ($E1diffOccaz_ctr) sur $E1ballonOccaz_ctr	 | $E2ballonOccazTir_ctr ballons /Equipe2($E2diffOccaz_ctr)  sur $E2ballonOccaz_ctr	 \n";
		
	$E1diffOccaz_drt = ($E1probaAtq_drt*100) / ( $E2probaDef_gch*100  );
	$E2diffOccaz_gch= ($E2probaAtq_gch*100) / ( $E1probaDef_drt*100 );
	$unite_ballon = $E1ballonOccaz_drt / (abs($E1diffOccaz_drt) + abs($E2diffOccaz_gch));
	$E1ballonOccazTir_drt = int (abs($unite_ballon * $E1diffOccaz_drt) );
	$unite_ballon = $E2ballonOccaz_gch	 / (abs($E1diffOccaz_drt) + abs($E2diffOccaz_gch));
	$E2ballonOccazTir_gch = int(abs($unite_ballon * $E2diffOccaz_gch) );
	print "OCCAZ DROITE $E1ballonOccazTir_drt ballons /Equipe1 ($E1diffOccaz_drt) sur $E1ballonOccaz_drt | $E2ballonOccazTir_gch ballons /Equipe2($E2diffOccaz_gch)  sur $E2ballonOccaz_gch \n";
	
	$E1diffOccaz_gch = ($E1probaAtq_gch*100) / ( $E2probaDef_drt*100  );
	$E2diffOccaz_drt= ($E2probaAtq_drt*100) / ( $E1probaDef_gch*100  );
	$unite_ballon = $E1ballonOccaz_gch / (abs($E1diffOccaz_gch) + abs($E2diffOccaz_drt));
	$E1ballonOccazTir_gch = int (abs($unite_ballon * $E1diffOccaz_gch) );
	$unite_ballon = $E2ballonOccaz_drt	 / (abs($E1diffOccaz_gch) + abs($E2diffOccaz_drt));
	$E2ballonOccazTir_drt = int(abs($unite_ballon * $E2diffOccaz_drt) );
	print "OCCAZ GAUCHE $E1ballonOccazTir_gch ballons /Equipe1 ($E1diffOccaz_gch) sur $E1ballonOccaz_gch	 | $E2ballonOccazTir_drt ballons /Equipe2($E2diffOccaz_drt)  sur $E2ballonOccaz_drt \n";
	
	$E1ballonTir_ctr = int ( $E1ballonOccazTir_ctr + $E1ballonOccazTir_gch /2 + $E1ballonOccazTir_drt /2 ); 
    $E1ballonTir_drt = int ( $E1ballonOccazTir_drt /2 ); 
	$E1ballonTir_gch = int ( $E1ballonOccazTir_gch /2 );
	
	$E2ballonTir_ctr = int ($E2ballonOccazTir_ctr + $E2ballonOccazTir_gch /2 + $E2ballonOccazTir_drt /2 ); 
    $E2ballonTir_drt = int ($E2ballonOccazTir_drt /2 ); 
	$E2ballonTir_gch = int ($E2ballonOccazTir_gch /2 );
	
	print "\n***********************************   Ballon d'Tir   ***************************************************\n";
	print "*		Equipe 1 : $E1ballonTir_gch		|		$E1ballonTir_ctr		|		$E1ballonTir_drt		*\n";
	print "*		Equipe 2 : $E2ballonTir_gch		|		$E2ballonTir_ctr		|		$E2ballonTir_drt		*\n";
	print "*********************************************************************************************************\n";
	
	my @E1nb_tir_ctr = ();
	my @E1nb_tir_gch = ();
	my @E1nb_tir_drt = ();
	
	my @E2nb_tir_ctr = ();
	my @E2nb_tir_gch = ();
	my @E2nb_tir_drt = ();
	
	my $E1But = 0;
	my $E2But = 0;
	### les tir au but
	
	my $unite_tir=0;
	$unite_tir =    $E1ballonTir_ctr /($E1probaAtq_ctr*11 );
	foreach my $tir (@E1probaAtq_ctr_tab){
		push @E1nb_tir_ctr, int($tir* $unite_tir);
	}
	$unite_tir =    $E1ballonTir_drt /($E1probaAtq_drt*11 );
	foreach my $tir (@E1probaAtq_drt_tab){
		push @E1nb_tir_drt, int($tir* $unite_tir);
	}
	$unite_tir =    $E1ballonTir_gch /($E1probaAtq_gch*11 );
	foreach my $tir (@E1probaAtq_gch_tab){
		push @E1nb_tir_gch, int($tir* $unite_tir);
	}
			
	$unite_tir =    $E2ballonTir_ctr /($E2probaAtq_ctr*11 );
	foreach my $tir (@E2probaAtq_ctr_tab){
		push @E2nb_tir_ctr, int($tir* $unite_tir);
	}
	$unite_tir =    $E2ballonTir_drt /($E2probaAtq_drt*11 );
	foreach my $tir (@E2probaAtq_drt_tab){
		push @E2nb_tir_drt, int($tir* $unite_tir);
	}
	$unite_tir =    $E2ballonTir_gch /($E2probaAtq_gch*11 );
	foreach my $tir (@E2probaAtq_gch_tab){
		push @E2nb_tir_gch, int($tir* $unite_tir);
	}
	my $probaBut;
	my @E2tirplus = (0,0,0,0,0,0,0,0,0,0,0);
	my @E2tirmoins = (0,0,0,0,0,0,0,0,0,0,0);
	my @E1tirplus = (0,0,0,0,0,0,0,0,0,0,0);
	my @E1tirmoins = (0,0,0,0,0,0,0,0,0,0,0);
	my @E1But = (0,0,0,0,0,0,0,0,0,0,0);
	my @E2But = (0,0,0,0,0,0,0,0,0,0,0);
	
	print "\n Gardien : $E1probaGardien   $E2probaGardien \n";
	for (my $i = 0; $i<11; $i++){
		for (my $j = 0; $j< $E1nb_tir_ctr[$i]; $j++){
			$probaBut =  (($E1probaAtq_ctr_tab[$i] *100) / ($E2probaGardien *100));
			#$probaBut = rand ($E1probaAtq_ctr_tab[$i] *100);
			my $tir = rand($probaBut);
			if ($tir * $E1probaAtq_ctr_tab[$i] > $E2probaDef_ctr * 0.3){
				$E1tirplus[$i] += 1;
				if ($tir > rand($E2probaGardien)){
					$E1But ++;
					$E1But[$i] += 1; 
				}	
			}
			else{
				$E1tirmoins[$i] += 1;
			}
		
		}
		for (my $j = 0; $j< $E1nb_tir_drt[$i]; $j++){
			$probaBut =  (($E1probaAtq_drt_tab[$i] *100) / ($E2probaGardien *100));
			#$probaBut = rand ($E1probaAtq_drt_tab[$i] *100);
			my $tir = rand($probaBut);
			if ($tir * $E1probaAtq_drt_tab[$i]> $E2probaDef_gch * 0.5){
				$E1tirplus[$i] += 1;
				if ($tir > rand($E2probaGardien)){
					$E1But ++;
					$E1But[$i] += 1; 
				}
			}
			else{
				$E1tirmoins[$i] += 1;
			}
			
		}
		for (my $j = 0; $j< $E1nb_tir_gch[$i]; $j++){
			$probaBut =  (($E1probaAtq_gch_tab[$i] *100) / ($E2probaGardien *100));
		#	$probaBut = rand ($E1probaAtq_gch_tab[$i] *100);
			my $tir = rand($probaBut);
			if ($tir * $E1probaAtq_gch_tab[$i]  > $E2probaDef_drt * 0.5){
				$E1tirplus[$i] += 1;
				if ($tir > rand($E2probaGardien)){
					$E1But ++;
					$E1But[$i] += 1; 
				}	
			}
			else{
				$E1tirmoins[$i] += 1;
			}
			
		}
		
		for (my $j = 0; $j< $E2nb_tir_ctr[$i]; $j++){
			$probaBut =  (($E2probaAtq_ctr_tab[$i] *100) / ($E1probaGardien *100));
			#$probaBut = rand ($E2probaAtq_ctr_tab[$i] *100);
			my $tir = rand($probaBut);
			if ($tir * $E2probaAtq_ctr_tab[$i] > $E1probaDef_ctr * 0.3){
				$E2tirplus[$i] += 1;
				if ($tir > rand($E1probaGardien/2)){
					$E2But ++;
					$E2But[$i] += 1; 
				}	
			}
			else{
				$E2tirmoins[$i] += 1;
			}
			
		}
		for (my $j = 0; $j< $E2nb_tir_drt[$i]; $j++){
			$probaBut =  (($E2probaAtq_drt_tab[$i] *100) / ($E1probaGardien *100));
#			$probaBut = rand ($E2probaAtq_drt_tab[$i] *100);
			my $tir = rand($probaBut);
			if ($tir*$E2probaAtq_drt_tab[$i] > $E1probaDef_gch* 0.5){
				$E2tirplus[$i] += 1;
				if ($tir > rand($E1probaGardien)){
					$E2But ++;
					$E2But[$i] += 1; 
				}
			}
			else{
				$E2tirmoins[$i] += 1;
			}
			
		}
		for (my $j = 0; $j< $E2nb_tir_gch[$i]; $j++){
			$probaBut =  (($E2probaAtq_gch_tab[$i] *100) / ($E1probaGardien *100));
			#$probaBut = rand ($E2probaAtq_gch_tab[$i] *100);
			my $tir = rand($probaBut);
			if ($tir * $E2probaAtq_gch_tab[$i]> $E1probaDef_drt * 0.5){
				$E2tirplus[$i] += 1;
				if ($tir > rand($E1probaGardien)){
					$E2But ++;
					$E2But[$i] += 1; 
				}
			}
			else{
				$E2tirmoins[$i] += 1;
			}
			
		}
	}
	print "\n***********************************   SCORE  ************************************************************\n";
	print "*													*\n";
	print "*			$E1But				||			$E2But			*\n";
	print "*													*\n";
	print "*********************************************************************************************************\n";
	
	$stScore->execute($E1But, $E2But, $match);
	
###################################         Les stats indiv des joueurs        #################################################


my @E1ballonplus = ();
my @E1ballonmoins = ();
my @E1passeplus = ();
my @E1passemoins = ();

my @E1dribleplus = ();
my @E1driblemoins = ();
my @E1tackleplus = ();
my @E1tacklemoins = ();

my @E2ballonplus = ();
my @E2ballonmoins = ();
my @E2passeplus = ();
my @E2passemoins = ();

my @E2dribleplus = ();
my @E2driblemoins = ();
my @E2tackleplus = ();
my @E2tacklemoins = ();

my @E1stat =();
my @E2stat = ();

my $sig = 0.33333;

print "-------------------------- Proba Joueur ------------------ \n";
print  " Equipe 1 \n";
	my $E1unite_Recup_ctr = $E1ballonConserv_ctr / ($E1probaRecup_ctr *11);
	my $E1unite_Conserv_ctr = $E2ballonConserv_ctr / ($E1probaConserv_ctr*11);
	my $E1unite_Recup_drt = $E1ballonConserv_drt / ($E1probaRecup_drt *11);
	my $E1unite_Conserv_drt = $E2ballonConserv_gch / ($E1probaConserv_drt*11); 
	my $E1unite_Recup_gch = $E1ballonConserv_gch / ($E1probaRecup_gch *11);
	my $E1unite_Conserv_gch = $E2ballonConserv_drt / ($E1probaConserv_gch*11); 
	
	my $E1unite_passeplus_ctr = ($E1ballonOff_ctr + $E1ballonConserv_ctr)  / ($E1probaAtq_ctr *11 + $E1probaConserv_ctr*11);
	my $E1unite_passemoins_ctr = (( $E1ballonConserv_ctr *2 + $E1ballonConserv_drt + $E1ballonConserv_gch) - ($E1ballonOff_ctr + $E1ballonOff_drt + $E1ballonOff_gch) )  / ($E1probaAtq_ctr *11 + $E1probaConserv_ctr*11);
	my $E1unite_passeplus_drt = ($E1ballonOff_drt +$E1ballonConserv_drt) / ($E1probaAtq_drt *11 + $E1probaConserv_drt*11);
	my $E1unite_passemoins_drt = (( $E1ballonConserv_ctr +$E1ballonConserv_drt*2 + $E1ballonConserv_gch)- ($E1ballonOff_ctr + $E1ballonOff_drt + $E1ballonOff_gch) ) / ($E1probaAtq_drt *11 + $E1probaConserv_drt*11);
	my $E1unite_passeplus_gch = ($E1ballonOff_gch + $E1ballonConserv_gch) / ($E1probaAtq_gch *11 + $E1probaConserv_gch*11);
	my $E1unite_passemoins_gch = (( $E1ballonConserv_ctr +$E1ballonConserv_drt + $E1ballonConserv_gch *2) - ($E1ballonOff_ctr + $E1ballonOff_drt + $E1ballonOff_gch) ) / ($E1probaAtq_gch *11 + $E1probaConserv_gch*11);
	 
	my $E1unite_dribleplus_ctr = $E1ballonOccaz_ctr/ ($E1probaAtq_ctr *11 );
	my $E1unite_driblemoins_ctr = ( $E1ballonOff_ctr - $E1ballonOccaz_ctr )  / ($E1probaAtq_ctr *11); 
	my $E1unite_dribleplus_drt = $E1ballonOccaz_drt/ ($E1probaAtq_drt *11 );
	my $E1unite_driblemoins_drt = ( $E1ballonOff_drt - $E1ballonOccaz_drt )  / ($E1probaAtq_drt *11); 
	my $E1unite_dribleplus_gch = $E1ballonOccaz_gch/ ($E1probaAtq_gch *11 );
	my $E1unite_driblemoins_gch = ( $E1ballonOff_gch - $E1ballonOccaz_gch )  / ($E1probaAtq_gch *11); 
	
	my $E1unite_tackleplus_ctr = (($E2ballonOccazTir_ctr*2 +$E2ballonOccazTir_drt + $E2ballonOccazTir_gch )  - ($E2ballonTir_ctr + $E2ballonTir_drt + $E2ballonTir_gch) ) / ($E1probaDef_ctr *11 );
	my $E1unite_tacklemoins_ctr = ( $E2ballonTir_ctr )  / ($E1probaDef_ctr *11); 
	my $E1unite_tackleplus_drt = (($E2ballonOccazTir_ctr +$E2ballonOccazTir_drt + $E2ballonOccazTir_gch *2 ) - ($E2ballonTir_ctr + $E2ballonTir_drt + $E2ballonTir_gch) )/ ($E1probaDef_drt *11 );
	my $E1unite_tacklemoins_drt = ( $E2ballonTir_gch)  / ($E1probaDef_drt *11); 
	my $E1unite_tackleplus_gch = (($E2ballonOccazTir_ctr +$E2ballonOccazTir_drt *2 + $E2ballonOccazTir_gch ) - ($E2ballonTir_ctr + $E2ballonTir_drt + $E2ballonTir_gch) )/ ($E1probaDef_gch *11 );
	my $E1unite_tacklemoins_gch = ($E2ballonTir_drt )  / ($E1probaDef_gch *11); 
	
	#my $E1unite_tirplus_ctr = $E1ballonOccaz_ctr/ ($E1probaAtq_ctr *11 );
	#my $E1unite_tirmoins_ctr = ( $E1ballonOff_ctr - $E1ballonOccaz_ctr )  / ($E1probaAtq_ctr *11); 
	#my $E1unite_tirplus_drt = $E1ballonOccaz_drt/ ($E1probaAtq_drt *11 );
	#my $E1unite_tirmoins_drt = ( $E1ballonOff_drt - $E1ballonOccaz_drt )  / ($E1probaAtq_drt *11); 
	#my $E1unite_tirplus_gch = $E1ballonOccaz_gch/ ($E1probaAtq_gch *11 );
	#my $E1unite_tirmoins_gch = ( $E1ballonOff_gch - $E1ballonOccaz_gch )  / ($E1probaAtq_gch *11); 
	
	
	
for (my $i = 0; $i<11; $i++){
	
	my $ballonplus_ctr;
	my $ballonmoins_ctr;
	my $ballonplus_drt;
	my $ballonmoins_drt;
	my $ballonplus_gch;
	my $ballonmoins_gch;
	
	my $passeplus_ctr;
	my $passemoins_ctr;
	my $passeplus_drt;
	my $passemoins_drt;
	my $passeplus_gch;
	my $passemoins_gch;
	
	my $dribleplus_ctr;
	my $driblemoins_ctr;
	my $dribleplus_drt;
	my $driblemoins_drt;
	my $dribleplus_gch;
	my $driblemoins_gch;
	
	my $tackleplus_ctr;
	my $tacklemoins_ctr;
	my $tackleplus_drt;
	my $tacklemoins_drt;
	my $tackleplus_gch;
	my $tacklemoins_gch;
	
	$ballonplus_ctr = int($E1probaRecup_ctr_tab[$i] * $E1unite_Recup_ctr);
	if ($E1probaConserv_ctr_tab[$i] > $sig ){
		$ballonmoins_ctr  =int(((1/$E1probaConserv_ctr_tab[$i]) * $E1unite_Conserv_ctr)/10);		
	}
	else{
		$ballonmoins_ctr =0;
	}

	$ballonplus_drt = int($E1probaRecup_drt_tab[$i] * $E1unite_Recup_drt);
	if ($E1probaConserv_drt_tab[$i] > $sig ){
		$ballonmoins_drt  =int(((1/$E1probaConserv_drt_tab[$i]) * $E1unite_Conserv_drt)/10);		
	}
	else{
		$ballonmoins_drt =0;
	}

	$ballonplus_gch = int($E1probaRecup_gch_tab[$i] * $E1unite_Recup_gch);
	if ($E1probaConserv_gch_tab[$i] > $sig ){
		$ballonmoins_gch  =int(((1/$E1probaConserv_gch_tab[$i]) * $E1unite_Conserv_gch)/10);	
	}
	else{
		$ballonmoins_gch =0;
	}
	print "BALLON : $ballonplus_gch / $ballonmoins_gch | $ballonplus_ctr / $ballonmoins_ctr | $ballonplus_drt / $ballonmoins_drt \n";

	$passeplus_ctr = int(($E1probaConserv_ctr_tab[$i] + $E1probaAtq_ctr_tab[$i]) * $E1unite_passeplus_ctr);
	if ($E1probaConserv_ctr_tab[$i] < $sig && $E1probaAtq_ctr_tab[$i] < $sig){
		$passemoins_ctr  = 0;
	}
	else{
		my $part1;
		my $part2;
		if ($E1probaConserv_ctr_tab[$i] < $sig){
			$part1 =0;
		}
		else{
			$part1= 1/$E1probaConserv_ctr_tab[$i];
		}
		if ($E1probaAtq_ctr_tab[$i] < $sig){
			$part2=0;
		}
		else{
			$part2 = 1/ $E1probaAtq_ctr_tab[$i];
		}
		$passemoins_ctr  =int( (( $part1 + $part2 ) * $E1unite_passemoins_ctr)/10);	
	}
	
	$passeplus_gch = int(($E1probaConserv_gch_tab[$i] + $E1probaAtq_gch_tab[$i]) * $E1unite_passeplus_gch);
	if ($E1probaConserv_gch_tab[$i] < $sig && $E1probaAtq_gch_tab[$i] < $sig){
		$passemoins_gch  = 0;
	}
	else{
		my $part1;
		my $part2;
		if ($E1probaConserv_gch_tab[$i] < $sig){
			$part1 =0;
		}
		else{
			$part1= 1/$E1probaConserv_gch_tab[$i];
		}
		if ($E1probaAtq_gch_tab[$i] < $sig){
			$part2=0;
		}
		else{
			$part2 = 1/ $E1probaAtq_gch_tab[$i];
		}
		$passemoins_gch  =int(( ( $part1 + $part2 ) * $E1unite_passemoins_gch)/10);	
	}
	#$passemoins_gch  =int( ((1/$E1probaConserv_gch_tab[$i]) +(1/ $E1probaAtq_gch_tab[$i])) * $E1unite_passemoins_gch);
	
	$passeplus_drt = int(($E1probaConserv_drt_tab[$i] + $E1probaAtq_drt_tab[$i]) * $E1unite_passeplus_drt);
	if ($E1probaConserv_drt_tab[$i] < $sig && $E1probaAtq_drt_tab[$i] < $sig){
		$passemoins_drt  = 0;
	}
	else{
		my $part1;
		my $part2;
		if ($E1probaConserv_drt_tab[$i] < $sig){
			$part1 =0;
		}
		else{
			$part1= 1/$E1probaConserv_drt_tab[$i];
		}
		if ($E1probaAtq_drt_tab[$i] < $sig){
			$part2=0;
		}
		else{
			$part2 = 1/ $E1probaAtq_drt_tab[$i];
		}
		$passemoins_drt  =int(( ( $part1 + $part2 ) * $E1unite_passemoins_drt)/10);	
	}
	#$passemoins_drt  =int( ((1/$E1probaConserv_drt_tab[$i] )+ (1/ $E1probaAtq_drt_tab[$i])) * $E1unite_passemoins_drt);
	
	print "PASSE :  $passeplus_gch / $passemoins_gch | $passeplus_ctr / $passemoins_ctr |  $passeplus_drt / $passemoins_drt \n";
	
	$dribleplus_ctr = int(( $E1probaAtq_ctr_tab[$i]) * $E1unite_dribleplus_ctr);
	if ( $E1probaAtq_ctr_tab[$i] > $sig ){
		$driblemoins_ctr  =int(((1/(  $E1probaAtq_ctr_tab[$i])) * $E1unite_driblemoins_ctr)/10);	
	}
	else{
		$driblemoins_ctr = 0;
	}
	
	$dribleplus_gch = int(( $E1probaAtq_gch_tab[$i]) * $E1unite_dribleplus_gch);
	if ( $E1probaAtq_gch_tab[$i] > $sig ){
		$driblemoins_gch  =int(((1/( $E1probaAtq_gch_tab[$i])) * $E1unite_driblemoins_gch)/10);
	}
	else{
		$driblemoins_gch=0;
	}
	
	$dribleplus_drt = int(( $E1probaAtq_drt_tab[$i]) * $E1unite_dribleplus_drt);
	if ( $E1probaAtq_drt_tab[$i] > $sig ){
		$driblemoins_drt  =int(((1/($E1probaAtq_drt_tab[$i])) * $E1unite_driblemoins_drt)/10);
	}
	else{
		$driblemoins_drt = 0;
	}
	print "DRIBLE :  $dribleplus_gch / $driblemoins_gch | $dribleplus_ctr / $driblemoins_ctr |  $dribleplus_drt / $driblemoins_drt \n";
	
	$tackleplus_ctr = int(( $E1probaDef_ctr_tab[$i]) * $E1unite_tackleplus_ctr);
	if ( $E1probaDef_ctr_tab[$i] > $sig ){
		$tacklemoins_ctr  =int(((1/(  $E1probaDef_ctr_tab[$i])) * $E1unite_tacklemoins_ctr)/10);	
	}
	else{
		$tacklemoins_ctr =0;
	}
	
	$tackleplus_gch = int(( $E1probaDef_gch_tab[$i]) * $E1unite_tackleplus_gch);
	if ( $E1probaDef_gch_tab[$i] > $sig ){
		$tacklemoins_gch  =int(((1/( $E1probaDef_gch_tab[$i])) * $E1unite_tacklemoins_gch)/10);
	}
	else{
		$tacklemoins_gch =0;
	}
	
	$tackleplus_drt = int(( $E1probaDef_drt_tab[$i]) * $E1unite_tackleplus_drt);
	if ( $E1probaDef_drt_tab[$i] > $sig ){
		$tacklemoins_drt  =int(((1/($E1probaDef_drt_tab[$i])) * $E1unite_tacklemoins_drt)/10);
	}
	else{
		$tacklemoins_drt = 0;
	}
	print "TACKLE :  $tackleplus_gch / $tacklemoins_gch | $tackleplus_ctr / $tacklemoins_ctr |  $tackleplus_drt / $tacklemoins_drt \n";
	
	#my $tirplus_ctr = int(( $E1probaAtq_ctr_tab[$i]) * $E1unite_tirplus_ctr);
	#my $tirmoins_ctr  =int((1/(  $E1probaAtq_ctr_tab[$i])) * $E1unite_tirmoins_ctr);	
	
	#my $tirplus_gch = int(( $E1probaAtq_gch_tab[$i]) * $E1unite_tirplus_gch);
	#my $tirmoins_gch  =int((1/( $E1probaAtq_gch_tab[$i])) * $E1unite_tirmoins_gch);
	
	#my $tirplus_drt = int(( $E1probaAtq_drt_tab[$i]) * $E1unite_tirplus_drt);
	#my $tirmoins_drt  =int((1/($E1probaAtq_drt_tab[$i])) * $E1unite_tirmoins_drt);
	
	print "TIR :  $E1tirplus[$i] / $E1tirmoins[$i] \n";
	
	#INSERT INTO stats (ballon+ , ballon-, passe+, passe-, drible+, drible-, tackle+, tackle-,tir+,tir-,id_joueur) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
	$sthStat->execute($ballonplus_ctr + $ballonplus_gch + $ballonplus_drt + $tackleplus_ctr+ $tackleplus_gch + $tackleplus_ctr ,
					  $ballonmoins_ctr + $ballonmoins_gch + $ballonmoins_drt + $passemoins_ctr + $passemoins_drt + $passemoins_gch,
					  $passeplus_ctr + $passeplus_drt + $passeplus_gch, $passemoins_ctr + $passemoins_drt + $passemoins_gch,
					  $dribleplus_ctr + $dribleplus_drt + $dribleplus_gch, $driblemoins_ctr + $driblemoins_drt + $driblemoins_gch,
					  $tackleplus_ctr + $tackleplus_drt + $tackleplus_gch, $tacklemoins_ctr + $tacklemoins_drt + $tacklemoins_gch,
					  $E1tirplus[$i], $E1tirmoins[$i],$E1But[$i],  $listePosition1[$i][0] );

	my $idstat= $dbh->{'mysql_insertid'};
	
	print "DBG INSERT STAT  : stat joueur insere avec  $idstat \n";
	
	push @E1stat, $idstat;
		
	#### La fatigue mental et physique.
		#1 xp,
		#5 physique,
		#7 mental,
		#13 cond,
		#15 moral	
		#push @E1xp_tab, $DetailJoueur[1];
		#push @E1physique_tab , $DetailJoueur[5];
		#push @E1mental_tab, $DetailJoueur[7];
		#push @E1cond_tab, $DetailJoueur[13];
		#push @E1moral_tab, $DetailJoueur[15];		
	
	my $mental = 0;
	my $mentalModificateur = 1 - ( (  (2* (rand($E1mental_tab[$i])/100)) +  (rand($E1xp_tab[$i])/100) )/3);
	my $condition = int ($E1cond_tab[$i]- 5 - 45 * ( 1 - (rand($E1physique_tab[$i])/100) )) ;

	print "  $E1cond_tab[$i] : $E1physique_tab[$i]  ||  $E1moral_tab[$i] : $E1mental_tab[$i] / $E1xp_tab[$i] / \n";	
	
	if ($E1But > $E2But){
		$mentalModificateur =  ( (  (2* (rand($E1mental_tab[$i])/100)) +  (rand($E1xp_tab[$i])/100) )/3);
	    #$mental = int ($E1moral_tab[$i] + 25 * $mentalModificateur);
	    $mental = int ($E1moral_tab[$i] + 5 / $mentalModificateur);
	}
	else{
		if ($E1But < $E2But){
			$mental = int ($E1moral_tab[$i] - 50 * $mentalModificateur);
		}
		else{
			$mental = int ($E1moral_tab[$i] - 10 * $mentalModificateur);
		}
	}
	
	if ($mental > 100){
		$mental = 100;
	}
	
	if ($mental < 1){
		$mental =  5;
	}
	
	if ($condition < 0){
		$condition = 0;
	}
	
	if ($condition > 100){
		$condition = 100;
	}
	

	
#   my $requeteUPDJoueur = "UPDATE joueurs SET  moral = ? , cond =? WHERE id = ?";
$stUPDJoueur->execute ($mental, $condition ,$listePosition1[$i][0] );
print "  Condition : $condition  / Moral : $mental  pour le joueur $listePosition1[$i][0] \n";
	
}
#"INSERT INTO feuilles_de_matchs (stats_j1_id,stats_j2_id,stats_j3_id,stats_j4_id,stats_j5_id,stats_j6_id,stats_j7_id,stats_j8_id,stats_j9_id,stats_j10_id,stats_j11_id)
	#				VALUES (?,?,?,?,?,?,?,?,?,?,?)"
$sthFdm->execute($E1stat[0],$E1stat[1],$E1stat[2],$E1stat[3],$E1stat[4],$E1stat[5],$E1stat[6],$E1stat[7],$E1stat[8],$E1stat[9],$E1stat[10]);
my $idfdm1 = $dbh->{'mysql_insertid'}; 



print  "\n Equipe 2 \n";
	my $E2unite_Recup_ctr = $E2ballonConserv_ctr / ($E2probaRecup_ctr *11);
	my $E2unite_Conserv_ctr = $E1ballonConserv_ctr / ($E2probaConserv_ctr*11);
	my $E2unite_Recup_drt = $E2ballonConserv_drt / ($E2probaRecup_drt *11);
	my $E2unite_Conserv_drt = $E1ballonConserv_gch / ($E2probaConserv_drt*11); 
	my $E2unite_Recup_gch = $E2ballonConserv_gch / ($E2probaRecup_gch *11);
	my $E2unite_Conserv_gch = $E1ballonConserv_drt / ($E2probaConserv_gch*11); 
	
	my $E2unite_passeplus_ctr = ($E2ballonOff_ctr + $E2ballonConserv_ctr)  / ($E2probaAtq_ctr *11 + $E2probaConserv_ctr*11);
	my $E2unite_passemoins_ctr = (( $E2ballonConserv_ctr *2 + $E2ballonConserv_drt + $E2ballonConserv_gch) - ($E2ballonOff_ctr + $E2ballonOff_drt + $E2ballonOff_gch) ) / ($E2probaAtq_ctr *11 + $E2probaConserv_ctr*11);
	my $E2unite_passeplus_drt = ($E2ballonOff_drt +$E2ballonConserv_drt) / ($E2probaAtq_drt *11 + $E2probaConserv_drt*11);
	my $E2unite_passemoins_drt = (( $E2ballonConserv_ctr +$E2ballonConserv_drt*2 + $E2ballonConserv_gch) - ($E2ballonOff_ctr + $E2ballonOff_drt + $E2ballonOff_gch) ) / ($E2probaAtq_drt *11 + $E2probaConserv_drt*11);
	my $E2unite_passeplus_gch = ($E2ballonOff_gch + $E2ballonConserv_gch)*2 / ($E2probaAtq_gch *11 + $E2probaConserv_gch*11);
	my $E2unite_passemoins_gch = (( $E2ballonConserv_ctr +$E2ballonConserv_drt + $E2ballonConserv_gch *2) - ($E2ballonOff_ctr + $E2ballonOff_drt + $E2ballonOff_gch) )  / ($E2probaAtq_gch *11 + $E2probaConserv_gch*11);
	 
	my $E2unite_dribleplus_ctr = $E2ballonOccaz_ctr/ ($E2probaAtq_ctr *11 );
	my $E2unite_driblemoins_ctr = ( $E2ballonOff_ctr - $E2ballonOccaz_ctr )  / ($E2probaAtq_ctr *11); 
	my $E2unite_dribleplus_drt = $E2ballonOccaz_drt/ ($E2probaAtq_drt *11 );
	my $E2unite_driblemoins_drt = ( $E2ballonOff_drt - $E2ballonOccaz_drt )  / ($E2probaAtq_drt *11); 
	my $E2unite_dribleplus_gch = $E2ballonOccaz_gch/ ($E2probaAtq_gch *11 );
	my $E2unite_driblemoins_gch = ( $E2ballonOff_gch - $E2ballonOccaz_gch )  / ($E2probaAtq_gch *11); 
	
	my $E2unite_tackleplus_ctr = (($E1ballonOccazTir_ctr*2 +$E1ballonOccazTir_drt + $E1ballonOccazTir_gch )- ($E1ballonTir_ctr + $E1ballonTir_drt + $E1ballonTir_gch))/ ($E2probaDef_ctr *11 );
	my $E2unite_tacklemoins_ctr = ( $E1ballonTir_ctr )  / ($E2probaDef_ctr *11); 
	my $E2unite_tackleplus_drt = (($E1ballonOccazTir_ctr +$E1ballonOccazTir_drt + $E1ballonOccazTir_gch*2 )- ($E1ballonTir_ctr + $E1ballonTir_drt + $E1ballonTir_gch))/ ($E2probaDef_drt *11 );
	my $E2unite_tacklemoins_drt = ( $E1ballonTir_gch)  / ($E2probaDef_drt *11); 
	my $E2unite_tackleplus_gch = (($E1ballonOccazTir_ctr +$E1ballonOccazTir_drt *2 + $E1ballonOccazTir_gch )- ($E1ballonTir_ctr + $E1ballonTir_drt + $E1ballonTir_gch))/ ($E2probaDef_gch *11 );
	my $E2unite_tacklemoins_gch = ($E1ballonTir_drt )  / ($E2probaDef_gch *11); 
	
	#my $E2unite_tirplus_ctr = $E2ballonOccaz_ctr/ ($E2probaAtq_ctr *11 );
	#my $E2unite_tirmoins_ctr = ( $E2ballonOff_ctr - $E2ballonOccaz_ctr )  / ($E2probaAtq_ctr *11); 
	#my $E2unite_tirplus_drt = $E2ballonOccaz_drt/ ($E2probaAtq_drt *11 );
	#my $E2unite_tirmoins_drt = ( $E2ballonOff_drt - $E2ballonOccaz_drt )  / ($E2probaAtq_drt *11); 
	#my $E2unite_tirplus_gch = $E2ballonOccaz_gch/ ($E2probaAtq_gch *11 );
	#my $E2unite_tirmoins_gch = ( $E2ballonOff_gch - $E2ballonOccaz_gch )  / ($E2probaAtq_gch *11); 
	
	
	
for (my $i = 0; $i<11; $i++){

		
	my $ballonplus_ctr;
	my $ballonmoins_ctr;
	my $ballonplus_drt;
	my $ballonmoins_drt;
	my $ballonplus_gch;
	my $ballonmoins_gch;
	
	my $passeplus_ctr;
	my $passemoins_ctr;
	my $passeplus_drt;
	my $passemoins_drt;
	my $passeplus_gch;
	my $passemoins_gch;
	
	my $dribleplus_ctr;
	my $driblemoins_ctr;
	my $dribleplus_drt;
	my $driblemoins_drt;
	my $dribleplus_gch;
	my $driblemoins_gch;
	
	my $tackleplus_ctr;
	my $tacklemoins_ctr;
	my $tackleplus_drt;
	my $tacklemoins_drt;
	my $tackleplus_gch;
	my $tacklemoins_gch;
	
	$ballonplus_ctr = int($E2probaRecup_ctr_tab[$i] * $E2unite_Recup_ctr);
	if ($E2probaConserv_ctr_tab[$i] > $sig ){
		$ballonmoins_ctr  =int(((1/$E2probaConserv_ctr_tab[$i]) * $E2unite_Conserv_ctr)/10);		
	}
	else{
		$ballonmoins_ctr =0;
	}

	$ballonplus_drt = int($E2probaRecup_drt_tab[$i] * $E2unite_Recup_drt);
	if ($E2probaConserv_drt_tab[$i] > $sig ){
		$ballonmoins_drt  =int(((1/$E2probaConserv_drt_tab[$i]) * $E2unite_Conserv_drt)/10);		
	}
	else{
		$ballonmoins_drt =0;
	}

	$ballonplus_gch = int($E2probaRecup_gch_tab[$i] * $E2unite_Recup_gch);
	if ($E2probaConserv_gch_tab[$i] > $sig ){
		$ballonmoins_gch  =int(((1/$E2probaConserv_gch_tab[$i]) * $E2unite_Conserv_gch)/10);	
	}
	else{
		$ballonmoins_gch =0;
	}
	print "BALLON : $ballonplus_gch / $ballonmoins_gch | $ballonplus_ctr / $ballonmoins_ctr | $ballonplus_drt / $ballonmoins_drt \n";

	$passeplus_ctr = int(($E2probaConserv_ctr_tab[$i] + $E2probaAtq_ctr_tab[$i]) * $E2unite_passeplus_ctr);
	if ($E2probaConserv_ctr_tab[$i] < $sig && $E2probaAtq_ctr_tab[$i] < $sig){
		$passemoins_ctr  = 0;
	}
	else{
		my $part1;
		my $part2;
		if ($E2probaConserv_ctr_tab[$i] < $sig){
			$part1 =0;
		}
		else{
			$part1= 1/$E2probaConserv_ctr_tab[$i];
		}
		if ($E2probaAtq_ctr_tab[$i] < $sig){
			$part2=0;
		}
		else{
			$part2 = 1/ $E2probaAtq_ctr_tab[$i];
		}
		$passemoins_ctr  =int(( ( $part1 + $part2 ) * $E2unite_passemoins_ctr)/10);	
	}
	
	$passeplus_gch = int(($E2probaConserv_gch_tab[$i] + $E2probaAtq_gch_tab[$i]) * $E2unite_passeplus_gch);
	if ($E2probaConserv_gch_tab[$i] < $sig && $E2probaAtq_gch_tab[$i] < $sig){
		$passemoins_gch  = 0;
	}
	else{
		my $part1;
		my $part2;
		if ($E2probaConserv_gch_tab[$i] < $sig){
			$part1 =0;
		}
		else{
			$part1= 1/$E2probaConserv_gch_tab[$i];
		}
		if ($E2probaAtq_gch_tab[$i] < $sig){
			$part2=0;
		}
		else{
			$part2 = 1/ $E2probaAtq_gch_tab[$i];
		}
		$passemoins_gch  =int(( ( $part1 + $part2 ) * $E2unite_passemoins_gch)/10);	
	}
	#$passemoins_gch  =int( ((1/$E2probaConserv_gch_tab[$i]) +(1/ $E2probaAtq_gch_tab[$i])) * $E2unite_passemoins_gch);
	
	$passeplus_drt = int(($E2probaConserv_drt_tab[$i] + $E2probaAtq_drt_tab[$i]) * $E2unite_passeplus_drt);
	if ($E2probaConserv_drt_tab[$i] < $sig && $E2probaAtq_drt_tab[$i] < $sig){
		$passemoins_drt  = 0;
	}
	else{
		my $part1;
		my $part2;
		if ($E2probaConserv_drt_tab[$i] < $sig){
			$part1 =0;
		}
		else{
			$part1= 1/$E2probaConserv_drt_tab[$i];
		}
		if ($E2probaAtq_drt_tab[$i] < $sig){
			$part2=0;
		}
		else{
			$part2 = 1/ $E2probaAtq_drt_tab[$i];
		}
		$passemoins_drt  =int( (( $part1 + $part2 ) * $E2unite_passemoins_drt)/10);	
	}
	#$passemoins_drt  =int( ((1/$E2probaConserv_drt_tab[$i] )+ (1/ $E2probaAtq_drt_tab[$i])) * $E2unite_passemoins_drt);
	
	print "PASSE :  $passeplus_gch / $passemoins_gch | $passeplus_ctr / $passemoins_ctr |  $passeplus_drt / $passemoins_drt \n";
	
	$dribleplus_ctr = int(( $E2probaAtq_ctr_tab[$i]) * $E2unite_dribleplus_ctr);
	if ( $E2probaAtq_ctr_tab[$i] > $sig ){
		$driblemoins_ctr  =int(((1/(  $E2probaAtq_ctr_tab[$i])) * $E2unite_driblemoins_ctr)/10);	
	}
	else{
		$driblemoins_ctr = 0;
	}
	
	$dribleplus_gch = int(( $E2probaAtq_gch_tab[$i]) * $E2unite_dribleplus_gch);
	if ( $E2probaAtq_gch_tab[$i] > $sig ){
		$driblemoins_gch  =int(((1/( $E2probaAtq_gch_tab[$i])) * $E2unite_driblemoins_gch)/10);
	}
	else{
		$driblemoins_gch=0;
	}
	
	$dribleplus_drt = int(( $E2probaAtq_drt_tab[$i]) * $E2unite_dribleplus_drt);
	if ( $E2probaAtq_drt_tab[$i] > $sig ){
		$driblemoins_drt  =int(((1/($E2probaAtq_drt_tab[$i])) * $E2unite_driblemoins_drt)/10);
	}
	else{
		$driblemoins_drt = 0;
	}
	print "DRIBLE :  $dribleplus_gch / $driblemoins_gch | $dribleplus_ctr / $driblemoins_ctr |  $dribleplus_drt / $driblemoins_drt \n";
	
	$tackleplus_ctr = int(( $E2probaDef_ctr_tab[$i]) * $E2unite_tackleplus_ctr);
	if ( $E2probaDef_ctr_tab[$i] > $sig ){
		$tacklemoins_ctr  =int(((1/(  $E2probaDef_ctr_tab[$i])) * $E2unite_tacklemoins_ctr)/10);	
	}
	else{
		$tacklemoins_ctr =0;
	}
	
	$tackleplus_gch = int(( $E2probaDef_gch_tab[$i]) * $E2unite_tackleplus_gch);
	if ( $E2probaDef_gch_tab[$i] > $sig ){
		$tacklemoins_gch  =int(((1/( $E2probaDef_gch_tab[$i])) * $E2unite_tacklemoins_gch)/10);
	}
	else{
		$tacklemoins_gch =0;
	}
	
	$tackleplus_drt = int(( $E2probaDef_drt_tab[$i]) * $E2unite_tackleplus_drt);
	if ( $E2probaDef_drt_tab[$i] > $sig ){
		$tacklemoins_drt  =int(((1/($E2probaDef_drt_tab[$i])) * $E2unite_tacklemoins_drt)/10);
	}
	else{
		$tacklemoins_drt = 0;
	}
	print "TACKLE :  $tackleplus_gch / $tacklemoins_gch | $tackleplus_ctr / $tacklemoins_ctr |  $tackleplus_drt / $tacklemoins_drt \n";
	
	#my $tirplus_ctr = int(( $E2probaAtq_ctr_tab[$i]) * $E2unite_tirplus_ctr);
	#my $tirmoins_ctr  =int((1/(  $E2probaAtq_ctr_tab[$i])) * $E2unite_tirmoins_ctr);	
	
	#my $tirplus_gch = int(( $E2probaAtq_gch_tab[$i]) * $E2unite_tirplus_gch);
	#my $tirmoins_gch  =int((1/( $E2probaAtq_gch_tab[$i])) * $E2unite_tirmoins_gch);
	
	#my $tirplus_drt = int(( $E2probaAtq_drt_tab[$i]) * $E2unite_tirplus_drt);
	#my $tirmoins_drt  =int((1/($E2probaAtq_drt_tab[$i])) * $E2unite_tirmoins_drt);
	
	print "TIR :  $E2tirplus[$i] / $E2tirmoins[$i] \n";

	
	#INSERT INTO stats (ballon+ , ballon-, passe+, passe-, drible+, drible-, tackle+, tackle-,tir+,tir-,id_joueur) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
	$sthStat->execute($ballonplus_ctr + $ballonplus_gch + $ballonplus_drt + $tackleplus_ctr+ $tackleplus_gch + $tackleplus_ctr ,
					  $ballonmoins_ctr + $ballonmoins_gch + $ballonmoins_drt + $passemoins_ctr + $passemoins_drt + $passemoins_gch,
					  $passeplus_ctr + $passeplus_drt + $passeplus_gch, $passemoins_ctr + $passemoins_drt + $passemoins_gch,
					  $dribleplus_ctr + $dribleplus_drt + $dribleplus_gch, $driblemoins_ctr + $driblemoins_drt + $driblemoins_gch,
					  $tackleplus_ctr + $tackleplus_drt + $tackleplus_gch, $tacklemoins_ctr + $tacklemoins_drt + $tacklemoins_gch,
					  $E2tirplus[$i], $E2tirmoins[$i],$E2But[$i], $listePosition2[$i][0] );

	my $idstat= $dbh->{'mysql_insertid'};
	push @E2stat, $idstat;
	print "DBG INSERT STAT  : stat joueur insere avec  $idstat \n";
	
	#### La fatigue mental et physique.
		#1 xp,
		#5 physique,
		#7 mental,
		#13 cond,
		#15 moral	
		#push @E2xp_tab, $DetailJoueur[1];
		#push @E2physique_tab , $DetailJoueur[5];
		#push @E2mental_tab, $DetailJoueur[7];
		#push @E2cond_tab, $DetailJoueur[13];
		#push @E12moral_tab, $DetailJoueur[15];		
	
	my $mental = 0;
	my $mentalModificateur = 1 - ( (  (2* (rand($E2mental_tab[$i])/100)) +  (rand($E2xp_tab[$i])/100) )/3);
	my $condition = int ($E2cond_tab[$i]- 5 - 45 * ( 1 - (rand($E2physique_tab[$i])/100) )) ;

	print "  $E2cond_tab[$i] : $E2physique_tab[$i]  ||  $E2moral_tab[$i] : $E2mental_tab[$i] / $E2xp_tab[$i] / \n";	
	
	if ($E1But < $E2But){
		$mentalModificateur =  ( (  (2* (rand($E2mental_tab[$i])/100)) +  (rand($E2xp_tab[$i])/100) )/3);
	    #$mental = int ($E2moral_tab[$i] + 25 * $mentalModificateur);
	    $mental = int ($E2moral_tab[$i] + 5 / $mentalModificateur);
	}
	else{
		if ($E1But > $E2But){
			$mental = int ($E2moral_tab[$i] - 50 * $mentalModificateur);
		}
		else{
			$mental = int ($E2moral_tab[$i] - 10 * $mentalModificateur);
		}
	}
	
	if ($mental > 100){
		$mental = 100;
	}
	
	if ($mental < 0){
		$mental = 0;
	}
	
	if ($condition < 0){
		$condition = 0;
	}
	

	
#   my $requeteUPDJoueur = "UPDATE joueurs SET  moral = ? , cond =? WHERE id = ?";
$stUPDJoueur->execute ($mental, $condition ,$listePosition2[$i][0] );
print "  Condition : $condition  / Moral : $mental  pour le joueur $listePosition2[$i][0] \n";
	

}
#"INSERT INTO feuilles_de_matchs (stats_j1_id,stats_j2_id,stats_j3_id,stats_j4_id,stats_j5_id,stats_j6_id,stats_j7_id,stats_j8_id,stats_j9_id,stats_j10_id,stats_j11_id)
	#				VALUES (?,?,?,?,?,?,?,?,?,?,?)"
$sthFdm->execute($E2stat[0],$E2stat[1],$E2stat[2],$E2stat[3],$E2stat[4],$E2stat[5],$E2stat[6],$E2stat[7],$E2stat[8],$E2stat[9],$E2stat[10]);
my $idfdm2 = $dbh->{'mysql_insertid'};
$sthFdm_match->execute($idfdm1,$idfdm2,$match); 


}


#print "\n DEBUG \n";
#foreach my $pos (@listePosition2){
#	print "Joueur: @$pos[0] ( @$pos[1],@$pos[2])\n";
#}
#foreach my $tir (@E1nb_tir_ctr){
#		print "$tir \n";
#	}
