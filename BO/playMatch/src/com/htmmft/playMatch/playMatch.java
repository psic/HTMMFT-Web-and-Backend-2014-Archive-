package com.htmmft.playMatch;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import com.htmmft.match.*;

public class playMatch {
	final static String R_MATCH = "SELECT matchs.id, matchs.num_journee FROM matchs, annees WHERE matchs.num_journee = annees.journee";
	final static String R_TACTIQUE_EQUIPE1 = "SELECT tactique_equipe1 FROM matchs WHERE matchs.id =";
	final static String R_TACTIQUE_EQUIPE2 = "SELECT tactique_equipe2 FROM matchs WHERE matchs.id =";
	final static String R_POSITIONS = "SELECT position_j1_id, position_j2_id, position_j3_id, position_j4_id, position_j5_id, position_j6_id, " +
								"position_j7_id, position_j8_id, position_j9_id, position_j10_id, position_j11_id FROM tactiques " +
								"WHERE tactiques.id =";
	final static String R_JOUEUR = "SELECT age,xp,talent,tactique,technique,physique,vitesse,mental,off,def,drt,ctr,gch,cond,blessure,moral " +
									"FROM joueurs WHERE id =";
	final static String R_POSITION = "SELECT id_joueur, x, y FROM positions WHERE id =";
	//final static String R_UPD_SCORE = "SELECT id_joueur, x, y FROM positions WHERE id = ?";
	
	public final static int min_x = 30;
	public final static int min_y = 10 ;
	public final static int max_x = min_x + 660;
	public final static int max_y = min_y + 430;
	public final static int mid_x = (max_x - min_x) /2;
	public final static int mid_y = (max_y - min_y) /2;

	final static String MATCHS_FOLDER="./matchs";
	
	private static ArrayList<Match> matchs;
	private static Base BD_access;
	
	public static void main(String[] args) throws IOException{
	 BD_access = new Base();
	 BD_access.connect();
	 matchs =new ArrayList<Match>();
	 matchs = BD_access.getMatch(R_MATCH, R_TACTIQUE_EQUIPE1, R_TACTIQUE_EQUIPE2, R_POSITIONS, R_POSITION, R_JOUEUR);
	 prepareFiles();
	 prepareMatch();
	 jouerMatch();
	 closeFiles();
	 BD_access.close();
	 System.out.println("FINI!!");
	}

	private static void jouerMatch() throws IOException {
		for (Match match :matchs){
			if (match.getId() == 114)
				match.jouer();
		}
	}

	private static void closeFiles() throws IOException {
		for ( Match match :matchs){
			match.getFichier().write("}");
			match.getFichier().close();
		}
		
	}

	private static void prepareFiles() throws IOException {
		new File(MATCHS_FOLDER + "/" + matchs.get(1).getNum_journee() ).mkdir();
		for ( Match match :matchs){
			match.setFichier(new FileWriter(MATCHS_FOLDER + "/" + matchs.get(1).getNum_journee() + "/" + match.getId() + ".json"));
		}
		
	}

	private static void prepareMatch() throws IOException {
		
		for ( Match match :matchs){
			match.trouveGardiens();
			//String test = match.getEquipe1().coupEnvoi();
			//match.getFichier().write(match.getBallonMove(0));
			match.BallonCoupEnvoi();
			match.getEquipe1().coupEnvoi();
			match.getEquipe2().coupEnvoi();
		}
		
	}
	


}
