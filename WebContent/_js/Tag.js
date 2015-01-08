function switchmodTag(modtag,modcontent,modk) {
for(i=1; i <4; i++) {
  if (i==modk) {
	document.getElementById(modtag+i).className="menuOn";document.getElementById(modcontent+i).className="slidingList";}
  else {
	document.getElementById(modtag+i).className="menuOff";document.getElementById(modcontent+i).className="slidingList_none";}
}
}

function setTab(name,cursel,n){
 for(i=1;i<=n;i++){
  var menu=document.getElementById(name+i);
  var con=document.getElementById("con_"+name+"_"+i);
  menu.className=i==cursel?"hover":"";
  if(con!=null){
	  con.style.display=i==cursel?"block":"none";
  }
 }
}


function navTab(navname,cursel,n){
 for(i=1;i<=n;i++){
  var nav=document.getElementById(navname+i);
  var cont=document.getElementById("cont_"+navname+"_"+i);
  nav.className=i==cursel?"navon":"";
  cont.style.display=i==cursel?"block":"none";
 }
}

function keyselect(b){
	var a = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
	if(a==13){ 
		if (b.options[b.selectedIndex].value!=''){
				window.open(b.options[b.selectedIndex].value);
			} 
	}
}
function clickselect(a){
	a.onchange=function(){
		if (this.options[this.selectedIndex].value!=''){
			window.open(this.options[this.selectedIndex].value);
			}
		a.onchange="";
	};
}
