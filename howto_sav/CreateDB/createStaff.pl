#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;

#Ce script génére les Staff

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
my @contenu;

open(NAME, "name.txt") || die "Erreur E/S : $!\n";
@contenu = <NAME>;
my @name;
foreach (@contenu) {
    push(@name, split(/ /, $_));   
   }

close (NAME);

open(FIRSTNAME, "name.txt") || die "Erreur E/S : $!\n";
@contenu = <FIRSTNAME>;
my @firstname;
foreach (@contenu) {
    push(@firstname, split(/ /, $_));   
   }

close (FIRSTNAME);

#my $fini = FALSE;
my $nbteam = 1;
my $nbjoueur = 1;

  my $requete;
  my $sth;

  my $contratID;
  my $staffID;
  my $equipeID;
  my $nbequipe;
  my $nom;
  my $prenom;
  my $age; 
  my $xp;
  my $talent;
  my $tactique;
  my $technique; 
  my $physique;
  my $medecine;
  my $recrutement;
  my $poste;
  my $mental;
#  my totalEquipe = 7700;
  my $total = 0;
  my $totalEquipe = 0;
  my $off;
  my $def;
  my $xppos;
  my $dureeContrat;
  my $moisFin;
  my $salaire;

  my $agemoy = 0; 
  my $xpmoy = 0;
  my $talentmoy = 0;
  my $tactiquemoy = 0;
  my $techniquemoy = 0;
  my $physiquemoy = 0;
  my $mentalmoy = 0;
  my $recrutementmoy = 0;
  my $medecinemoy = 0;
  
  $nbequipe = 0;
  $staffID = 0;
  $contratID = 0;
  $equipeID = 0;
   
  my $requeteStaff;
  my $requeteContrat;
  my $sthContrat;
  my $sthStaff;

	$requeteStaff = "INSERT INTO staffs (nom, prenom, age, xp, talent, tactique, technique, physique,mental,medecine,recrutement, off, def)
	VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?); ";
	$sthStaff = $dbh->prepare($requeteStaff);

	$requeteContrat = " INSERT INTO staff_contrats (annee_debut,mois_debut, duree, annee_fin, mois_fin, salaire, equipe_id, staff_id,poste) 
	VALUES (0,0,?, ?, ?, ?, ?, ?,0);";	
	$sthContrat = $dbh->prepare($requeteContrat);

   while($nbequipe < (8*16)+1) 
    {
      while($totalEquipe <= 2700)
      {
	print "Joueur : $nbjoueur / $staffID \n";
	$prenom = $firstname[int(rand(scalar @firstname))];
	$nom = $name[int(rand(scalar @name))];
	$age = 35 + int(rand(35));
	$xp = ($age -34) + int(rand($age ** 2)/12.5);
	$talent = int(rand(99) + 1);
	$tactique = int(rand(95) + 5);
	$technique = int(rand(95) + 5);
	
	$talent =  int(rand(99) + 1);
	$mental = int(rand(98) + 2);
	
	$off = int (rand (99) + 1);
	$def = int (rand (99) + 1);
	
	$xppos = int(50 + (rand($xp ** 2)/ $xp));

#Kine
	if ($nbjoueur <= 1){
	  $physique = int((rand($xppos) + rand (50) + 50)/2) ;
	  $medecine = int((rand($xppos) + rand (30) + 70)/2) ;
	  $recrutement = int (rand($xppos));
	}
	
#Recruteur
	if ($nbjoueur >1 && $nbjoueur <= 3){
	  $physique = int(rand($xppos));
	  $medecine = int(rand($xppos));
	  $recrutement = int ((rand($xppos) + rand (30) + 70) / 2 );
	}

#PrepPhysique
	if ($nbjoueur > 3 && $nbjoueur <= 4){
	  $physique = int((rand($xppos) + rand (30) + 70)/2) ;
	  $medecine = int((rand($xppos) + rand (50) + 50)/2) ;
	  $recrutement = int (rand($xppos));
	}

#Entraineur Autre
       if ($nbjoueur > 5){
	  $physique = int(rand($xppos));
	  $medecine = int(rand($xppos));
	  $recrutement = int (rand($xppos));
      }
   
	$agemoy = $agemoy + $age; 
	$xpmoy = $xpmoy + $xp;
	$talentmoy = $talentmoy +$talent;
	$tactiquemoy = $tactiquemoy + $tactique;
	$techniquemoy = $techniquemoy + $technique;
	$physiquemoy = $physiquemoy + $physique;
	$mentalmoy = $mentalmoy + $mental;	
	$recrutementmoy = $recrutementmoy + $recrutement;
	$medecinemoy = $medecinemoy + $medecine;

	$total = $talent + $tactique + $technique + $physique  + $talent + $mental + $recrutement + $medecine + $off + $def;
	$totalEquipe = $totalEquipe + $total;
      

  if ($xp > 100){
    $xp = 100;
  }
  if ($talent > 100){
    $talent = 100;
  }
  if ($tactique > 100){
    $tactique = 100;
  }
  if ($technique > 100){
    $technique = 100;
  }
  if ($physique > 100){
    $physique = 100;
  }
  if ($mental > 100){
    $mental = 100;
  }
  if ($off > 100){
    $off = 100;
  }
  if ($def > 100){
    $def = 100;
  }
  if ($medecine > 100){
    $medecine = 100;
  }
  if ($recrutement > 100){
    $recrutement = 100;
}
  
	print "Nom : $prenom $nom, $age ans \n";
	print "xp : $xp \n";
	print "$def / $off \n";
	print "talent : $talent \n";
	print "tactique : $tactique \n";
	print "technique : $technique \n";
	print "physique : $physique \n";
	print "medecine : $medecine \n";
	print "recrutement : $recrutement \n";
	print "mental : $mental \n";
	print "Total : $total / $totalEquipe \n";
	
	print "----------------------------------------------------- \n";
	#$requeteJoueur = "INSERT INTO Joueur (Nom, Prenom, Age, Xp, Talent, Tactique, Technique, Physique, Vitesse, Mental, Off, Def,Drt,Ctr, Gch, Liste_Transfert,Liste_Pret)
	#VALUES ('$nom', '$prenom',$age,$xp,$talent,$tactique,$technique,$physique,$vitesse,$mental,$off,$def,$dr,$ctr,$gch,0,0); ";
	#$sthJoueur = $dbh->prepare($requeteJoueur);
	$sthStaff->execute($nom, $prenom,$age,$xp,$talent,$tactique,$technique,$physique,$mental,$medecine,$recrutement,$off,$def);
	
  
	$dureeContrat = int(rand(4))+1;
	$moisFin = int(rand(11))+1;
	$salaire = int( ($xppos + $xp*2 + $talent*3 + $tactique + $technique + $physique + $medecine + $recrutement + $mental*2 + $dureeContrat *100 )/($dureeContrat + 12) )*10; 
	
	#$requeteContrat = " INSERT INTO Contrat (Annee_debut,Mois_debut, Duree, Anne_fin, Mois_fin, Salaire, Equipe_ID, Contractant_ID) 
	#VALUES (0,0,$dureeContrat, $dureeContrat, $moisFin, $salaire, $equipeID, $joueurID);";
	
	#$sthContrat = $dbh->prepare($requeteContrat);
	$sthContrat->execute($dureeContrat, $dureeContrat, $moisFin, $salaire, $equipeID, $staffID);

	$nbjoueur = $nbjoueur +1;
	$staffID = $staffID + 1;
	$contratID = $contratID + 1;
  } 
	
	$agemoy = int($agemoy / ($nbjoueur -1)); 
	$xpmoy = int($xpmoy / ($nbjoueur -1));
	$talentmoy = int($talentmoy / ($nbjoueur -1));
	$tactiquemoy = int($tactiquemoy / ($nbjoueur -1));
	$techniquemoy = int($techniquemoy / ($nbjoueur -1));
	$physiquemoy = int($physiquemoy / ($nbjoueur -1));
	$recrutementmoy = int($recrutementmoy / ($nbjoueur -1));
	$medecinemoy = int ($medecinemoy / ($nbjoueur - 1));
	$mentalmoy = int($mentalmoy / ($nbjoueur -1));	
	
      print "Total Equipe : $totalEquipe \n";
      print "moyenne : \n";
      print "age : $agemoy \n";
      print "xp : $xpmoy \n";
      print "talent : $talentmoy \n";
      print "tactique : $tactiquemoy \n";
      print "technique : $techniquemoy \n";
      print "physique : $physiquemoy \n";
      print "recrutement : $recrutementmoy \n";
      print "medecine : $medecinemoy \n";
      print "mental : $mentalmoy \n";
#      $nbteam = $nbteam + 1;
#      $nbjoueur = 1;
 #   }
#   $nbligue = $nbligue + 1; 
  #}
 # }
  $nbequipe = $nbequipe + 1;
  $equipeID = $equipeID + 1;
  $totalEquipe = 0;
  $nbjoueur = 1;
  $agemoy = 0;
  $xpmoy = 0;
  $talentmoy = 0;
  $tactiquemoy = 0;
  $techniquemoy = 0;
  $physiquemoy = 0;
  $recrutementmoy = 0;
  $medecinemoy = 0;
  $total = 0;
}



# Joueur sans contrat

my $nbjoueurSC = 0;
$nbjoueur = 1;

print "\n *************************************\n Joueur SANS CONTRAT \n ****************************** \n";

  while($nbjoueurSC <= 150)
      {
	print "Joueur : $nbjoueur / $staffID \n";
	$prenom = $firstname[int(rand(scalar @firstname))];
	$nom = $name[int(rand(scalar @name))];
	$age = 35 + int(rand(35));
	$xp = ($age -34) + int(rand($age ** 2)/12.5);
	$talent = int(rand(99) + 1);
	$tactique = int(rand(95) + 5);
	$technique = int(rand(95) + 5);
	
	$talent =  int(rand(99) + 1);
	$mental = int(rand(98) + 2);
	
	$off = int (rand (99) + 1);
	$def = int (rand (99) + 1);
	
	$xppos = int(50 + (rand($xp ** 2)/ $xp));

#Kine
	if ($nbjoueur <= 1){
	  $physique = int((rand($xppos) + rand (50) + 50)/2) ;
	  $medecine = int((rand($xppos) + rand (30) + 70)/2) ;
	  $recrutement = int (rand($xppos));
	}
	
#Recruteur
	if ($nbjoueur >1 && $nbjoueur <= 3){
	  $physique = int(rand($xppos));
	  $medecine = int(rand($xppos));
	  $recrutement = int ((rand($xppos) + rand (30) + 70) / 2 );
	}

#PrepPhysique
	if ($nbjoueur > 3 && $nbjoueur <= 4){
	  $physique = int((rand($xppos) + rand (30) + 70)/2) ;
	  $medecine = int((rand($xppos) + rand (50) + 50)/2) ;
	  $recrutement = int (rand($xppos));
	}

#Entraineur Autre
       if ($nbjoueur > 5){
	  $physique = int(rand($xppos));
	  $medecine = int(rand($xppos));
	  $recrutement = int (rand($xppos));
      }
   
    if ($nbjoueur > 7)
    {
      $nbjoueur = 0;
    }

  if ($xp > 100){
    $xp = 100;
  }
  if ($talent > 100){
    $talent = 100;
  }
  if ($tactique > 100){
    $tactique = 100;
  }
  if ($technique > 100){
    $technique = 100;
  }
  if ($physique > 100){
    $physique = 100;
  }
  if ($mental > 100){
    $mental = 100;
  }
  if ($off > 100){
    $off = 100;
  }
  if ($def > 100){
    $def = 100;
  }
  if ($medecine > 100){
    $medecine = 100;
  }
  if ($recrutement > 100){
    $recrutement = 100;
}
  
	print "Nom : $prenom $nom, $age ans \n";
	print "xp : $xp \n";
	print "$def / $off \n";
	print "talent : $talent \n";
	print "tactique : $tactique \n";
	print "technique : $technique \n";
	print "physique : $physique \n";
	print "medecine : $medecine \n";
	print "recrutement : $recrutement \n";
	print "mental : $mental \n";
	print "Total : $total \n";
	
	print "----------------------------------------------------- \n";
	#$requeteJoueur = "INSERT INTO Joueur (Nom, Prenom, Age, Xp, Talent, Tactique, Technique, Physique, Vitesse, Mental, Off, Def,Drt,Ctr, Gch, Liste_Transfert,Liste_Pret)
	#VALUES ('$nom', '$prenom',$age,$xp,$talent,$tactique,$technique,$physique,$vitesse,$mental,$off,$def,$dr,$ctr,$gch,0,0); ";
	#$sthJoueur = $dbh->prepare($requeteJoueur);
	$sthStaff->execute($nom, $prenom,$age,$xp,$talent,$tactique,$technique,$physique,$mental,$medecine,$recrutement,$off,$def);
			

	$nbjoueurSC = $nbjoueurSC +1;
	$staffID = $staffID + 1;
	$nbjoueur = $nbjoueur +1;
  } 
	
