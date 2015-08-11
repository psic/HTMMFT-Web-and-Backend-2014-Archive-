package com.htmmft.match;

import java.util.ArrayList;

import com.htmmft.playMatch.playMatch;

public class Joueur {
	private int id;
	private int x;
	private int y;
	private int x_ori;
	private int y_ori;
	private int x_prec;
	private int y_prec;
	private int x_dest;
	private int y_dest;
	private int decal_x;
	private int decal_y;
	private int age; 
	private int xp;
	private int talent=0;;
	private int tactique=0;;
	private int technique=0;; 
	private int physique=0;;
	private int vitesse =0;
	private int mental=0;;
	private int off;
	private int def;
	private int drt;
	private int ctr;
	private int gch;
	private int cond;
	private int blessure;
	private int moral;
	private boolean changement = false;
	private boolean enpause = false;


	private boolean possede_ballon;
	private Equipe mon_equipe;
	private Equipe adversaire;
	private int next_move;
	private boolean gardien;
	private ArrayList<Move> move;
	private int tps_programme;
	private int tps_effectif;
	private int tps_pause;

	public Joueur(int id, int x, int y, Equipe equipe) {
		this.setId(id);
		this.x =x;
		this.y = y;
		this.x_ori=x;
		this.y_ori=y;
		mon_equipe =equipe;
		next_move =1;
		move = new ArrayList<Move>();
	}
	/**
	 * @return the x
	 */
	public int getX() {
		return x;
	}
	/**
	 * @param x the x to set
	 */
	public void setX(int x) {
		this.x = x;
	}
	/**
	 * @return the y
	 */
	public int getY() {
		return y;
	}
	/**
	 * @param y the y to set
	 */
	public void setY(int y) {
		this.y = y;
	}
	/**
	 * @return the age
	 */
	public int getAge() {
		return age;
	}
	/**
	 * @param age the age to set
	 */
	public void setAge(int age) {
		this.age = age;
	}
	/**
	 * @return the xp
	 */
	public int getXp() {
		return xp;
	}
	/**
	 * @param xp the xp to set
	 */
	public void setXp(int xp) {
		this.xp = xp;
	}
	/**
	 * @return the talent
	 */
	public int getTalent() {
		return talent;
	}
	/**
	 * @param talent the talent to set
	 */
	public void setTalent(int talent) {
		this.talent = talent;
	}
	/**
	 * @return the tactique
	 */
	public int getTactique() {
		return tactique;
	}
	/**
	 * @param tactique the tactique to set
	 */
	public void setTactique(int tactique) {
		this.tactique = tactique;
	}
	/**
	 * @return the physique
	 */
	public int getPhysique() {
		return physique;
	}
	/**
	 * @param physique the physique to set
	 */
	public void setPhysique(int physique) {
		this.physique = physique;
	}
	/**
	 * @return the moral
	 */
	public int getMoral() {
		return moral;
	}
	/**
	 * @param moral the moral to set
	 */
	public void setMoral(int moral) {
		this.moral = moral;
	}
	/**
	 * @return the blessure
	 */
	public int getBlessure() {
		return blessure;
	}
	/**
	 * @param blessure the blessure to set
	 */
	public void setBlessure(int blessure) {
		this.blessure = blessure;
	}
	/**
	 * @return the cond
	 */
	public int getCond() {
		return cond;
	}
	/**
	 * @param cond the cond to set
	 */
	public void setCond(int cond) {
		this.cond = cond;
	}
	/**
	 * @return the gch
	 */
	public int getGch() {
		return gch;
	}
	/**
	 * @param gch the gch to set
	 */
	public void setGch(int gch) {
		this.gch = gch;
	}
	/**
	 * @return the ctr
	 */
	public int getCtr() {
		return ctr;
	}
	/**
	 * @param ctr the ctr to set
	 */
	public void setCtr(int ctr) {
		this.ctr = ctr;
	}
	/**
	 * @return the drt
	 */
	public int getDrt() {
		return drt;
	}
	/**
	 * @param drt the drt to set
	 */
	public void setDrt(int drt) {
		this.drt = drt;
	}
	/**
	 * @return the off
	 */
	public int getOff() {
		return off;
	}
	/**
	 * @param off the off to set
	 */
	public void setOff(int off) {
		this.off = off;
	}
	/**
	 * @return the def
	 */
	public int getDef() {
		return def;
	}
	/**
	 * @param def the def to set
	 */
	public void setDef(int def) {
		this.def = def;
	}
	/**
	 * @return the mental
	 */
	public int getMental() {
		return mental;
	}
	/**
	 * @param mental the mental to set
	 */
	public void setMental(int mental) {
		this.mental = mental;
	}
	/**
	 * @return the vitesse
	 */
	public int getVitesse() {
		return vitesse;
	}
	/**
	 * @param vitesse the vitesse to set
	 */
	public void setVitesse(int vitesse) {
		this.vitesse = vitesse;
	}
	/**
	 * @return the technique
	 */
	public int getTechnique() {
		return technique;
	}
	/**
	 * @param technique the technique to set
	 */
	public void setTechnique(int technique) {
		this.technique = technique;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	/**
	 * @return the x_prec
	 */
	public int getX_prec() {
		return x_prec;
	}
	/**
	 * @param x_prec the x_prec to set
	 */
	public void setX_prec(int x_prec) {
		this.x_prec = x_prec;
	}
	/**
	 * @return the y_prec
	 */
	public int getY_prec() {
		return y_prec;
	}
	/**
	 * @param y_prec the y_prec to set
	 */
	public void setY_prec(int y_prec) {
		this.y_prec = y_prec;
	}

	public void save_coord(){

		x_prec = x;
		y_prec = y;
	}


	public void coupEnvoiE1() {
		save_coord();
		boolean ok =true;
		do{
			x = (int) (x * 0.9);
			if (y <  playMatch.mid_y + playMatch.min_y -50 || y >  playMatch.mid_y + playMatch.min_y + 50 ){
				if (x < playMatch.mid_x + playMatch.min_x){
					ok = false;
				}
			}
			else {
				if (x < playMatch.mid_x + playMatch.min_x + 50){
					ok = false;
				}
			}
			if(x < playMatch.min_x){
				x = playMatch.min_x;
				ok =false;		
			}
		}while(ok);
		move.add(new Move (x,y,0));
	}


	public void coupEnvoiE2() {

		x =retournex(x);
		y=retourney(y);
		x_ori =x;
		y_ori = y;
		save_coord();
		boolean ok =true;
		do{
			x = (int) (x * 1.05);
			if (y <  playMatch.mid_y +  playMatch.min_y - 50 || y >  playMatch.mid_y + playMatch.min_y + 50 ){
				if (x > playMatch.mid_x + playMatch.min_x){
					//	System.out.println(x + "," + y  + " / " + (playMatch.mid_x + playMatch.min_x) + ", " + (playMatch.mid_y +  playMatch.min_y )  );
					ok = false;
				}
			}
			else {
				if (x > playMatch.mid_x + playMatch.min_x + 70){
					ok = false;
				}
			}
			if(x > playMatch.max_x){
				x = playMatch.max_x - 10;
				ok =false;		
			}
		}while(ok);

		move.add(new Move (x,y,0));
	}





	private int  retournex(int x){
		return playMatch.max_x -(x -  playMatch.min_x);
	}

	private int  retourney(int y){
		return  playMatch.max_y - (y - playMatch.min_y);
	}
	public void coupEnvoiSpecial1() {

		x=playMatch.mid_x + playMatch.min_x;
		y=playMatch.mid_y - 10;
		save_coord();
		setPossede_ballon(true);
		mon_equipe.setPossede_ballon(true);
		move.add(new Move (x,y,0));

	}
	public void coupEnvoiSpecial2() {
		x=playMatch.mid_x + playMatch.min_x;
		y=playMatch.mid_y + 20;
		save_coord();
		move.add(new Move (x,y,0));
	}
	public void jouerMatch(int seconde, boolean possede_ballon,boolean changement)
	{	
		if (isGardien())
			return ;
		System.out.println("===================================================== Joueur ID : " + id  + " changement: " + changement + " possede: " + possede_ballon + " ===============================");
		avance();
		if (isNextMove(seconde) || changement ){
			save_coord();//TODO ??			
			if (possede_ballon)
				mouvement_attaque();
			else
				mouvement_defense();

			if ( x > playMatch.max_x )
				System.out.println("EEEEERRRRRRROOOORRRR");

			if ( y > playMatch.max_y )
				System.out.println("EEEEERRRRRRROOOORRRR");


		}
	}
	private boolean isNextMove(int seconde) {
		if (seconde >= next_move)
			return true;
		return false;

	}
	private void mouvement_defense() {
		System.out.println(" Defense");

		int vitesse = (int)(1 + Math.random() * ((100 + this.vitesse)/2) );
		//		vitesse = (int)(50 + vitesse)/2;
		//		if (mon_equipe.isSens()){
		//			x=(int) ( playMatch.min_x  + (playMatch.mid_x ) * Math.random());
		//			y=(int) ( playMatch.min_y + (playMatch.max_y - playMatch.min_y) * Math.random());
		//		}
		//		else{
		//			x=(int) ( playMatch.mid_x  + (playMatch.max_x - playMatch.mid_x ) * Math.random());
		//			y=(int) ( playMatch.min_y + (playMatch.max_y - playMatch.min_y) * Math.random());		
		//		}
		System.out.println (mon_equipe.getMatch().getX_balle() + "," + mon_equipe.getMatch().getY_balle() + " / " + x +"," +y); 
//		if (mon_equipe.getMatch().getX_balle() > x -20  && mon_equipe.getMatch().getX_balle() < x +20){
//			if (mon_equipe.getMatch().getY_balle() > y -20  && mon_equipe.getMatch().getY_balle() < y +20){
//				if (mon_equipe.getMatch().getX_balle() > x -2 && mon_equipe.getMatch().getX_balle() < x +2){
//					if (mon_equipe.getMatch().getY_balle() > y -2  && mon_equipe.getMatch().getY_balle() < y +2){
				if(DansLeCercle(mon_equipe.getMatch().getX_balle(), mon_equipe.getMatch().getY_balle(), 20)){		
					if(DansLeCercle(mon_equipe.getMatch().getX_balle(), mon_equipe.getMatch().getY_balle(), 2)){
						setPossede_ballon(true);
						mon_equipe.setPossede_ballon(true);
						adversaire.setPossede_ballon(false);
						mon_equipe.getMatch().setChangement(true);
						System.out.println(" #### CHANGEMENT #######");
						mouvement_attaque();
					}
					else{
						//x=mon_equipe.getMatch().getX_balle();
						//y=mon_equipe.getMatch().getY_balle();
						System.out.println("Deplacement vers le  ballon de " + x +"," + y + " vers " + mon_equipe.getMatch().getX_balle() +"," +mon_equipe.getMatch().getY_balle());	
						programme_deplacement(mon_equipe.getMatch().getX_balle(), mon_equipe.getMatch().getY_balle(), vitesse);
					}
				}
//				else{
//					//x=mon_equipe.getMatch().getX_balle();
//					//y=mon_equipe.getMatch().getY_balle();
//					System.out.println("Deplacement vers le  ballon de " + x +"," + y + " vers " + mon_equipe.getMatch().getX_balle() +"," +mon_equipe.getMatch().getY_balle());	
//					programme_deplacement(mon_equipe.getMatch().getX_balle(), mon_equipe.getMatch().getY_balle(), vitesse);
//				}
//			}
//			else
//				deplacement_sans_ballon(vitesse);
//		}
		else
			deplacement_sans_ballon(vitesse);	
	}
	private void mouvement_attaque() {
		System.out.println("Mvt_attaque");
		int vitesse = (int)(1 + Math.random() * ((100 + this.vitesse)/2) );
		if (possede_ballon){
			deplacement_avec_ballon(vitesse);
		}
		else{
			//deplacement_sans_ballon(vitesse);
			mouvement_defense();
		}
	}

	private void deplacement_avec_ballon(int vitesse){

		int obstacle= getJoueurAdverseDevant();
		System.out.println("Attaque avec Ballon " + obstacle + " " + x + "," + y);
		System.out.println("x >: "+ (playMatch.max_x - (playMatch.mid_x/2)) + " y > " + (playMatch.min_y + (playMatch.mid_y/2)) + " < " + (playMatch.max_y - (playMatch.mid_y/2)));
		if (x > playMatch.max_x - (playMatch.mid_x/2) && y >  playMatch.min_y +(playMatch.mid_y/2) && y < playMatch.max_y - (playMatch.mid_y/2) )
			tirauBut();
		else{
			if (obstacle > 5){
				passeBalle(vitesse);
			}
			else{
				conduiteBalle(vitesse);
			}
		}
	}

	private void tirauBut() {
		
		this.setPossede_ballon(false);
		int vitesse = (int)(100 + Math.random() * physique);
		int y_ = (int)(playMatch.mid_x - (playMatch.mid_y/2) + ( Math.random() * playMatch.mid_y/2) );
		System.out.println("Tir au but vers " + (playMatch.max_x +5 )+ "," +y_ );
		mon_equipe.getMatch().programme_deplacement(playMatch.max_x +5,y_ , vitesse);		
	}
	
	private void conduiteBalle(int vitesse) {
		System.out.println("Conduite");

		int max_x = getCloserAdversePlayer();
		int y_;
		int y_decal =(int)( Math.random() * (1 + (50 - tactique/2)));
		double piece =  Math.random() ;
		if (piece > 0.5){
			y_=y_ori-y_decal;
		}
		else{
			y_=y_ori+y_decal;
		}
		programme_deplacement(max_x,y_,vitesse);
		//mon_equipe.getMatch().setX_balle(x);
		//mon_equipe.getMatch().setY_balle(y);
		//mon_equipe.getMatch().CalculNextMove(vitesse);
		mon_equipe.getMatch().programme_deplacement(max_x, y_, vitesse);

	}

	private int getCloserAdversePlayer() {
		int diff=800;
		int x_return=playMatch.max_x;
		for (Joueur joueur : adversaire.getJoueur()){
		//	if(joueur.getX() > x && joueur.getX() - x < diff){
			if(joueur.getX() > x && DansLeCercle(joueur.getX(),joueur.getY(), diff)){
				x_return = joueur.getX() ;
				diff = joueur.getX() - x;
			}
		}
		return x_return;
	}
	private void passeBalle(int vitesse) {

		int index_receveur = selection_receveur();
		if (index_receveur != -1){
			System.out.println("Passe de " + id + " à "  + mon_equipe.getJoueur().get(index_receveur).getId() );
			//mon_equipe.getMatch().setX_balle(mon_equipe.getJoueur().get(index_receveur).getX());
			//mon_equipe.getMatch().setY_balle(mon_equipe.getJoueur().get(index_receveur).getY());
			//mon_equipe.getMatch().CalculNextMove(100);
			int x =mon_equipe.getJoueur().get(index_receveur).getX() + mon_equipe.getJoueur().get(index_receveur).decal_x;
			int y = mon_equipe.getJoueur().get(index_receveur).getY() + mon_equipe.getJoueur().get(index_receveur).decal_y;
			mon_equipe.getJoueur().get(index_receveur).programme_deplacement(x, y, vitesse);
			mon_equipe.getMatch().programme_deplacement(x, y, 100);
			this.setPossede_ballon(false);
			//mon_equipe.setPossede_ballon(false);
			mon_equipe.getMatch().setChangement(true);
			System.out.println(" #### CHANGEMENT #######");
			deplacement_sans_ballon(vitesse);
		}
		else{
			conduiteBalle(vitesse);
		}
	}
	private int selection_receveur() {
		int x_max=0;
		int index = -1;
		int i=0;
		for (Joueur joueur : mon_equipe.getJoueur()){
			if( joueur.getId() != this.id){
				if (joueur.isDemarque() && !joueur.DansLeCercle(x,y,50)){
					if(index == -1 || joueur.getX() > x_max){
						x_max = joueur.getX();
						index = i; 
					}
				}
			}
			i++;
		}
		return index;
	}
	/**
	 * renvoie false si param x,y sont en dehors du cercle de rayon dist et de centre this x,y 
	 * renvoie true si param x,y sont dans le cercle de rayon dist et de centre this x,y
	 * @param x
	 * @param y
	 * @return
	 */
	private boolean DansLeCercle(int x_centre, int y_centre,int rayon) {
		int diffx = Math.abs(this.x - x_centre);
		int diffy = Math.abs(this.y - y_centre);
		if (diffx < rayon && diffy < rayon)
			return true;
		else
			return false;
	}
	private boolean isDemarque() {
		boolean isdemarque = false;
		for (Joueur joueur : adversaire.getJoueur()){
			isdemarque = isdemarque || this.DansLeCercle(joueur.getX(),joueur.getY(), 15);
		}
		return isdemarque;
	}
	
	private int getJoueurAdverseDevant() {
		int count =0;
		for (Joueur joueur : adversaire.getJoueur()){
//			if(joueur.getX() >x && ( joueur.getY() - 50 <y && joueur.getY() + 50 > y)){
//				if (joueur.getX()-x < playMatch.mid_x)
//					count ++;
//			}
			if(joueur.getX() > x && this.DansLeCercle(joueur.getX(),joueur.getY(), 100 )){
					count ++;
			}
		}
		//System.out.println("Count : "+ count );
		return count;
	}

	private void deplacement_sans_ballon(int vitesse){

		int y_decal =(int) (Math.random() * (1 + (50 - tactique/2)));
		int y_;
		int x_ =  x_ori;
		int x_decal;
		//x_decal = playMatch.mid_x/2;
		//x_decal = mon_equipe.getMatch().getX_balle() - (playMatch.mid_x );


		if (mon_equipe.isPossede_ballon()){
			if (y > playMatch.mid_y){
				y_=y_ori+y_decal;
			}
			else{
				y_=y_ori-y_decal;
			}
			
			if ( x < x_ori){
				x_ = x_ori;
			}
			else{
				if (mon_equipe.getMatch().getX_balle() > playMatch.mid_x){
					x_decal = mon_equipe.getMatch().getX_balle() - (playMatch.mid_x );
					x_=(int) ( x_ori + x_decal + Math.random()* (playMatch.mid_x/2))  ;
				}
				else{
					//if (x - (playMatch.mid_x /2) >mon_equipe.getMatch().getX_balle()){

					//}
					x_=(int) ( x_ori  + Math.random()* (playMatch.mid_x/2))  ;

				}
			}

		}
		else{
			
			if (mon_equipe.getMatch().getY_balle()> playMatch.mid_y){
				y_=y_ori+y_decal;
			}
			else{
				y_=y_ori-y_decal;
			}
			if(x > x_ori){
				x_ = x_ori;
			}
			else {
				if (mon_equipe.getMatch().getX_balle() > playMatch.mid_x){
					x_decal = mon_equipe.getMatch().getX_balle() - (playMatch.mid_x );
					x_=(int) ( x_ori + x_decal);
				}
				else{
					x_decal = mon_equipe.getMatch().getX_balle() - (playMatch.mid_x );
					x_= x_ori + x_decal;
				}
			}			
		}
		//x_= x_ori + x_decal;
		//x = checkX();
		//y = checkY();
		//System.out.println( x +"," + y  +" decal_x :" + x_decal + " ID :" + id + " sens:" + mon_equipe.isSens());
		System.out.println("Deplacement sans ballon de " + x +"," + y + " vers " +x_ + "," + y_);	
		y_= corrige_deplacement(x_,y_);
		programme_deplacement(x_, y_, vitesse);

	}
	/**
	 * Pour eviter 2 joueurs au même endroit
	 * @param x_
	 * @param y_
	 * @return
	 */
	private int corrige_deplacement(int x_, int y_) {
		boolean sameplace=false;
		int y_return = y_;
		for (Joueur joueur:mon_equipe.getJoueur()){
			if (joueur.id != this.id){
				sameplace = DansLeCercle(joueur.x_dest, joueur.y_dest, 20);
				}
		}
		if (sameplace){
			System.out.println("Correction de Y");
			y_return = y+1;
		}
		return y_return;
	}
	private int checkY(int y) {
		if (y < playMatch.min_y)
			return playMatch.min_y;
		if (y > playMatch.max_y)
			return playMatch.max_y;
		return y;
	}
	private int checkX(int x) {
		if (x < playMatch.min_x)
			return playMatch.min_x;
		if (x > playMatch.max_x)
			return playMatch.max_x;
		return x;
	}
	private int CalculNextMove(int vitesse) {
		//int diffx = Math.abs(x -x_prec);
		//int diffy = Math.abs(y-y_prec);
		//int diffx = Math.abs(x_dest -x);
		//int diffy = Math.abs(y_dest-y);
		int diffx = x_dest -x;
		int diffy = y_dest-y;
		int dist = (int) Math.sqrt((diffx*diffx)+(diffy*diffy));

		// Une vitesse de 0 à 100.
		//à 100 on fait 600 pixel en 10 secondes (10 000 ms)
		// on fait 100 pixel en 1,6 seconde
		double pix_par_seconde = vitesse * 0.6;
		int prev_mov = next_move;
		int tps = (int) (dist / pix_par_seconde );
		next_move += tps;

		if (tps != 0){
			decal_x = diffx / tps;
			decal_y = diffy / tps;
			tps_programme = tps;
		}
		else{
			decal_x = diffx;
			decal_y = diffy;
			tps_programme = 1;
		}

		if (next_move - prev_mov > 60000){
			System.out.println("ERRRRRREEEEEEUUUUURR " + prev_mov + " " + next_move + " " + dist + " " + vitesse);
		}
		return tps_programme;
	}

	private void programme_deplacement(int x, int y,int vitesse) {
		if (tps_effectif >0){
			move.add(new Move (this.x,this.y,tps_effectif,'M'));
			System.out.println("Ajout Deplacement Joueur vers " + this.x + "," + this.y + " en " + tps_effectif + "(" + tps_programme + ")");
			if (enpause){
				move.add(new Move (0,0,tps_pause,'W'));
				System.out.println("Ajout Pause Joueur de " + tps_pause);
				enpause=false;
			}
		}
		x_dest=x;
		y_dest=y;
		x_dest = checkX(x_dest);
		y_dest = checkY(y_dest);
		int tps = CalculNextMove(vitesse);
		tps_effectif = 0;
		tps_pause = 0;
		//move.add(new Move (x,y,tps,'M'));
		System.out.println("Deplacement Joueur programme de " + x_prec +"," + y_prec +" vers " + x + "," + y + " en " + tps_programme);
		x_prec = x_dest;
		y_prec= y_dest;

	}

	private void avance(){
		System.out.println("avance Joueur "+ x +"," + y + " != " + x_dest + " tps_effectif " + tps_effectif + " tps_programme " + tps_programme);
		if(tps_effectif < tps_programme){
			x+=decal_x;
			y+=decal_y;
			x = checkX(x);
			y = checkY(y);
			System.out.println("Avance Joueur "+ x + "," +y);
			tps_effectif++;
		}
		else{
			changement =true;
			tps_pause++;
			enpause = true;
		}
	}

	/**
	 * @return the gardien
	 */
	public boolean isGardien() {
		return gardien;
	}
	/**
	 * @param gardien the gardien to set
	 */
	public void setGardien(boolean gardien) {
		this.gardien = gardien;
	}
	/**
	 * @return the possede_ballon
	 */
	public boolean isPossede_ballon() {
		return possede_ballon;
	}
	/**
	 * @param possede_ballon the possede_ballon to set
	 */
	public void setPossede_ballon(boolean possede_ballon) {
		this.possede_ballon = possede_ballon;
	}
	/**
	 * @return the adversaire
	 */
	public Equipe getAdversaire() {
		return adversaire;
	}
	/**
	 * @param adversaire the adversaire to set
	 */
	public void setAdversaire(Equipe adversaire) {
		this.adversaire = adversaire;
	}
	/**
	 * @return the move
	 */
	public ArrayList<Move> getMove() {
		return move;
	}
	/**
	 * @param move the move to set
	 */
	public void setMove(ArrayList<Move> move) {
		this.move = move;
	}

}
