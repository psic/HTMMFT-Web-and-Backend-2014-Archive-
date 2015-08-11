#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;

#Ce script génére les clubs et les equipes

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

my @listeEquipe = ();
my @listeJournee =();
my @listeNumJournee = ();
my @result = ();
my @journee_ID = ();

my $a;
my $e;
my $j;

  my $requeteEquipeDivision;
  my $requeteMatch;
  my $requeteJournee;
  my $requeteUneJournee;

  my $sthEquipeDivision;
  my $sthMatch;
  my $sthJournee;
  my $sthUneJournee;

  $requeteEquipeDivision = "SELECT Equipe.Equipe_ID 
			    FROM Equipe, Saison, Annee, Calendrier, Division
			    WHERE Equipe.Equipe_ID = Saison.Equipe_ID
			    AND Saison.Calendrier_ID = Calendrier.Calendrier_ID
			    AND Division.Division_ID = Calendrier.Division_ID
			    AND Division.Nom = ?
			    AND Calendrier.Annee = 0;";

  $requeteMatch = "INSERT INTO `Match` (`Equipe1_ID`,`Equipe2_ID`,`Journee_ID`) VALUES (?,?,?);";
 
  $requeteJournee = "SELECT Journee.Journee_ID, Journee.NumJournee
		      FROM Journee, Calendrier, Saison
		      WHERE Saison.Equipe_ID = ?
		      AND Saison.Calendrier_ID = Calendrier.Calendrier_ID
		      AND Calendrier.Annee = 0
		      AND Journee.Calendrier_ID = Calendrier.Calendrier_ID;";

  $requeteUneJournee = "SELECT Journee.Journee_ID
		      FROM Journee, Calendrier, Saison
		      WHERE Saison.Equipe_ID = ?
		      AND Journee.NumJournee = ?
		      AND Saison.Calendrier_ID = Calendrier.Calendrier_ID
		      AND Calendrier.Annee = 0
		      AND Journee.Calendrier_ID = Calendrier.Calendrier_ID;";


$sthEquipeDivision = $dbh->prepare($requeteEquipeDivision);
$sthMatch = $dbh->prepare($requeteMatch);
$sthJournee = $dbh->prepare($requeteJournee);
$sthUneJournee = $dbh->prepare($requeteUneJournee);

$sthEquipeDivision->execute('Nord');

print "\n NORD \n";

while(@result = $sthEquipeDivision->fetchrow_array)
{
push(@listeEquipe, $result[0]);
}

$a=1;
$e=0;
$j=0;
#TODO Pour toute les divisions

#Pour chaque Equipe de cette division
foreach my $Equipe (@listeEquipe)
{
  $e = $e + 1;
  #On recupere la liste des journee pour l equipe en cours
  $sthJournee->execute($Equipe);
  @listeJournee = ();
  @listeNumJournee = ();
  @result = ();
  print "\n Equipe : $Equipe \n";
  while(@result = $sthJournee->fetchrow_array)
  {
    push(@listeJournee, $result[0]);
    push(@listeNumJournee, $result[1]);
    #print "journee : $result[0] : ";
  }  
  
  #print @listeJournee;
  
  $a = $e;
  $j = 0;
  @journee_ID = ();
  #TODO rajouter les matchs correspondant des equipes adverse pour la m�me journee
  foreach my $journee (@listeJournee)
  {
    print "Journee $listeNumJournee[$j] (ID: $journee)  /  ";
    if (( $listeNumJournee[$j] >= $e && $listeNumJournee[$j] <= scalar(@listeEquipe)-1 ) ||  $listeNumJournee[$j]>= scalar(@listeEquipe)-1 +$e )
    {
     $sthUneJournee->execute($listeEquipe[$a],$listeNumJournee[$j]);
     @journee_ID = $sthUneJournee->fetchrow_array; 
     print "(ID adversaire : $journee_ID[0]) / ";
     if($e % 2 == 1)
     { 
	# si le numero de journee est impaire l equipe joue a domicile sinon l equipe q l exterieur
	if ($j % 2 == 1)
	{
	  $sthMatch->execute($Equipe,$listeEquipe[$a],$journee);
	  print "$Equipe - $listeEquipe[$a] \n";
	  $sthMatch->execute($listeEquipe[$a],$Equipe,$journee_ID[0]);
	}
	else
	{
	  $sthMatch->execute($listeEquipe[$a],$Equipe,$journee);
	  print "$listeEquipe[$a] - $Equipe  \n";
	  $sthMatch->execute($Equipe,$listeEquipe[$a],$journee_ID[0]);
	}
     }
     else
     {
	# si le numero de journee est paire l equipe joue a domicile sinon l equipe q l exterieur
	if ($j % 2 == 1)
	{
	  $sthMatch->execute($listeEquipe[$a],$Equipe,$journee);
	  print "$listeEquipe[$a] - $Equipe  \n";
	  $sthMatch->execute($Equipe,$listeEquipe[$a],$journee_ID[0]);
	}
	else
	{
	  $sthMatch->execute($Equipe,$listeEquipe[$a],$journee);
	  print "$Equipe - $listeEquipe[$a] \n";
	  $sthMatch->execute($listeEquipe[$a],$Equipe,$journee_ID[0]);
	}
     }
      $a = $a + 1;
      if ($listeNumJournee[$j] == (int (scalar(@listeEquipe)- 1)) ) #MAZero de l adversaire pour les match retour
      {
	$a = $e;
      }
   }
  else
  {
    print "\n";
  }
  $j = $j + 1;
 }
}
