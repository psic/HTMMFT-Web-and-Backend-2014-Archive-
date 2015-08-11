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
my $d;

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

  $requeteEquipeDivision = "SELECT equipes.id 
			    FROM equipes, saisons, divisions, historiques, annees
			    WHERE historiques.equipe_id = equipes.id
			    AND historiques.saison_id = saisons.id
			    AND saisons.division_id = divisions.id
			    AND divisions.nom = ?
			    AND annees.id = saisons.annee_id
			    AND annees.annee_courante = 0;";

  $requeteMatch = "INSERT INTO `matchs` (`saison_id`,`equipe1_id`,`equipe2_id`,`num_journee`) VALUES (?,?,?,?);";
 
  $requeteDivision = "SELECT nom
		      FROM divisions;";

  
$sthEquipeDivision = $dbh->prepare($requeteEquipeDivision);
$sthMatch = $dbh->prepare($requeteMatch);
$sthDivision = $dbh->prepare($requeteDivision);

$sthDivision->execute();

while(@result = $sthDivision->fetchrow_array)
{
push(@listeDivision, $result[0]);
}

$d=0;

foreach my $Division (@listeDivision)
{

$d= $d + 1;

$sthEquipeDivision->execute($Division);

print "\n $Division \n";
@listeEquipe = ();
@listeEquipe1 = ();
@listeEquipe2 = ();

while(@result = $sthEquipeDivision->fetchrow_array)
{
push(@listeEquipe, $result[0]);
print "\n $result[0]";
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
	  $sthMatch->execute($d,$listeEquipe1[$e],$listeEquipe2[$e],$j);
	  print " $listeEquipe1[$e] - $listeEquipe2[$e]  \n";	  
	}
	else
	{
	  $sthMatch->execute($d,$listeEquipe2[$e],$listeEquipe1[$e],$j);
	  print " $listeEquipe2[$e] - $listeEquipe1[$e]  \n";	  
	}
      }
      else #Pour les autres equipes, on alterne domicile et exterieur
      {
	if ( $e % 2 == 1)
	{
	  $sthMatch->execute($d,$listeEquipe1[$e],$listeEquipe2[$e],$j);
	  print " $listeEquipe1[$e] - $listeEquipe2[$e]  \n";	  
	}
	else
	{
	  $sthMatch->execute($d,$listeEquipe2[$e],$listeEquipe1[$e],$j);
	  print " $listeEquipe2[$e] - $listeEquipe1[$e]  \n";
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
	  $sthMatch->execute($d,$listeEquipe1[$e],$listeEquipe2[$e],$j);
	  print " $listeEquipe1[$e] - $listeEquipe2[$e]  \n";	  
	}
	else
	{
	  $sthMatch->execute($d,$listeEquipe2[$e],$listeEquipe1[$e],$j);
	  print " $listeEquipe2[$e] - $listeEquipe1[$e]  \n";	  
	}
      }
      else #Pour les autres equipes, on alterne domicile et exterieur
      {
	if ( $e % 2 == 1)
	{
	  $sthMatch->execute($d,$listeEquipe2[$e],$listeEquipe1[$e],$j);
	  print " $listeEquipe2[$e] - $listeEquipe1[$e]  \n";	  
	}
	else
	{
	  $sthMatch->execute($d,$listeEquipe1[$e],$listeEquipe2[$e],$j);
	  print " $listeEquipe1[$e] - $listeEquipe2[$e]  \n";
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