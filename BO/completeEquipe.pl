#!/usr/bin/perl -w
use feature qw{ switch };
use strict;
use warnings;
use DBI;

#Ce script complete les tactique avec 11 joueurs, ou crée les tactique etb complete les position a null

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
  my $requeteInsertTactique;
  my $requeteUpdateMatchTactiqueEquipe1;
  my $requeteUpdateMatchTactiqueEquipe2;
  my $requetePositions;
  my $requetePosition;
  my $requeteJoueur1;
  my $requeteJoueur2;
  my $requeteInsertPosition;
  my $requeteUpdateTactiqueJ1;
  my $requeteUpdateTactiqueJ2;
  my $requeteUpdateTactiqueJ3;
  my $requeteUpdateTactiqueJ4;
  my $requeteUpdateTactiqueJ5;
  my $requeteUpdateTactiqueJ6;
  my $requeteUpdateTactiqueJ7;
  my $requeteUpdateTactiqueJ8;
  my $requeteUpdateTactiqueJ9;
  my $requeteUpdateTactiqueJ10;
  my $requeteUpdateTactiqueJ11;
    
  my $sthMatch;
  my $stTactiqueEquipe1;
  my $stTactiqueEquipe2;
  my $stInsertTactique;
  my $stUpdateMatchTactiqueEquipe1;
  my $stUpdateMatchTactiqueEquipe2;
  my $stPositions;
  my $stPosition;
  my $stJoueur1;
  my $stJoueur2;
  my $stInsertPosition;
  my $stUpdateTactiqueJ1;
  my $stUpdateTactiqueJ2;
  my $stUpdateTactiqueJ3;
  my $stUpdateTactiqueJ4;
  my $stUpdateTactiqueJ5;
  my $stUpdateTactiqueJ6;
  my $stUpdateTactiqueJ7;
  my $stUpdateTactiqueJ8;
  my $stUpdateTactiqueJ9;
  my $stUpdateTactiqueJ10;
  my $stUpdateTactiqueJ11;
  
  
  my $i;
  my $tact;
  my $trouve;
  my $pos;
  my $x;
  my $y;
  
  $requeteMatch = "SELECT matchs.id FROM matchs,annees WHERE matchs.num_journee = annees.journee";
  $requeteTactiqueEquipe1 = "SELECT tactique_equipe1 FROM matchs WHERE matchs.id = ?";
  $requeteTactiqueEquipe2 = "SELECT tactique_equipe2 FROM matchs WHERE matchs.id = ?";
  $requeteInsertTactique = "INSERT INTO tactiques VALUES ()";
  $requeteUpdateMatchTactiqueEquipe1 = "UPDATE matchs SET tactique_equipe1 = ? WHERE id = ?";
  $requeteUpdateMatchTactiqueEquipe2 = "UPDATE matchs SET tactique_equipe2 = ? WHERE id = ?";
  $requetePositions = "SELECT position_j1_id, position_j2_id, position_j3_id, position_j4_id, position_j5_id, position_j6_id,
						position_j7_id, position_j8_id, position_j9_id, position_j10_id, position_j11_id FROM tactiques 
						WHERE tactiques.id = ?";
  $requetePosition = "SELECT id_joueur FROM positions WHERE id = ?";
  $requeteJoueur1 = "SELECT joueurs.id FROM joueurs, contrats, equipes, matchs
					WHERE joueurs.id = contrats.joueur_id
					AND equipes.id  = contrats.equipe_id
					AND equipes.id = matchs.equipe1_id
					AND matchs.id = ?";
  $requeteJoueur2 = "SELECT joueurs.id FROM joueurs, contrats, equipes, matchs
					WHERE joueurs.id = contrats.joueur_id
					AND equipes.id  = contrats.equipe_id
					AND equipes.id = matchs.equipe2_id
					AND matchs.id = ?";
					
					
  $requeteInsertPosition = "INSERT INTO positions (x,y,id_joueur) VALUES (?,?,?)";
  $requeteUpdateTactiqueJ1 = "UPDATE tactiques SET position_j1_id = ? WHERE id = ?";
  $requeteUpdateTactiqueJ2 = "UPDATE tactiques SET position_j2_id = ? WHERE id = ?";
  $requeteUpdateTactiqueJ3 = "UPDATE tactiques SET position_j3_id = ? WHERE id = ?";
  $requeteUpdateTactiqueJ4 = "UPDATE tactiques SET position_j4_id = ? WHERE id = ?";
  $requeteUpdateTactiqueJ5 = "UPDATE tactiques SET position_j5_id = ? WHERE id = ?";
  $requeteUpdateTactiqueJ6 = "UPDATE tactiques SET position_j6_id = ? WHERE id = ?";
  $requeteUpdateTactiqueJ7 = "UPDATE tactiques SET position_j7_id = ? WHERE id = ?";
  $requeteUpdateTactiqueJ8 = "UPDATE tactiques SET position_j8_id = ? WHERE id = ?";
  $requeteUpdateTactiqueJ9 = "UPDATE tactiques SET position_j9_id = ? WHERE id = ?";
  $requeteUpdateTactiqueJ10 = "UPDATE tactiques SET position_j10_id = ? WHERE id = ?";
  $requeteUpdateTactiqueJ11 = "UPDATE tactiques SET position_j11_id = ? WHERE id = ?";

  $sthMatch = $dbh->prepare($requeteMatch);
  $stTactiqueEquipe1 = $dbh->prepare($requeteTactiqueEquipe1);
  $stTactiqueEquipe2 = $dbh->prepare($requeteTactiqueEquipe2);
  $stInsertTactique = $dbh->prepare($requeteInsertTactique);
  $stUpdateMatchTactiqueEquipe1 = $dbh->prepare($requeteUpdateMatchTactiqueEquipe1);
  $stUpdateMatchTactiqueEquipe2 = $dbh->prepare($requeteUpdateMatchTactiqueEquipe2);
  $stPositions = $dbh->prepare($requetePositions);
  $stPosition = $dbh->prepare($requetePosition);
  $stJoueur1 = $dbh->prepare($requeteJoueur1);
  $stJoueur2 = $dbh->prepare($requeteJoueur2);
  $stInsertPosition = $dbh->prepare($requeteInsertPosition);
  $stUpdateTactiqueJ1 = $dbh->prepare($requeteUpdateTactiqueJ1);
  $stUpdateTactiqueJ2 = $dbh->prepare($requeteUpdateTactiqueJ2);
  $stUpdateTactiqueJ3 = $dbh->prepare($requeteUpdateTactiqueJ3);
  $stUpdateTactiqueJ4 = $dbh->prepare($requeteUpdateTactiqueJ4);
  $stUpdateTactiqueJ5 = $dbh->prepare($requeteUpdateTactiqueJ5);
  $stUpdateTactiqueJ6 = $dbh->prepare($requeteUpdateTactiqueJ6);
  $stUpdateTactiqueJ7 = $dbh->prepare($requeteUpdateTactiqueJ7);
  $stUpdateTactiqueJ8 = $dbh->prepare($requeteUpdateTactiqueJ8);
  $stUpdateTactiqueJ9 = $dbh->prepare($requeteUpdateTactiqueJ9);
  $stUpdateTactiqueJ10 = $dbh->prepare($requeteUpdateTactiqueJ10);
  $stUpdateTactiqueJ11 = $dbh->prepare($requeteUpdateTactiqueJ11);



$sthMatch->execute();

while(@result = $sthMatch->fetchrow_array)
{
	push(@listeMatch, $result[0]);
}

#Pour chaque match de la journée X (en dur dans la requete), on cree la tactique s'il elle n'existe pas
foreach my $match (@listeMatch){
	print " *********** Match n° : $match ************************\n";
		$stTactiqueEquipe1->execute($match);
		$stTactiqueEquipe2->execute($match);
		#On recupere la tactique de l'equipe 1
		while( my @result_tac1 = $stTactiqueEquipe1->fetchrow_array)
		{
			if (not defined($result_tac1[0])){				
				# Pas de tactique cree pour cette equipe, cette journée, on la cree.
				$stInsertTactique->execute();
				$tact = $dbh->{'mysql_insertid'};
				print "Tactique Equipe1 :$tact \n";			
				$stUpdateMatchTactiqueEquipe1->execute($tact,$match);				
			}
		}
		#On recupere la tactique de l'equipe 2
		while( my @result_tac2 = $stTactiqueEquipe2->fetchrow_array)
		{
			if (not defined($result_tac2[0])){				
				# Pas de tactique cree pour cette equipe, cette journée, on la cree.
				$stInsertTactique->execute();
				$tact = $dbh->{'mysql_insertid'};
				print "Tactique Equipe2 :$tact \n";	
				$stUpdateMatchTactiqueEquipe2->execute($tact,$match);					
			}
		}
		
		
}

#Pour chaque match de la journée X (en dur dans la requete), on complete la tactique avec 11 joueurs
foreach my $match (@listeMatch){
	print " *********** Match n° : $match ************  Equipe 1 ************\n";
		$stTactiqueEquipe1->execute($match);
		$stTactiqueEquipe2->execute($match);
		#On recupere la tactique de l'equipe 1
		while( my @result_tac1 = $stTactiqueEquipe1->fetchrow_array)
		{
			if (defined($result_tac1[0])){	
				# On positionnement aleatoirement les joueurs de l'equipe pour en avoir 11
				$stPositions->execute($result_tac1[0]);
				#on compte le nombre de joueur deja positionne
				while(my @result_poss1 = $stPositions->fetchrow_array)
				{
					$i=0;
					foreach my $position (@result_poss1){	
						$stPosition->execute($position);
						while(my @result_pos1 = $stPosition->fetchrow_array){
							$listePosition1[$i] = $result_pos1[0];							
											
							if (defined ($position) && defined($result_pos1[0])){
								$i++;
								print "Le joueur $i ($result_pos1[0]) est positionné à la position $position \n";
								
							}
						}
						#$i++;							
					}												
				}
				#Si il n'y a pas 11 joueurs on complete
				#if ($i <= 11 ){
					
					while($i<11){
						$stJoueur1->execute($match);
							my @result_joueur = $stJoueur1->fetchrow_array;
							$trouve = 0;
							#On compare la liste des selectionne avec tout les joueurs de l'equipe
							foreach my $joueur(@listePosition1){
								if ($joueur == $result_joueur[0]){
									$trouve = 1;
								}
							}
							#Si le joueur n'est pas selectionne on le fait et on le place
							if($trouve == 0){
								$x = int(40+rand(640));
								$y = int(20+rand(410));
								$stInsertPosition->execute($x,$y,$result_joueur[0]);
								$pos = $dbh->{'mysql_insertid'};
								$i++;
								print "Le joueur $i ($result_joueur[0]) est positionné à la position $pos (au pif)\n";
								given ($i){
									when(1) {$stUpdateTactiqueJ1->execute($pos,$result_tac1[0]);}
									when(2) {$stUpdateTactiqueJ2->execute($pos,$result_tac1[0]);}
									when(3) {$stUpdateTactiqueJ3->execute($pos,$result_tac1[0]);}
									when(4) {$stUpdateTactiqueJ4->execute($pos,$result_tac1[0]);}
									when(5) {$stUpdateTactiqueJ5->execute($pos,$result_tac1[0]);}
									when(6) {$stUpdateTactiqueJ6->execute($pos,$result_tac1[0]);}
									when(7) {$stUpdateTactiqueJ7->execute($pos,$result_tac1[0]);}
									when(8) {$stUpdateTactiqueJ8->execute($pos,$result_tac1[0]);}
									when(9) {$stUpdateTactiqueJ9->execute($pos,$result_tac1[0]);}
									when(10) {$stUpdateTactiqueJ10->execute($pos,$result_tac1[0]);}
									when(11) {$stUpdateTactiqueJ11->execute($pos,$result_tac1[0]);}	
									default{}
								}
								
							}					
					}					
				#}				
			}
			else{
				print "ERROR, pas de tactique pour l'equipe 1\n";
			}
		}
		
		print " *********** Match n° : $match ************  Equipe 2 ************\n";
		#On recupere la tactique de l'equipe 2
		while( my @result_tac2 = $stTactiqueEquipe2->fetchrow_array)
		{
			if (defined($result_tac2[0])){				
				# On positionnement aleatoirement les joueurs de l'equipe pour en avoir 11
				$stPositions->execute($result_tac2[0]);
				while(my @result_poss2 = $stPositions->fetchrow_array)
				{
					$i=0;
					foreach my $position (@result_poss2){	
						$stPosition->execute($position);
						while(my @result_pos2 = $stPosition->fetchrow_array){
							$listePosition2[$i] = $result_pos2[0];							
											
							if (defined ($position) && defined($result_pos2[0])){
								$i++;
								print "Le joueur $i ($result_pos2[0]) est positionné à la position $position \n";
								
							}
						}
						#$i++;							
					}												
				}
				#Si il n'y a pas 11 joueurs on complete
				#if ($i < 11 ){
					
					while($i<11){
							$stJoueur2->execute($match);
						    my @result_joueur = $stJoueur2->fetchrow_array;
							$trouve = 0;
							#On compare la liste des selectionne avec tout les joueurs de l'equipe
							foreach my $joueur(@listePosition2){
								if ($joueur == $result_joueur[0]){
									$trouve = 1;
								}
							}
							#Si le joueur n'est pas selectionne on le fait et on le place
							if($trouve == 0){
								$x = int(40+rand(640));
								$y = int(20+rand(410));
								$stInsertPosition->execute($x,$y,$result_joueur[0]);
								$pos = $dbh->{'mysql_insertid'};
								$i++;
								print "Le joueur $i ($result_joueur[0]) est positionné à la position $pos (au pif)\n";
								given ($i){
									when(1) {$stUpdateTactiqueJ1->execute($pos,$result_tac2[0])}
									when(2) {$stUpdateTactiqueJ2->execute($pos,$result_tac2[0])}
									when(3) {$stUpdateTactiqueJ3->execute($pos,$result_tac2[0])}
									when(4) {$stUpdateTactiqueJ4->execute($pos,$result_tac2[0])}
									when(5) {$stUpdateTactiqueJ5->execute($pos,$result_tac2[0])}
									when(6) {$stUpdateTactiqueJ6->execute($pos,$result_tac2[0])}
									when(7) {$stUpdateTactiqueJ7->execute($pos,$result_tac2[0])}
									when(8) {$stUpdateTactiqueJ8->execute($pos,$result_tac2[0])}
									when(9) {$stUpdateTactiqueJ9->execute($pos,$result_tac2[0])}
									when(10) {$stUpdateTactiqueJ10->execute($pos,$result_tac2[0])}
									when(11) {$stUpdateTactiqueJ11->execute($pos,$result_tac2[0])}									
								}
								
							}
						
					}									
				#}			
			}
			else{
				print "ERROR, pas de tactique pour l'equipe 2\n";			
			}
		}
		
		
}

print "\n\n ================ Positions x,y NULL ======================\n";

my $requeteXnull ="SELECT positions.id from positions, annees, tactiques, matchs 
				   where positions.x IS NULL
				   AND (matchs.tactique_equipe1 = tactiques.id
				   OR matchs.tactique_equipe2 = tactiques.id)
				   AND matchs.num_journee = annees.journee
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
				   OR positions.id = tactiques.position_j11_id)";
my $requeteUPDX = "UPDATE positions SET x = ?  WHERE id = ?";
my $sthUPDX = $dbh->prepare($requeteUPDX);
my $sthXnull = $dbh->prepare($requeteXnull);
$sthXnull->execute();
my @Xnull =();
my $randx;
while(@Xnull = $sthXnull->fetchrow_array)
{
	$randx = int(40+rand(635));
	$sthUPDX->execute($randx,$Xnull[0]); 
	print "position $Xnull[0] NULL corrige avec $randx \n";
}

print "\n\n\n\n";

my $requeteYnull ="SELECT positions.id from positions, annees, tactiques, matchs 
				   where positions.y IS NULL
				   AND (matchs.tactique_equipe1 = tactiques.id
				   OR matchs.tactique_equipe2 = tactiques.id)
				   AND matchs.num_journee = annees.journee
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
				   OR positions.id = tactiques.position_j11_id)";
my $requeteUPDY = "UPDATE positions SET y = ?  WHERE id = ?";
my $sthUPDY = $dbh->prepare($requeteUPDY);
my $sthYnull = $dbh->prepare($requeteYnull);
$sthYnull->execute();
my @Ynull =();
my $randy;
while(@Ynull = $sthYnull->fetchrow_array)
{
	$randy = int(20+rand(405));
	$sthUPDY->execute($randy,$Ynull[0]); 
	print "position $Ynull[0] NULL corrige avec $randy \n";
}


print "\n DEBUG \n";

