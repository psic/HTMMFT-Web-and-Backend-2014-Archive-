#!/usr/bin/perl -w
use feature qw{ switch };
use strict;
use warnings;
use DBI;

#Ce script cree les tactique pour les equipe n'ayant pas de joueur humain (donc CPU)

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
 
  my $requeteEquipe;
  my $requeteTactiqueEquipe1;
  my $requeteTactiqueEquipe2;
  my $requetePositions;
  my $requeteJoueur;
  my $requeteUpdatePosition;
    
  my $sthEquipe;
  my $stTactiqueEquipe1;
  my $stTactiqueEquipe2;
  my $stPositions;
  my $stJoueur;
  my $stUpdatePosition;
  
  
  my $i;
  my $tact;
  my $trouve;
  my $pos;
  my $x;
  my $y;

my @Equipes = ();
my $Tactique ;
my @result_tac1 = ();
my @result_tac2 = ();
  
  $requeteEquipe = "SELECT equipes.id FROM equipes WHERE equipes.id NOT IN (SELECT users.equipe_id FROM users)";
  $requeteTactiqueEquipe1 = "SELECT tactique_equipe1 FROM matchs, annees WHERE matchs.equipe1_id = ? AND matchs.num_journee = annees.journee";
  $requeteTactiqueEquipe2 = "SELECT tactique_equipe2 FROM matchs, annees WHERE matchs.equipe2_id = ? AND matchs.num_journee = annees.journee";
  $requetePositions = "SELECT position_j1_id, position_j2_id, position_j3_id, position_j4_id, position_j5_id, position_j6_id,
						position_j7_id, position_j8_id, position_j9_id, position_j10_id, position_j11_id FROM tactiques 
						WHERE tactiques.id = ?";
  $requeteJoueur = "SELECT joueurs.id FROM joueurs, contrats, equipes, matchs
					WHERE joueurs.id = contrats.joueur_id
					AND equipes.id  = contrats.equipe_id
					AND equipes.id = ?
					AND joueurs.numero = ?";
  $requeteUpdatePosition = "UPDATE positions SET x = ? , y = ?, id_joueur = ? WHERE id = ?";
  
  $sthEquipe = $dbh->prepare($requeteEquipe);
  $stTactiqueEquipe1 = $dbh->prepare($requeteTactiqueEquipe1);
  $stTactiqueEquipe2 = $dbh->prepare($requeteTactiqueEquipe2);
  $stPositions = $dbh->prepare($requetePositions);
  $stJoueur = $dbh->prepare($requeteJoueur);
  $stUpdatePosition = $dbh->prepare($requeteUpdatePosition);  

$sthEquipe->execute();

while(@Equipes = $sthEquipe->fetchrow_array)
{
	print " *********** Equipe n° :  $Equipes[0] ************************\n";
		$stTactiqueEquipe1->execute($Equipes[0]);
		$stTactiqueEquipe2->execute($Equipes[0]);
		#On recupere la tactique  si equipe 1
		my @result_tac1 = $stTactiqueEquipe1->fetchrow_array;
		if (defined($result_tac1[0])){				
			$Tactique = $result_tac1[0];
		}
		
		#On recupere la tactique si equipe 2
		my @result_tac2 = $stTactiqueEquipe2->fetchrow_array;
		if (defined($result_tac2[0])){				
			$Tactique = $result_tac2[0];
		}			

#On a recuperer la tactique de chaque equipe sans entraineur. On va les modifier "aléatoirement"
#Selectionner les 11 premiers joueurs
#Placer le gardien
#Placer les autres joueurs en lignes
	
	#On calcule le nombre de joueur par ligne
	#my $nbLigne = (int rand(4) + 1);
	my $nbLigne; 
	my @nbJoueurLignes =();
	my $nbJoueur = 10;
	my $nbJoueurLigne;
	my @Positions =();
	my $Joueur;
	my $x;
	my $y;
	my $xLigne;
	my $yLigne;
	my $j;
	
	for ( $j=1 ; $nbJoueur>0 ; $j++){
		if($nbJoueur > 0){
			if ($nbJoueur >4) {
				$nbJoueurLigne = int(rand (4) + 1);
			}
			else{
				$nbJoueurLigne = int(rand ($nbJoueur-1) + 1);
			}
			push @nbJoueurLignes, $nbJoueurLigne;
			$nbJoueur = $nbJoueur - $nbJoueurLigne;
			print "Ligne : $j , $nbJoueurLigne joueurs (reste $nbJoueur joueur) \n";
		}			
	} 
	$nbLigne = $j++;
	print "$nbLigne ligne(s) pour cette equipe \n";
	
	print " *********** Tactique n° : $Tactique ************\n";
		$stPositions->execute($Tactique);
		@Positions = $stPositions->fetchrow_array;
		
		#Gardien  	
		$stJoueur->execute($Equipes[0],1);
		$Joueur = $stJoueur->fetchrow_array;
		$x = int(rand(10) + 42);
		$y = 20 + 205;	
		$stUpdatePosition->execute( $x, $y,$Joueur,$Positions[0] );
		print " Gardien : $Joueur  : $x, $y \n";	
		my $idjoueur = 2;
		for (my $i=0; $i<= $nbLigne; $i++){
			if ($nbJoueurLignes[$i] > 0){
				$xLigne = int (rand(20) + 20 + (640/($nbLigne +1)) * ($i+1));
				$yLigne = int (rand(10) + 10 + (410/($nbJoueurLignes[$i] +1))) ;

				for (my $k=0; $k< $nbJoueurLignes[$i];$k++){				
					$x = $xLigne + int(rand (10));
					$y = $yLigne *($k+1) + int (rand(10));
					#$idjoueur = ($i+1) * ($k+1);
					if ($idjoueur <= 11){
						$stJoueur->execute($Equipes[0],$idjoueur );
						$Joueur = $stJoueur->fetchrow_array;
						$stUpdatePosition->execute( $x, $y,$Joueur,$Positions[$idjoueur -1] );
						print " Joueur $idjoueur ($Joueur($i,$k)) : $x,$y\n";
						$idjoueur++;
					}
					else
					{
						print " EEEEEEEEEEEEERRRRRRRRRRROOOOOOOOOOORRRRRRRRRR TTTTTRRRRRRRROOOOOOOOOPPPPP de joueurs **********************************\n";
					}
				}	
			
			}
			
		}	
		
			#$x = int(40+rand(640));
			#$y = int(20+rand(410));
}
