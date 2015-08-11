
var nb_joueur=0;

function addPlayerToField(gch,ctr,drt,off,def){
	if (nb_joueur >= 16){
	var svgns = "http://www.w3.org/2000/svg";
	var shape = document.createElementNS(svgns, "circle");
	var cx =40+ 220 + ((off-def)/100)*220 ;
	var cy = 20 + 185 + ((drt-gch))*(1-(ctr/100))/100*185 ;
	//alert(cx + ", " + cy);
	shape.setAttributeNS(null, "cx", cx);
	shape.setAttributeNS(null, "cy", cy);
	shape.setAttributeNS(null, "r",  10);
	shape.setAttributeNS(null, "fill", "red");
	document.getElementById("terrain").appendChild(shape);
	else{
	alert("Pas plus de 16 joueurs sur la feuille de matchs");
	}
	
}
