#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;
use Statistics::Lite qw(:all);

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
    
  my $sthMatch;
  my $stTactiqueEquipe1;
  my $stTactiqueEquipe2;
  my $stPositions;
  my $stPosition;
  
  my $min_x = 40;
  my $min_y = 20 ;
  my $max_x = $min_x + 640;
  my $max_y = $min_y + 410;
  my $mid_x = ($max_x - $min_x) /2;
  my $mid_y = ($max_y - $min_y) /2;
  my $gch_y = $min_y + (($max_y - $min_y) /6 )*2;
  my $drt_y = $max_y - (($max_y - $min_y) /6 )*2;
   
  my $i;
  
  $requeteMatch = "SELECT id FROM matchs WHERE num_journee = 1";
  $requeteTactiqueEquipe1 = "SELECT tactique_equipe1 FROM matchs WHERE matchs.id = ?";
  $requeteTactiqueEquipe2 = "SELECT tactique_equipe2 FROM matchs WHERE matchs.id = ?";
  $requetePositions = "SELECT position_j1_id, position_j2_id, position_j3_id, position_j4_id, position_j5_id, position_j6_id,
						position_j7_id, position_j8_id, position_j9_id, position_j10_id, position_j11_id FROM tactiques 
						WHERE tactiques.id = ?";
						
  $requetePosition = "SELECT id_joueur, x, y FROM positions WHERE id = ?";
  $sthMatch = $dbh->prepare($requeteMatch);
  $stTactiqueEquipe1 = $dbh->prepare($requeteTactiqueEquipe1);
  $stTactiqueEquipe2 = $dbh->prepare($requeteTactiqueEquipe2);
  $stPositions = $dbh->prepare($requetePositions);
  $stPosition = $dbh->prepare($requetePosition);

$sthMatch->execute();

while(@result = $sthMatch->fetchrow_array)
{
	push(@listeMatch, $result[0]);
}

#Pour chaque match de la journée X (en dur dans la requete)
foreach my $match (@listeMatch){
	print " \n ***************************          Match n° : $match          *****************************************\n";
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
		my @J =();
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
		my $JprobaRecup;
		my $JprobaRecup_gch;
		my $JprobaRecup_drt;
		my $JprobaRecup_ctr;
		my $JprobaConserv;
		my $JprobaConserv_gch;
		my $JprobaConserv_drt;
		my $JprobaConserv_ctr;
	
		
		my $E1probaRecup;
		my $E1probaRecup_gch;
		my $E1probaRecup_drt;
		my $E1probaRecup_ctr;		
		my $E1probaConserv;
		my $E1probaConserv_gch;
		my $E1probaConserv_drt;
		my $E1probaConserv_ctr;
	
		
		my $E2probaRecup;
		my $E2probaRecup_gch;
		my $E2probaRecup_drt;
		my $E2probaRecup_ctr;		
		my $E2probaConserv;
		my $E2probaConserv_gch;
		my $E2probaConserv_drt;
		my $E2probaConserv_ctr;
		
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
		my $JprobaDef;
		my $JprobaDef_gch;
		my $JprobaDef_drt;
		my $JprobaDef_ctr;
		my $JprobaAtq;
		my $JprobaAtq_gch;
		my $JprobaAtq_drt;
		my $JprobaAtq_ctr;
	
		
		my $E1probaDef;
		my $E1probaDef_gch;
		my $E1probaDef_drt;
		my $E1probaDef_ctr;		
		my $E1probaAtq;
		my $E1probaAtq_gch;
		my $E1probaAtq_drt;
		my $E1probaAtq_ctr;
	
		
		my $E2probaDef;
		my $E2probaDef_gch;
		my $E2probaDef_drt;
		my $E2probaDef_ctr;		
		my $E2probaAtq;
		my $E2probaAtq_gch;
		my $E2probaAtq_drt;
		my $E2probaAtq_ctr;
		
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
		
		
		my $requeteJoueur;
		my $stJoueur;
		my @DetailJoueur =();
		
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
		
		print "================== Calcul Stat ============================\n";
		print "            Equipe 1  \n";
	foreach my $joueur (@listePosition1){
		$stJoueur->execute(@$joueur[0]);
		@DetailJoueur = $stJoueur->fetchrow_array;
		my $formeMatch = ($DetailJoueur[13] + $DetailJoueur[15] + $DetailJoueur[2]  +rand(50) + 50) / 400;		
		my $multipl_bonus;
		#Calcul des bonus de "bon" positionnement des joueurs
		my $bonus_x ;
		my $bonus_x_off;
		my $bonus_x_def;
		my $bonus_y ; 
		my $diff_x = abs($mid_x - @$joueur[1]);
		my $diff_x_atq = $max_x - @$joueur[1];
		my $diff_x_def = @$joueur[1] - $min_x ;
		my $diff_y = abs($mid_y - @$joueur[2]);
		my $diff_gch_y = abs($gch_y - @$joueur[2]);
		my $diff_drt_y = abs($drt_y - @$joueur[2]);
		
		$bonus_x_off = (($diff_x_atq / $max_x)* $DetailJoueur[9]) / 100;
		$bonus_x_def = (($diff_x_def / $min_x)* $DetailJoueur[8]) / 100;
			
		if (@$joueur[1] > $mid_x){
			$bonus_x = max ($DetailJoueur[8]/100,($DetailJoueur[8] + ((1 - ($diff_x / $mid_x)) * $DetailJoueur[9])) / 200);
		}
		else
		{
			$bonus_x = max ($DetailJoueur[9]/100,($DetailJoueur[9] + ((1 - ($diff_x / $mid_x)) * $DetailJoueur[8])) / 200);
		}
		if (@$joueur[2] < $gch_y){
			#le joueur est à gauche
			$bonus_y = ($DetailJoueur[12] + ((1 - ($diff_gch_y / $gch_y)) * $DetailJoueur[11]))/200;
			$JprobaRecup = $bonus_x * $formeMatch * (($diff_x / $mid_x) * $DetailJoueur[3])/100 * ( $DetailJoueur[3] * 3 + $DetailJoueur[5]*2 + $DetailJoueur[4] )/600  * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
			#Cacul des stats pour gauche (avec bonus) et droite et centre			
			$JprobaRecup_gch = 1- ($JprobaRecup - 3 * $bonus_y);
			$JprobaRecup_drt = 1- $JprobaRecup;
			$JprobaRecup_ctr = 1-($JprobaRecup - $bonus_y) ;
			print "Recup :  $JprobaRecup_gch	| $JprobaRecup_ctr	| $JprobaRecup_drt \n";
			
			$JprobaConserv = $bonus_x * $formeMatch * (($diff_x / $mid_x) * $DetailJoueur[3])/100 *  ( $DetailJoueur[3] * 2+ $DetailJoueur[4] * 3 )/500 * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
			$JprobaConserv_gch =1- ($JprobaConserv - 3 * $bonus_y) ;
			$JprobaConserv_drt = 1-$JprobaConserv;
			$JprobaConserv_ctr = 1-($JprobaConserv - $bonus_y);
			print "Conserv :  $JprobaConserv_gch	| $JprobaConserv_ctr	| $JprobaConserv_drt \n";
			
			$JprobaAtq = $bonus_x_atq * $formeMatch * (($diff_x_atq / $max_x) * $DetailJoueur[3])/100 *  ( $DetailJoueur[3] * 2 + $DetailJoueur[4] * 3 +  $DetailJoueur[6] * 5 )/1000 * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
			$JprobaAtq_gch =1- ($JprobaAtq - (3 * $bonus_y * $DetailJoueur[6]/100)) ;
			$JprobaAtq_drt = 1-$JprobaAtq;
			$JprobaAtq_ctr = 1-($JprobaAtq - $bonus_y);
			print "Atq :  $JprobaAtq_gch	| $JprobaAtq_ctr	| $JprobaAtq_drt \n";
			
			$JprobaDef = $bonus_x_def * $formeMatch * (($diff_x_def / $min_x) * $DetailJoueur[3])/100 *  ( $DetailJoueur[3] * 2+ $DetailJoueur[4] * 3 + +  $DetailJoueur[6] * 5)/1000 * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
			$JprobaDef_gch =1- ($JprobaDef - (3 * $bonus_y * $DetailJoueur[6]/100)) ;
			$JprobaDef_drt = 1-$JprobaDef;
			$JprobaDef_ctr = 1-($JprobaDef - $bonus_y);
			print "Def :  $JprobaDef_gch	| $JprobaDef_ctr	| $JprobaDef_drt \n";
		}
		else{
			if (@$joueur[2] > $drt_y){
				#le joueur est à droite
				$bonus_y = ($DetailJoueur[10] + ((1 - ($diff_drt_y / $drt_y)) * $DetailJoueur[11]))/200;
				$JprobaRecup = $bonus_x * $formeMatch *  (($diff_x / $mid_x) * $DetailJoueur[3])/100 * ( $DetailJoueur[3] * 3 + $DetailJoueur[5]*2 + $DetailJoueur[4] )/600 * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
				#Cacul des stats pour gauche (avec bonus) et droite et centre			
				$JprobaRecup_gch = 1-$JprobaRecup;
				$JprobaRecup_drt = 1-($JprobaRecup - 3 * $bonus_y) ;
				$JprobaRecup_ctr = 1-($JprobaRecup - $bonus_y) ;
				print "Recup :  $JprobaRecup_gch	| $JprobaRecup_ctr	| $JprobaRecup_drt \n";
				
				$JprobaConserv = $bonus_x * $formeMatch * (($diff_x / $mid_x) * $DetailJoueur[3])/100 * ( $DetailJoueur[3] * 2+ $DetailJoueur[4] * 3 )/500  * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
				$JprobaConserv_drt = 1- ($JprobaConserv - 3 * $bonus_y) ;
				$JprobaConserv_gch = 1 - $JprobaConserv;
				$JprobaConserv_ctr = 1- ($JprobaConserv - $bonus_y) ;				
				print "Conserv :  $JprobaConserv_gch	| $JprobaConserv_ctr	| $JprobaConserv_drt \n";
				
				$JprobaAtq = $bonus_x_atq * $formeMatch * (($diff_x_atq / $max_x) * $DetailJoueur[3])/100 *  ( $DetailJoueur[3] * 2 + $DetailJoueur[4] * 3 +  $DetailJoueur[6] * 5 )/1000 * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
				$JprobaAtq_gch =1- $JprobaAtq ;
				$JprobaAtq_drt = 1-($JprobaAtq - (3 * $bonus_y * $DetailJoueur[6]/100)) ;
				$JprobaAtq_ctr = 1-($JprobaAtq - $bonus_y);
				print "Atq :  $JprobaAtq_gch	| $JprobaAtq_ctr	| $JprobaAtq_drt \n";
			
				$JprobaDef = $bonus_x_def * $formeMatch * (($diff_x_def / $min_x) * $DetailJoueur[3])/100 *  ( $DetailJoueur[3] * 2+ $DetailJoueur[4] * 3 + +  $DetailJoueur[6] * 5)/1000 * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
				$JprobaDef_gch =1- $JprobaDef ;
				$JprobaDef_drt = 1- ($JprobaDef - (3 * $bonus_y * $DetailJoueur[6]/100)) ;
				$JprobaDef_ctr = 1-($JprobaDef - $bonus_y);
				print "Def :  $JprobaDef_gch	| $JprobaDef_ctr	| $JprobaDef_drt \n";
			
			}
			else
			{
			#le joueur joue au centre	
				$bonus_y = ($DetailJoueur[11] + ($diff_drt_y / $drt_y * $DetailJoueur[10]) + ($diff_gch_y / $gch_y * $DetailJoueur[11] ))/300;
				$JprobaRecup = $bonus_x * $formeMatch *  (($diff_x / $mid_x) * $DetailJoueur[3])/100 * ( $DetailJoueur[3] * 3 + $DetailJoueur[5]*2 + $DetailJoueur[4] )/600 * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
				#Cacul des stats pour gauche (avec bonus) et droite et centre			
				$JprobaRecup_gch = 1- ($JprobaRecup - $bonus_y) ;
				$JprobaRecup_drt = 1- ($JprobaRecup - $bonus_y);
				$JprobaRecup_ctr = 1- ($JprobaRecup - 2 * $bonus_y) ;				
				print "Recup :  $JprobaRecup_gch	| $JprobaRecup_ctr	| $JprobaRecup_drt \n";
				
				$JprobaConserv = $bonus_x * $formeMatch * (($diff_x / $mid_x) * $DetailJoueur[3])/100 * ( $DetailJoueur[3] * 2+ $DetailJoueur[4] * 3 )/500  * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
				$JprobaConserv_ctr = 1- ($JprobaConserv - 2 * $bonus_y) ;
				$JprobaConserv_gch = 1- ($JprobaConserv - $bonus_y) ;
				$JprobaConserv_drt = 1- ($JprobaConserv - $bonus_y) ;				
				print "Conserv :  $JprobaConserv_gch	| $JprobaConserv_ctr	| $JprobaConserv_drt \n";
				
				$JprobaAtq = $bonus_x_atq * $formeMatch * (($diff_x_atq / $max_x) * $DetailJoueur[3])/100 *  ( $DetailJoueur[3] * 2 + $DetailJoueur[4] * 3 +  $DetailJoueur[6] * 5 )/1000 * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
				$JprobaAtq_gch =  1-($JprobaAtq - $bonus_y * $DetailJoueur[6]/100);
				$JprobaAtq_drt =  1-($JprobaAtq - $bonus_y * $DetailJoueur[6]/100);
				$JprobaAtq_ctr = 1-($JprobaAtq - 2* $bonus_y);
				print "Atq :  $JprobaAtq_gch	| $JprobaAtq_ctr	| $JprobaAtq_drt \n";
			
				$JprobaDef = $bonus_x_def * $formeMatch * (($diff_x_def / $min_x) * $DetailJoueur[3])/100 *  ( $DetailJoueur[3] * 2+ $DetailJoueur[4] * 3 + +  $DetailJoueur[6] * 5)/1000 * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
				$JprobaDef_gch = 1-($JprobaDef - $bonus_y * $DetailJoueur[6]/100);
				$JprobaDef_drt = 1-($JprobaDef - $bonus_y * $DetailJoueur[6]/100);
				$JprobaDef_ctr = 1-($JprobaDef - 2 * $bonus_y);
				print "Def :  $JprobaDef_gch	| $JprobaDef_ctr	| $JprobaDef_drt \n";
			}
		}
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
	
		print "\n            Equipe 2  \n";
	foreach my $joueur (@listePosition2){
		$stJoueur->execute(@$joueur[0]);
		@DetailJoueur = $stJoueur->fetchrow_array;
		my $formeMatch = ($DetailJoueur[13] + $DetailJoueur[15] + $DetailJoueur[2]  +rand(50) + 50) / 400;		
		my $multipl_bonus;
		#Calcul des bonus de "bon" positionnement des joueurs
		my $bonus_x ;
		my $bonus_y ; 
		my $diff_x = abs($mid_x - @$joueur[1]);
		my $diff_y = abs($mid_y - @$joueur[2]);
		my $diff_gch_y = abs($gch_y - @$joueur[2]);
		my $diff_drt_y = abs($drt_y - @$joueur[2]);
		
		if (@$joueur[1] > $mid_x){
			$bonus_x = max ($DetailJoueur[8]/100,($DetailJoueur[8] + ((1 - ($diff_x / $mid_x)) * $DetailJoueur[9])) / 200);
		}
		else
		{
			$bonus_x = max ($DetailJoueur[9]/100,($DetailJoueur[9] + ((1 - ($diff_x / $mid_x)) * $DetailJoueur[8])) / 200);
		}
		if (@$joueur[2] < $gch_y){
			#le joueur est à gauche
			$bonus_y = ($DetailJoueur[12] + ((1 - ($diff_gch_y / $gch_y)) * $DetailJoueur[11]))/200;
			$JprobaRecup = $bonus_x * $formeMatch * (($diff_x / $mid_x) * $DetailJoueur[3])/100 * ( $DetailJoueur[3] * 3 + $DetailJoueur[5]*2 + $DetailJoueur[4] )/600  * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
			#Cacul des stats pour gauche (avec bonus) et droite et centre			
			$JprobaRecup_gch = ($JprobaRecup + 2 * $bonus_y)/3 ;
			$JprobaRecup_drt = $JprobaRecup;
			$JprobaRecup_ctr = ($JprobaRecup + $bonus_y) /2;
			print "Recup :  $JprobaRecup_gch	| $JprobaRecup_ctr	| $JprobaRecup_drt \n";
			
			$JprobaConserv = $bonus_x * $formeMatch * (($diff_x / $mid_x) * $DetailJoueur[3])/100 *  ( $DetailJoueur[3] * 2+ $DetailJoueur[4] * 3 )/500 * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
			$JprobaConserv_gch = ($JprobaConserv + 2 * $bonus_y)/3 ;
			$JprobaConserv_drt = $JprobaConserv;
			$JprobaConserv_ctr = ($JprobaConserv + $bonus_y) /2;
			print "Conserv :  $JprobaConserv_gch	| $JprobaConserv_ctr	| $JprobaConserv_drt \n";
		}
		else{
			if (@$joueur[2] > $drt_y){
				#le joueur est à droite
				$bonus_y = ($DetailJoueur[10] + ((1 - ($diff_drt_y / $drt_y)) * $DetailJoueur[11]))/200;
				$JprobaRecup = $bonus_x * $formeMatch *  (($diff_x / $mid_x) * $DetailJoueur[3])/100 * ( $DetailJoueur[3] * 3 + $DetailJoueur[5]*2 + $DetailJoueur[4] )/600 * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
				#Cacul des stats pour gauche (avec bonus) et droite et centre			
				$JprobaRecup_gch = $JprobaRecup;
				$JprobaRecup_drt = ($JprobaRecup + 2 * $bonus_y)/3 ;
				$JprobaRecup_ctr = ($JprobaRecup + $bonus_y) /2;
				print "Recup :  $JprobaRecup_gch	| $JprobaRecup_ctr	| $JprobaRecup_drt \n";
				
				$JprobaConserv = $bonus_x * $formeMatch * (($diff_x / $mid_x) * $DetailJoueur[3])/100 * ( $DetailJoueur[3] * 2+ $DetailJoueur[4] * 3 )/500  * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
				$JprobaConserv_drt = ($JprobaConserv + 2 * $bonus_y)/3 ;
				$JprobaConserv_gch = $JprobaConserv;
				$JprobaConserv_ctr = ($JprobaConserv + $bonus_y) /2;				
				print "Conserv :  $JprobaConserv_gch	| $JprobaConserv_ctr	| $JprobaConserv_drt \n";
			
			}
			else
			{
			#le joueur joue au centre	
				$bonus_y = ($DetailJoueur[11] + ($diff_drt_y / $drt_y * $DetailJoueur[10]) + ($diff_gch_y / $gch_y * $DetailJoueur[11] ))/300;
				$JprobaRecup = $bonus_x * $formeMatch *  (($diff_x / $mid_x) * $DetailJoueur[3])/100 * ( $DetailJoueur[3] * 3 + $DetailJoueur[5]*2 + $DetailJoueur[4] )/600 * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
				#Cacul des stats pour gauche (avec bonus) et droite et centre			
				$JprobaRecup_gch = ($JprobaRecup + $bonus_y)/2 ;
				$JprobaRecup_drt = ($JprobaRecup + $bonus_y)/2 ;
				$JprobaRecup_ctr = ($JprobaRecup + 2* $bonus_y) /3;				
				print "Recup :  $JprobaRecup_gch	| $JprobaRecup_ctr	| $JprobaRecup_drt \n";
				
				$JprobaConserv = $bonus_x * $formeMatch * (($diff_x / $mid_x) * $DetailJoueur[3])/100 * ( $DetailJoueur[3] * 2+ $DetailJoueur[4] * 3 )/500  * ($DetailJoueur[1]*2 + $DetailJoueur[2]*2 +  $DetailJoueur[4])/500;		
				$JprobaConserv_ctr = ($JprobaConserv + 2 * $bonus_y)/3 ;
				$JprobaConserv_gch = ($JprobaConserv + $bonus_y) /2;
				$JprobaConserv_drt = ($JprobaConserv + $bonus_y) /2;				
				print "Conserv :  $JprobaConserv_gch	| $JprobaConserv_ctr	| $JprobaConserv_drt \n";
			}
		}
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
	}
	$E2probaRecup_gch = $E2probaRecup_gch /11 ;
	$E2probaRecup_drt = $E2probaRecup_drt/11;
	$E2probaRecup_ctr = $E2probaRecup_ctr /11;
	print "\n Recup :   $E2probaRecup_gch	| $E2probaRecup_ctr	| $E2probaRecup_drt \n";
	
	$E2probaConserv_gch = $E2probaConserv_gch /11 ;
	$E2probaConserv_drt = $E2probaConserv_drt/11;
	$E2probaConserv_ctr = $E2probaConserv_ctr /11;
	print " Conserv :  $E2probaConserv_gch	| $E2probaConserv_ctr	| $E2probaConserv_drt \n";
	
	
	#Repartition des ballons joues
	
	my $unite_ballon;
	my $E1diffConserv_ctr;
	my $E2diffConserv_ctr;
	my $E1ballonConserv_ctr;
	my $E2ballonConserv_ctr;
	
	my $E1diffConserv_drt;
	my $E2diffConserv_drt;
	my $E1ballonConserv_drt;
	my $E2ballonConserv_drt;
	
	my $E1diffConserv_gch;
	my $E2diffConserv_gch;
	my $E1ballonConserv_gch;
	my $E2ballonConserv_gch;
	
	my $nb_ballon_cote = $nb_ballon /2;
	
	my $E1ballonOff_ctr;
	my $E1ballonOff_drt;
	my $E1ballonOff_gch;
	
	my $E2ballonOff_ctr;
	my $E2ballonOff_drt;
	my $E2ballonOff_gch;
	
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

	
}


print "\n DEBUG \n";
foreach my $pos (@listePosition2){
	print "Joueur: @$pos[0] ( @$pos[1],@$pos[2])\n";
}
