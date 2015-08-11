package com.htmmft.playMatch;



import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.htmmft.match.Equipe;
import com.htmmft.match.Joueur;
import com.htmmft.match.Match;

public class NoBase {


	public NoBase(){
	}

	public Match getMatch() {
		//System.out.println("Match ID: " + rs_match.getString(1));
		Match match = CreateMatch();
		return match;
	}

	private Match CreateMatch() {
		Match match = new Match(0,0);
		Equipe equipe1 = CreateEquipe(true, match);
		Equipe equipe2 = CreateEquipe(false,match);
		match.setEquipe1(equipe1);
		match.setEquipe2(equipe2);
		equipe1.setAdversaire(equipe2);
		equipe2.setAdversaire(equipe1);
		return match;

	}

	private Equipe CreateEquipe(boolean sens, Match match) {
		Equipe equipe = new Equipe(0,sens,match);
		//	System.out.println("	tactique ID: " + id_tactique);
		for (int i=1 ; i <= 11; i++){
			Joueur joueur= CreateJoueur(equipe,sens,i);
			equipe.addJoueur(joueur);
		}
		return equipe;
	}

	private Joueur CreateJoueur(Equipe equipe, boolean sens, int i) {
		int x,y;
		Joueur joueur=null;
			switch (i) {

			case 1:
				x=playMatchWOBD.min_x +5;
				y=playMatchWOBD.mid_y + playMatchWOBD.min_y ;
				break;
			case 2:
				x=playMatchWOBD.mid_x - 150;
				y=playMatchWOBD.mid_y - 40;
				break;
			case 3:
				x=playMatchWOBD.mid_x - 150;
				y=playMatchWOBD.mid_y - 10;
				break;
			case 4:
				x=playMatchWOBD.mid_x - 150;
				y=playMatchWOBD.mid_y + 30;
				break;
			case 5:
				x=playMatchWOBD.mid_x - 150;
				y=playMatchWOBD.mid_y + 60;
				break;
			case 6:
				x=playMatchWOBD.mid_x - 75;
				y=playMatchWOBD.mid_y - 75;
				break;
			case 7:
				x=playMatchWOBD.mid_x - 75;
				y=playMatchWOBD.mid_y + 75;
				break;
			case 8:
				x=playMatchWOBD.mid_x - 75;
				y=playMatchWOBD.mid_y - 40;
				break;
			case 9:
				x=playMatchWOBD.mid_x - 75;
				y=playMatchWOBD.mid_y + 40;
				break;
			case 10:
				x=playMatchWOBD.mid_x - 30;
				y=playMatchWOBD.mid_y ;
				break;
			case 11:
				x=playMatchWOBD.mid_x - 10;
				y=playMatchWOBD.mid_y + 30 ;
				break;
			default:
				x=playMatchWOBD.min_x + playMatchWOBD.mid_x;
				y=playMatchWOBD.min_y + playMatchWOBD.mid_y;
				break;
			}
			if (sens)
				joueur =new Joueur(i, x, y,equipe);
			else
				joueur =new Joueur(i+11, x, y,equipe);

		joueur.setAge(20);
		joueur.setBlessure(0);
		joueur.setCond(100);
		joueur.setCtr((int)(50 + Math.random()*50));
		joueur.setDef((int)(50 + Math.random()*50));
		joueur.setDrt((int)(50 + Math.random()*50));
		joueur.setGch((int)(50 + Math.random()*50));
		joueur.setMental((int)(50 + Math.random()*50));
		joueur.setMoral((int)(50 + Math.random()*50));
		joueur.setOff((int)(50 + Math.random()*50));
		joueur.setPhysique((int)(50 + Math.random()*50));
		joueur.setTactique((int)(50 + Math.random()*50));
		joueur.setTalent((int)(50 + Math.random()*50));
		joueur.setTechnique((int)(50 + Math.random()*50));
		joueur.setVitesse((int)(50 + Math.random()*50));
		joueur.setXp((int)(50 + Math.random()*50));

		return joueur;
	}

}
