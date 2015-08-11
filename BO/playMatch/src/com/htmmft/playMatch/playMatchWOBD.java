package com.htmmft.playMatch;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import com.htmmft.match.*;

public class playMatchWOBD {

	
	public final static int min_x = 30;
	public final static int min_y = 10 ;
	public final static int max_x = min_x + 660;
	public final static int max_y = min_y + 430;
	public final static int mid_x = (max_x - min_x) /2;
	public final static int mid_y = (max_y - min_y) /2;

	final static String MATCHS_FOLDER="./matchs";
	private static NoBase BD_access;
	
	private static Match match;
	
	public static void main(String[] args) throws IOException{
	 match =new Match();
	 BD_access = new NoBase();
	 match = BD_access.getMatch();
	 prepareFiles();
	 prepareMatch();
	 jouerMatch();
	 closeFiles();
	 System.out.println("FINI!!");
	}

	private static void jouerMatch() throws IOException {
		match.jouer();
	}

	private static void closeFiles() throws IOException {
			//match.getFichier().write("}");
			match.getFichier().close();
	}

	private static void prepareFiles() throws IOException {
			match.setFichier(new FileWriter(MATCHS_FOLDER + "/match.json"));
	}

	private static void prepareMatch() throws IOException {
		
			match.trouveGardiens();
			match.BallonCoupEnvoi();
			match.getEquipe1().coupEnvoi();
			match.getEquipe2().coupEnvoi();
		
	}	

}
