#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;

#Ce script genere les matchs

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
my @listeEquipe1 = ();
my @listeEquipe2 = ();
my @listeJournee =();
my @listeNumJournee = ();
my @result = ();
my @journee_ID = ();
my @listeDivision = ();

my $a;
my $e;
my $j;

  my $requeteEquipeDivision;
  my $requeteMatch;
  my $requeteJournee;
  my $requeteUneJournee;
  my $requeteDivision;

  my $sthEquipeDivision;
  my $sthMatch;
  my $sthJournee;
  my $sthUneJournee;
  my $sthDivision;

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

  $requeteDivision = "SELECT Nom
		      FROM Division;";

  
$sthEquipeDivision = $dbh->prepare($requeteEquipeDivision);
$sthMatch = $dbh->prepare($requeteMatch);
$sthJournee = $dbh->prepare($requeteJournee);
$sthUneJournee = $dbh->prepare($requeteUneJournee);
$sthDivision = $dbh->prepare($requeteDivision);

$sthDivision->execute();
while(@result = $sthDivision->fetchrow_array)
{
push(@listeDivision, $result[0]);
}

foreach my $Division (@listeDivision)
{

$sthEquipeDivision->execute($Division);

print "\n $Division \n";
@listeEquipe = ();
@listeEquipe1 = ();
@listeEquipe2 = ();

while(@result = $sthEquipeDivision->fetchrow_array)
{
push(@listeEquipe, $result[0]);
}

$e = 1;
#Pour faire le round robin on fait 2 liste d equipe
foreach my $Equipe (@listeEquipe)
{
 if ($e <= (scalar (@listeEquipe) /2))
  {
    push (@listeEquipe1, $Equipe);
  }
  else
  {
    push (@listeEquipe2, $Equipe);
  }
  $e = $e + 1;
}

$a=1;
$e=0;
$j=0;

#Pour chaque Journee
for ($j=1;$j<= (((scalar(@listeEquipe)-1) *2));$j++)
{
  print "\n   Journee  : $j \n";
  if ($j <= (scalar(@listeEquipe)) ) #Retour
  {
    for ( $e = 0; $e < (scalar (@listeEquipe1));$e++)#chaque equipe
    {
      if($e == 0) #Pour la premiere equipe on alterne domicile et exterieur selon la journee
      {
	if ($j % 2 == 1)
	{
	  $sthUneJournee->execute($listeEquipe1[$e],$j);
	  @journee_ID = $sthUneJournee->fetchrow_array; 
	  $sthMatch->execute($listeEquipe1[$e],$listeEquipe2[$e],$journee_ID[0]);
	  print "($journee_ID[0]) $listeEquipe1[$e] -";
	  $sthUneJournee->execute($listeEquipe2[$e],$j);
	  @journee_ID = $sthUneJournee->fetchrow_array;
	  $sthMatch->execute($listeEquipe1[$e],$listeEquipe2[$e],$journee_ID[0]);
	  print " $listeEquipe2[$e] ($journee_ID[0]) \n";	  
	}
	else
	{
	  $sthUneJournee->execute($listeEquipe2[$e],$j);
	  @journee_ID = $sthUneJournee->fetchrow_array; 
	  $sthMatch->execute($listeEquipe2[$e],$listeEquipe1[$e],$journee_ID[0]);
	  print "($journee_ID[0]) $listeEquipe2[$e] -";
	  $sthUneJournee->execute($listeEquipe1[$e],$j);
	  @journee_ID = $sthUneJournee->fetchrow_array;
	  $sthMatch->execute($listeEquipe2[$e],$listeEquipe1[$e],$journee_ID[0]);
	  print " $listeEquipe1[$e] ($journee_ID[0]) \n";
	}
      }
      else #Pour les autres equipes, on alterne domicile et exterieur
      {
	if ( $e % 2 == 1)
	{
	  $sthUneJournee->execute($listeEquipe1[$e],$j);
	  @journee_ID = $sthUneJournee->fetchrow_array; 
	  $sthMatch->execute($listeEquipe1[$e],$listeEquipe2[$e],$journee_ID[0]);
	  print "($journee_ID[0]) $listeEquipe1[$e] -";
	  $sthUneJournee->execute($listeEquipe2[$e],$j);
	  @journee_ID = $sthUneJournee->fetchrow_array;
	  $sthMatch->execute($listeEquipe1[$e],$listeEquipe2[$e],$journee_ID[0]);
	  print " $listeEquipe2[$e] ($journee_ID[0]) \n";
	}
	else
	{
	  $sthUneJournee->execute($listeEquipe2[$e],$j);
	  @journee_ID = $sthUneJournee->fetchrow_array; 
	  $sthMatch->execute($listeEquipe2[$e],$listeEquipe1[$e],$journee_ID[0]);
	  print "($journee_ID[0]) $listeEquipe2[$e] -";
	  $sthUneJournee->execute($listeEquipe1[$e],$j);
	  @journee_ID = $sthUneJournee->fetchrow_array;
	  $sthMatch->execute($listeEquipe2[$e],$listeEquipe1[$e],$journee_ID[0]);
	  print " $listeEquipe1[$e] ($journee_ID[0]) \n";
	}
      }
     }
    }
     else # match retour
     {
      for ( $e = 0; $e < (scalar (@listeEquipe1));$e++) #chaque equipe
      {
      if($e == 0) #Pour la premiere equipe on alterne domicile et exterieur selon la journee
      {
	if ($j % 2 == 1)
	{
	  $sthUneJournee->execute($listeEquipe1[$e],$j);
	  @journee_ID = $sthUneJournee->fetchrow_array; 
	  $sthMatch->execute($listeEquipe1[$e],$listeEquipe2[$e],$journee_ID[0]);
	  print "($journee_ID[0]) $listeEquipe1[$e] -";
	  $sthUneJournee->execute($listeEquipe2[$e],$j);
	  @journee_ID = $sthUneJournee->fetchrow_array;
	  $sthMatch->execute($listeEquipe1[$e],$listeEquipe2[$e],$journee_ID[0]);
	  print " $listeEquipe2[$e] ($journee_ID[0]) \n";	  
	}
	else
	{
	  $sthUneJournee->execute($listeEquipe2[$e],$j);
	  @journee_ID = $sthUneJournee->fetchrow_array; 
	  $sthMatch->execute($listeEquipe2[$e],$listeEquipe1[$e],$journee_ID[0]);
	  print "($journee_ID[0]) $listeEquipe2[$e] -";
	  $sthUneJournee->execute($listeEquipe1[$e],$j);
	  @journee_ID = $sthUneJournee->fetchrow_array;
	  $sthMatch->execute($listeEquipe2[$e],$listeEquipe1[$e],$journee_ID[0]);
	  print " $listeEquipe1[$e] ($journee_ID[0]) \n";
	}
      }
      else #Pour les autres equipes, on alterne domicile et exterieur
      {
	if ( $e % 2 == 1)
	{
	  $sthUneJournee->execute($listeEquipe2[$e],$j);
	  @journee_ID = $sthUneJournee->fetchrow_array; 
	  $sthMatch->execute($listeEquipe2[$e],$listeEquipe1[$e],$journee_ID[0]);
	  print "($journee_ID[0]) $listeEquipe2[$e] -";
	  $sthUneJournee->execute($listeEquipe1[$e],$j);
	  @journee_ID = $sthUneJournee->fetchrow_array;
	  $sthMatch->execute($listeEquipe2[$e],$listeEquipe1[$e],$journee_ID[0]);
	  print " $listeEquipe1[$e] ($journee_ID[0]) \n";
	}
	else
	{
	  $sthUneJournee->execute($listeEquipe1[$e],$j);
	  @journee_ID = $sthUneJournee->fetchrow_array; 
	  $sthMatch->execute($listeEquipe1[$e],$listeEquipe2[$e],$journee_ID[0]);
	  print "($journee_ID[0]) $listeEquipe1[$e] -";
	  $sthUneJournee->execute($listeEquipe2[$e],$j);
	  @journee_ID = $sthUneJournee->fetchrow_array;
	  $sthMatch->execute($listeEquipe1[$e],$listeEquipe2[$e],$journee_ID[0]);
	  print " $listeEquipe2[$e] ($journee_ID[0]) \n";
	}
      }

     }
    }

    #On tourne le numero des equipe sauf le "1"
    @listeEquipe = ();
    push (@listeEquipe,$listeEquipe1[0]);
    push (@listeEquipe,$listeEquipe2[0]);
      
     for ($e=1; $e < (scalar (@listeEquipe1)-1);$e++)
    {
      push (@listeEquipe,$listeEquipe1[$e]);
    }
     for ($e=1; $e < (scalar (@listeEquipe2));$e++)
    {
      push (@listeEquipe,$listeEquipe2[$e]);
    }
    push (@listeEquipe,$listeEquipe1[scalar(@listeEquipe1)-1]);
    
    #Pour faire le round robin on fait 2 liste d equipe
  @listeEquipe1 = ();
  @listeEquipe2 = ();
  $e = 1;
  foreach my $Equipe (@listeEquipe)
  {
  if ($e <= (scalar (@listeEquipe) /2))
    {
      push (@listeEquipe1, $Equipe);
    }
    else
    {
      push (@listeEquipe2, $Equipe);
    }
    $e = $e + 1;
  }
}
}