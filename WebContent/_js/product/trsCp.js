
function getCategory(category,id,firstCat,secondCat,thirdCat){
	$.ajax({
        type: "POST",
        url: "getcategory.htm",
        dataType: "json",
        data:"category="+category,
        success: function(msg){
			if(category=='100'||category=='118'){
				if(firstCat==''){
					$("#"+id).append("<a href='javascript:;' class='all' onclick='sub("+category+",\"\");return false;'>全部</a>");
				}else{
					$("#"+id).append("<a href='javascript:;' onclick='sub("+category+",\"\");return false;'>全部</a>");
				}
				$.each( msg, function(i, m){
					if(firstCat==m.classInfoId){
						$("#"+id).append("<a href='javascript:;' class='all' onclick='sub("+category+","+m.classInfoId+");return false;'>"+m.cName+"</a>");
					}else{
						$("#"+id).append("<a href='javascript:;' onclick='sub("+category+","+m.classInfoId+");return false;'>"+m.cName+"</a>");
					}
				});
			}else{
				
				$.each( msg, function(i, m){
					document.getElementById(id).options.add(new Option(m.cName,m.classInfoId));
					if(firstCat==m.classInfoId){
						getCategory(m.classInfoId,'subCategory',firstCat,secondCat,thirdCat);
						document.getElementById(id).options[i+1].selected=true;
					}else if(secondCat==m.classInfoId){
						getCategory(m.classInfoId,'thirdCategory',firstCat,secondCat,thirdCat);
						document.getElementById(id).options[i+1].selected=true;
					}else if(thirdCat==m.classInfoId){
						document.getElementById(id).options[i+1].selected=true;
					}
				});
			}
		}
	}); 
}

function sub(category,classInfoId){
	if(category==100){
		$("#fzqjSyrq").val(classInfoId);
	}else if(category==118){
		$("#fzqjCjlb").val(classInfoId);
	}
	document.form.currentPage.value=1;
	document.form.submit();
}

