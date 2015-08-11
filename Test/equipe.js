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
	var img_terrain = terrain.image("terrain.jpg",0,0,720,450);
	img_terrain.click(function(e) {movePlayer(e);});
}

function placerJoueur(id, numero, x,y,col1,col2){
	var circle = terrain.circle(x, y, r);
	circle.attr("fill", Raphael.hsl(col1,50,50));
	circle.attr("stroke",Raphael.hsl(col2,50,50));
	circle.attr("stroke-width", stroke);
	circle.node.id = id;
	var num = terrain.text(x,y,numero);
	num.node.id = id + "_numero";
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

function playerInit(){
	
		var col1 = 20;
		var col2 = 90;
		for (var i=0 ; i < 11; i++) { 
				var joueur = i+1;
				var numero = i+1;
				var x = min_x + Math.random()*((max_x/2) - min_x);
				var y = min_y + Math.random()*(max_y- min_y);		
				placerJoueur(joueur, numero, x,y,col1,col2);
				nb_total++
				nb_joueur++;
		}
		
		var col1 = 50;
		var col2 = 120;
		for (var i=0 ; i < 11; i++) { 
				var joueur = i+12;
				var numero = i;
				var x = min_x + (max_x/2) + Math.random()*((max_x/2) - min_x);
				var y = min_y +Math.random()*(max_y- min_y);			
				placerJoueur(joueur, numero, x,y,col1,col2);
				nb_remp++;
				nb_total++;
			}
		}
	


function retournex(x){
	return max_x -(x - min_x);
}

function retourney(y){
	return max_y - (y - min_y);
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
	req.open("GET", "test.json", false); 
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
