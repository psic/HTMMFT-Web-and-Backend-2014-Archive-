var tab=new Array();
var chrono;
var minute;
var min;
var seconde;
var tot_sec;
var vitesse;
var moves;
var tab_joueur;
var nb;

var nb_joueur=0;
var player=-1;
var nb_remp =0;
var nb_total = 0;
const max_total = 16;
const max_remp = 5;
const max_joueur = 11;
//dimension du terrain
const min_x = 40;
const min_y = 20;
const max_x = min_x + 640;
const max_y = min_y + 410;
//coin des remplacant
const x_remp =20;
const y_remp =15;
//constante de dessin : taille mistralde la police, largeur des cercles, des cadres et des strokes
const svgns = "http://www.w3.org/2000/svg";
const r = 11;
const stroke = 3;
const cadre = 2*r +3;
var terrain;
var modif = false;
//721
//150
//4,8
function terrainInit(){
	terrain = Raphael("terrain", 720, 450)
	var img_terrain = terrain.image("/images/terrain.jpg",0,0,720,450);
	img_terrain.click(function(e) {movePlayer(e);});
}
function addPlayerToField(gch,ctr,drt,off,def,col1,col2,numero,chkbx){
	modif = true;
if (chkbx.checked == true){
	if (nb_joueur + 1<= max_total){
		if (nb_joueur +1 <= max_joueur){
			var x = min_x +  (max_x -min_x)/2 + ((off - def)/100 )* (max_x-min_y)/2 ;
			var y = (max_y -min_y)/2 + ((drt-gch)*(1-(ctr/100))/100)* (max_y -min_y)/2 ;
			//var cx =40+ 220 + ((off-def)/100)*220 ;
			//var cy = 20 + 185 + ((drt-gch))*(1-(ctr/100))/100*185 ;
			//alert(x + ' ' + y);
			placerJoueur(chkbx.id, numero, x,y,col1,col2);
			nb_total++
			nb_joueur++;
		}
		else{
			if (nb_remp <= max_remp){
				placerJoueur(chkbx.id, numero, x_remp,y_remp + nb_remp * cadre,col1,col2);
				nb_remp++;
				nb_total++;
			}
			else{
				alert("Pas plus de 5 remplaçant sur la feuille de match");
				chkbx.checked == false;
			}
		}	
	}
	else{
		alert("Pas plus de 16 joueurs sur la feuille de match");
		chkbx.checked == false;
	}
}
else
{	
	effacerJoueur(chkbx.id);
}
	
}
function selectPlayer(evt){

var element = evt.target;
var player_click = element.getAttributeNS(null, "id");

if (player == -1){
	player = player_click;
	selectionnerJoueur(player_click);
}
else{
	if (player_click == player){
		deselectionnerJoueur(player);
	}
	else
	{
		deselectionnerJoueur(player);
		player = player_click;
		selectionnerJoueur(player_click);
	}	
}
}


function selectPlayerByNumero(evt){
	var element = evt.target;
	var numero = element.parentNode;
	var numero_id = numero.getAttributeNS(null, "id");
	var player_click = numero_id.substring(0,numero_id.indexOf("_"));
	if (player == -1){
		player = player_click;
		selectionnerJoueur(player_click);
	}
	else{
		if (player_click == player){
			deselectionnerJoueur(player);
		}
		else
		{
			deselectionnerJoueur(player);
			player = player_click;
			selectionnerJoueur(player_click);
		}	
	}
}

function unselectPlayer(evt){
	var element = evt.target;
	var selector_id = element.getAttributeNS(null, "id");
	var player_click = selector_id.substring(0,selector_id.indexOf("_")-1);
	deselectionnerJoueur(player_click);
}


function movePlayer(evt){
if (player != -1){
	modif = true;
	var element = evt.target;
	var m = element.getScreenCTM();
	var p =  document.getElementById("terrain").firstChild.createSVGPoint();
	p.x = evt.clientX;
	p.y = evt.clientY;
	var svgDoc = document.getElementById("terrain").firstChild;
	var svg_selector = svgDoc.getElementById(player+"_selector");
	var svg_num = svgDoc.getElementById(player+"_numero");
	//var shape= svgDoc.getElementById(player);
	
	var joueur = getRJoueur(terrain,player);
	var selector = getR(terrain, svg_selector);
	var num = getR(terrain, svg_num);
	
	var numero = num.attr("text");
	var x = joueur.attr("cx");
	if (x < min_x){
		nb_remp --;
		nb_joueur ++;
	}
	p = p.matrixTransform(m.inverse());
	if (p.y < min_y )
		p.y = min_y;
	if (p.x  > max_x)
		p.x = max_x;
	if (p.y > max_y )
		p.y = max_y;
		
	if (p.x  < min_x){
		//p.x = 75;
		if (nb_remp <= max_remp){
			nb_remp++;
			nb_joueur --;
			alert("le joueur n°" + parseInt(numero,10) +" sera remplaçant");
			p.x = x_remp;
			p.y = y_remp + nb_remp * cadre;	
		}
		else{
			alert("Il y a déjà 5 remplaçants");
			p.x = joueur.attr("cx");
			p.y = joueur.attr("cy");
		}
	}
	joueur.attr("cx", p.x);
	joueur.attr("cy", p.y);
	selector.attr("x", p.x-(r+stroke));
	selector.attr("y", p.y-(r+stroke));
	num.attr("x", p.x);
	num.attr("y", p.y);
	}
}


function placerJoueur(id, numero, x,y,col1,col2){
	var circle = terrain.circle(x, y, r);
	circle.attr("fill", Raphael.hsl(col1,50,50));
	circle.attr("stroke",Raphael.hsl(col2,50,50));
	circle.attr("stroke-width", stroke);
	circle.node.id = id;
	circle.click(function(e) {selectPlayer(e);});
	var num = terrain.text(x,y,numero);
	num.node.id = id + "_numero";
	num.click(function(e) {
                        selectPlayerByNumero(e);
                        });
}

function placerJoueurSimple(id, numero, x,y,col1,col2){
	var circle = terrain.circle(x, y, r);
	circle.attr("fill", Raphael.hsl(col1,50,50));
	circle.attr("stroke",Raphael.hsl(col2,50,50));
	circle.attr("stroke-width", stroke);
	circle.node.id = id;
	var num = terrain.text(x,y,numero);
	num.node.id = id + "_numero";
}


function selectionnerJoueur(id){
	var joueur = getRJoueur(terrain,id);
	x= joueur.attr("cx");
	y = joueur.attr("cy");
	var carre = terrain.rect(x-(r+stroke),y-(r+stroke), cadre+stroke, cadre+stroke);
	carre.attr("stroke", Raphael.hsl(0,0,0));
	carre.attr("stroke-width", stroke);	
	carre.attr("fill-opacity",0);	
	carre.node.id = id + "_selector";	
	//carre.click(function(e) {unselectPlayer(e);});
	document.getElementById("tr_"+id).style.border ="2px solid white";
}
function deselectionnerJoueur(id){
	var svgDoc = document.getElementById("terrain").firstChild;
	var svgElement = svgDoc.getElementById(id+ "_selector");
	var selector = getR(terrain,svgElement);
	selector.remove();
	player = -1;
	document.getElementById("tr_"+id).style.border ="";
}

function effacerJoueur(id){

	var joueur = getRJoueur(terrain,id);
	var svgDoc = document.getElementById("terrain").firstChild;
	var svgElement = svgDoc.getElementById(id +"_numero");
	var numero = getR(terrain,svgElement);
	if (joueur.attr("cx") == x_remp)
		nb_remp --;
	else
		nb_joueur --;
	joueur.remove();
	numero.remove();
	nb_total --;
	if (player == id){
		deselectionnerJoueur(id);
	}
}



/* Given an SVG DOM element, find the corresponding <Raphael's object> 
    or else None */ 
 function getR(paper, svgEl) { 
     var test = paper.bottom; 
     while( test ) { 
         if( test.node == svgEl ) return test; 
         test = test.next; 
     }; 
     alert("ERREUR : " + svgEl + " doesn't seem to exist on this paper " + paper); 
     return;

}

 function getRJoueur(paper, id) { 
	 var svgDoc = document.getElementById("terrain").firstChild;
	 var svgEl = svgDoc.getElementById(id);
     var test = paper.bottom; 
     while( test ) { 
         if( test.node == svgEl ) return test; 
         test = test.next; 
     }; 
     alert("ERREUR : " + svgEl + " doesn't seem to exist on this paper " + paper); 
     return;

}
/*************************************  Enregistrement & chargement *****************************************/

function valider_form(){
	var onfield = 0;
	var outfield = 0;
	modif = false;
	var svgDoc = document.getElementById("terrain").firstChild;
	var liste_joueurs= svgDoc.getElementsByTagName('circle');
	//TODO morche pas à la declatation du form avec id var form = document.getElementById("placement");
	for (var i=0 ; i < liste_joueurs.length; i++) { 
		//alert (liste_joueurs[i].getAttributeNS(null,"cx"));
		if (parseInt(liste_joueurs[i].getAttributeNS(null,"cx"),10) >= 40){
			if (onfield <11){
				onfield ++;
				document.getElementById("j_" + onfield).value = liste_joueurs[i].id;
				document.getElementById("jx_" + onfield).value = liste_joueurs[i].getAttributeNS(null,"cx");
				document.getElementById("jy_" + onfield).value = liste_joueurs[i].getAttributeNS(null,"cy");
			}
			else{
				alert("il y a plus de 11 joueurs sur le terrain");			
			}
		}
		else{
			if (outfield <5){
				outfield++;
				document.getElementById("r_" + outfield).value = liste_joueurs[i].id;
			}
			else{
					alert("il y a plus de 5 remplaçants");
			}
		}
		
	}
}

function playerInit(positions,remp, couleurs){
	if (positions != null && remp != null){
		var tab= eval(positions);
		var tab_remp = eval(remp);
		var tab_col = eval(couleurs);
		var col1 = tab_col[0].couleur1;
		var col2 = tab_col[0].couleur2;
		for (var i=0 ; i < tab.length; i++) { 
			if (tab[i] != null && tab[i][0] != null){
				var joueur = tab[i][0].id_joueur;
				var numero = tab[i][0].numero;
				var x = tab[i][0].posx;
				var y = tab[i][0].posy;			
				placerJoueur(joueur, numero, x,y,col1,col2);
				nb_total++
				nb_joueur++;
			}
		}
		for (var i=0 ; i < tab_remp.length; i++) { 
			if (tab_remp[i] != null && tab_remp[i][0] != null){
				var joueur = tab_remp[i][0].idRemp;
				var numero = tab_remp[i][0].numero;
				placerJoueur(joueur, numero, x_remp,y_remp + nb_remp * cadre,col1,col2);
				nb_remp++;
				nb_total++;
			}
		}
	}
}

function playerInit1(positions,remp, couleurs){
	if (positions != null && remp != null){
		var tab= eval(positions);
		var tab_remp = eval(remp);
		var tab_col = eval(couleurs);
		var col1 = tab_col[0].couleur1;
		var col2 = tab_col[0].couleur2;
		for (var i=0 ; i < tab.length; i++) { 
			if (tab[i] != null && tab[i][0] != null){
				var joueur = tab[i][0].id_joueur;
				var numero = tab[i][0].numero;
				var x = tab[i][0].posx;
				var y = tab[i][0].posy;			
				placerJoueurSimple(joueur, numero, x,y,col1,col2);			
			}
		}
		for (var i=0 ; i < tab_remp.length; i++) { 
			if (tab_remp[i] != null && tab_remp[i][0] != null){
				var joueur = tab_remp[i][0].idRemp;
				var numero = tab_remp[i][0].numero;
				placerJoueurSimple(joueur, numero, x_remp,y_remp + nb_remp * cadre,col1,col2);
				nb_remp++;
			}
		}
	}
}
		
function playerInit2(positions,remp, couleurs){
	if (positions != null && remp != null){
		var tab= eval(positions);
		var tab_remp = eval(remp);
		var tab_col = eval(couleurs);
		var col1 = tab_col[0].couleur1;
		var col2 = tab_col[0].couleur2;
		for (var i=0 ; i < tab.length; i++) { 
			if (tab[i] != null && tab[i][0] != null){
				var joueur = tab[i][0].id_joueur;
				var numero = tab[i][0].numero;
				var x = retournex(tab[i][0].posx);
				var y = retourney(tab[i][0].posy);			
				placerJoueurSimple(joueur, numero, x,y,col1,col2);
				nb_joueur++;
			}
		}
		for (var i=0 ; i < tab_remp.length; i++) { 
			if (tab_remp[i] != null && tab_remp[i][0] != null){
				var joueur = tab_remp[i][0].idRemp;
				var numero = tab_remp[i][0].numero;
				placerJoueurSimple(joueur, numero, x_remp,y_remp + nb_remp * cadre,col1,col2);
				nb_remp++;
			}
		}
	}
}	
function retournex(x){
	return max_x -(x - min_x);
}

function retourney(y){
	return max_y - (y - min_y);
}

		
function checkboxInit(chk,remp){
	if (chk != null && remp != null){
		var tab= eval(chk);
		var tab_remp = eval(remp);
		for (var i=0 ; i < tab.length; i++) { 
			if (tab[i] != null && tab[i][0] != null){
				var joueur = tab[i][0].id_joueur;
				var laChek = document.getElementById(joueur);
				laChek.checked = true;
			}
		}
		for (var i=0 ; i < tab_remp.length; i++) { 
			if (tab_remp[i] != null && tab_remp[i][0] != null){
				var joueur = tab_remp[i][0].idRemp;
				var laChek = document.getElementById(joueur);
				laChek.checked = true;
			}
		}
	}
}

function ValidOnQuit(){
if(modif == true){
	var resultat = confirm("Vous avez modifié votre tactique sans la valider. \n Cliquez sur OK pour Valider et Continuer \n Cliquez sur Annuler pour Continuer sans Valider (Vos changements seront perdu!).")
	if (resultat == true) 
	{
		valider_form();
		var form = document.getElementById("equipe");
		form.submit();
	}
}

}


function Update_entrainement(){
	var total=0;
	var lesradios= document.getElementsByName("vitesse" );
	for(var i=0;i<=11;i++){
		if(lesradios[i].checked){
		vitesse=lesradios[i].value;
			break;
		}
	}
	total += parseInt(vitesse);
	
	lesradios= document.getElementsByName("physique" );
	for(var i=0;i<=11;i++){
		if(lesradios[i].checked){
		physique=lesradios[i].value;
			break;
		}
	}
	total += parseInt(physique*2);
	
	lesradios= document.getElementsByName("technique" );
	for(var i=0;i<=11;i++){
		if(lesradios[i].checked){
		technique=lesradios[i].value;
			break;
		}
	}
	total += parseInt(technique);
	
	lesradios= document.getElementsByName("tactique" );
	for(var i=0;i<=11;i++){
		if(lesradios[i].checked){
		tactique=lesradios[i].value;
			break;
		}
	}
	total += parseInt(tactique);
	
	lesradios= document.getElementsByName("attaque" );
	for(var i=0;i<=11;i++){
		if(lesradios[i].checked){
		attaque=lesradios[i].value;
			break;
		}
	}
	total += parseInt(attaque);
	
	lesradios= document.getElementsByName("defense" );
	for(var i=0;i<=11;i++){
		if(lesradios[i].checked){
		defense=lesradios[i].value;
			break;
		}
	}
	total += parseInt(defense);
	
	lesradios= document.getElementsByName("recup" );
	for(var i=0;i<=11;i++){
		if(lesradios[i].checked){
		recup=lesradios[i].value;
			break;
		}
	}
	total += parseInt(recup);
	
	var tot_span = document.getElementById("total");
	tot_span.innerHTML = total;
	if (total>20){
		tot_span.style.color="red";
	}
	else{
		tot_span.style.color="white";
	}	
}

function valider_entrainement(){
	var tot_span = document.getElementById("total");
	var total = parseInt(tot_span.innerHTML);
	if (total > 20){
		alert ("La charge d'entrainement dépasse 20");
		return false;
	}
	
}

function getTime(time,day){
	var time_span = document.getElementById("time");
	var day_span = document.getElementById("day");
	var reste_day = parseInt(day) % 7;
	var jour = "";
	switch(reste_day){
					case 1: jour = 'Lundi';
					 break;
					case 2: jour = 'Mardi';
					 break;
					case 3: jour = 'Mercredi';
					 break;
					case 4: jour ='Jeudi';
					 break;
					case 5: jour = 'Vendredi';
					 break;
					case 6: jour = 'Samedi'; break;
					case 7: jour = 'Dimanche';
					 break;
					default: jour = day;
	} 
	var date = new Date(time); 
	day_span.innerHTML = jour;
	//time_span.innerHTML = date.getHours() +':'+ date.getMinutes() + ':' + date.getSeconds();
	//setTimeout(function () {getTime(time+1000,day);}, 1000);
	var h = date.getHours();
	if (h > 12){
		h = h -12;
	}
	var s = date.getSeconds();
	s= s *2;
	var m = date.getMinutes();
	if (s > 60){
		s= s -60;
		m = m +1;
	}
	
	m =m *2;
	if (m > 60){
		m = m -60;
		h = h +1;
	}
	avance_time(h,m,s);
	//avance_time2(time);
}

function avance_time(hh,mm,ss){
	var time_span = document.getElementById("time");
	var h = hh;
	var m =mm;
	var s = ss;
	
	if (ss == 60){
			s = 0;
			m = m+1;
	}
	
	if(m == 60){
		m = 0;
		h = h + 1;
	}
	if(h == 24){
		h=0;
	}
	
	
	time_span.innerHTML = h +':'+ m + ':' + s;
	setTimeout(function () {avance_time(h,m,s+1);}, 500);
}

function avance_time2(time){
	var time_span = document.getElementById("time2");
	var date = new Date(time); 
	time_span.innerHTML = date.getHours() +':'+ date.getMinutes() + ':' + date.getSeconds();
	setTimeout(function () {avance_time2(time+1000);}, 1000);
}

function transfertsInit(){
}

function entrainementInit(){
}

function ValidOnQuit_entrainement(){
}

function update_transfert_div(club_id) {  
  jQuery.ajax({
    url: "/update_transfert",
    type: "GET",
    data: {"club_id" : club_id},
    dataType: "html",
    success: function(data) {
      jQuery("#liste_joueurs").html(data);
    }
  });
}

function valider_transfert(){

	var trouve = false;
	var lesradios= document.getElementsByName("transfert_joueur" );
	for(var i=0;i<lesradios.length;i++){
		if(lesradios[i].checked){
		trouve = true;
			break;
		}
	}
	
	if (trouve == true){
		var nb = 0;
		var leschk = document.getElementsByName("chk_joueur" );
		for(var i=0;i<leschk.length;i++){
			if(leschk[i].checked){
				nb = nb +1;
			}
		}

		if(nb < 2){
			alert('Il y faut sélectionner au moins 2 joueurs de votre effectif pour réaliser un échange');
		}
	
	}
}

/************                     Match en Live TEST **************************/

function charger_test(){
	minute =0;
	seconde=0;
	tot_sec=0;
	nb=0;
	var lesradios= document.getElementsByName("vitesse" );
	for(var i=0;i<=3;i++){
		if(lesradios[i].checked){
		vitesse=lesradios[i].value;
			break;
		}
	}

	min = document.getElementById("m");
	min.innerHTML = minute;
	  
    var req = new XMLHttpRequest();
	//req.open("GET", "test_match.json", false);
	req.open("GET", "114.json", false); 
	req.onreadystatechange = charger_joueur;   // the handler 
	req.send(null); 
 
	function charger_joueur() 
	{ 
	   if (req.readyState == 4) 
	   { 
	         tab_joueur = eval('(' + req.responseText + ')'); 
             var mvt_sec = tab_joueur[0];
             for (var k=0;k<mvt_sec.length;k++){
				 if (mvt_sec[k].id != 0){
					InitPlayerMatch(mvt_sec[k].id,mvt_sec[k].x,mvt_sec[k].y)
				}
				else{
					var circle = terrain.circle(mvt_sec[k].x, mvt_sec[k].y, 7);
					circle.attr("fill", Raphael.hsl(100,100,100));
					circle.attr("stroke",Raphael.hsl(0,0,0));
					circle.attr("stroke-width", 4);
					circle.node.id = "0";			
				}
			}
             
	   }
	}
    
}

function jouer_test(){
	
	minute = Math.floor(tot_sec / 60);
	seconde = tot_sec % 60;	
	min.innerHTML = minute + ":" + seconde;
	
	var mvt_sec = tab_joueur[tot_sec];
	var tt="";
	if (mvt_sec){
		for (var k=0;k<mvt_sec.length;k++){
			if (mvt_sec[k].id != 0){
				if (mvt_sec[k].dp == "MOVE"){
					var index = mvt_sec[k].id;
					var x = mvt_sec[k].x;
					var y = mvt_sec[k].y;
					var speed = mvt_sec[k].time;			
					//var tps = (distance / 4,8 )*mvt_sec[k].speed *100/vitesse;
					MovePlayerMatch(index, x, y,speed);
					//tab[index].animate({cx:x, cy:y}, tps, "<>");
				}
			}
			else{
				var index = mvt_sec[k].id;
					var x = mvt_sec[k].x;
					var y = mvt_sec[k].y;
					var speed = mvt_sec[k].time;
					
					var svgDoc = document.getElementById("terrain").firstChild;
					var svg_num = svgDoc.getElementById("0");							
					var balle = getR(terrain, svg_num);	;
					var dist = distance (balle.attr("cx"), balle.attr("cy"),x,y);
					var tps = dist / (speed * 0,6) ;
	
					//tps = tps * 1000 / vitesse;
					//tps = tps * 100;
					tps= speed * 1000 / vitesse;
					
					var x_ori = balle.attr("cx");
					var y_ori = balle.attr("cy");
					//var ligne = "M" + x_ori + " " + y_ori + "L" + x + " " + y;
					//alert (ligne);
					//terrain.path(ligne);
					
					balle.animate({cx:x, cy:y}, tps , ">");
									
									
				}
			}
		}
	//}	
	
	minute +=1;
	tot_sec +=1;

	if (tot_sec <90 * 60){	
		setTimeout(function () {jouer_test();}, 1000/vitesse);
		//setTimeout(function () {jouer_test();}, 1000);
	}

}


function distance(x1,y1, x2, y2){
	diffx = Math.abs(x1 -x2);
	diffy = Math.abs(y1-y2);
	var dist = Math.sqrt((diffx*diffx)+(diffy*diffy));
	return dist;
}

function chg_vitesse(vit){
	vitesse = vit;
}



function InitPlayerMatch(id, x, y){
	var svgDoc = document.getElementById("terrain").firstChild;
	var svg_num = svgDoc.getElementById(id+"_numero");
	var joueur = getRJoueur(terrain,id);
	var num = getR(terrain, svg_num);
	
	joueur.attr("cx", x);
	joueur.attr("cy", y);
	num.attr("x", x);
	num.attr("y", y);
	
}

function MovePlayerMatch(id, x, y,speed){
	var svgDoc = document.getElementById("terrain").firstChild;
	var svg_num = svgDoc.getElementById(id+"_numero");
	var joueur = getRJoueur(terrain,id);
	var num = getR(terrain, svg_num);	
	var dist = distance (joueur.attr("cx"), joueur.attr("cy"),x,y);
	var tps = dist / (speed * 0,6) ;
	
	//tps = tps * 1000 / vitesse;
	//tps = tps * 100;
	tps= speed * 1000 / vitesse;
	
	var x_ori = joueur.attr("cx");
	var y_ori = joueur.attr("cy");
	var ligne = "M" + x_ori + " " + y_ori + "L" + x + " " + y;
	//alert (ligne);
	//terrain.path(ligne);
	
	joueur.animate({cx:x, cy:y}, tps , "<>");
	num.animate({x:x, y:y}, tps , "<>");	
}
