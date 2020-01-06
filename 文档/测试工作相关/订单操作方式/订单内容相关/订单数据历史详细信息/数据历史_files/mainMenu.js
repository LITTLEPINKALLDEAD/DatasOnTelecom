    new_order_on=new Image(28,116);
    new_order_off=new Image(28,116);

    worklist_on=new Image(28,75);
    worklist_off=new Image(28,75);

    query_on=new Image(28,59);
    query_off=new Image(28,59);

    reporting_on=new Image(28,75);
    reporting_off=new Image(28,75);

    notifications_on=new Image(28,111);
    notifications_off=new Image(28,111);

    options_on=new Image(28,71);
    options_off=new Image(28,71);
    useradmin_on=new Image(28,111);
    useradmin_off=new Image(28,111);    

function rollIn(contextPath, imgName){
   setImageName(contextPath, imgName, "on", "w.jpg");
}

function rollOut(contextPath, imgName){
   setImageName(contextPath, imgName, "off", "b.jpg");
}

function setImageName(contextPath, imageName, suffix, suffix2){
  var img = eval(imageName + suffix);
  img.src = contextPath + "/images/" + imageName + suffix2;
  document[imageName].src=contextPath + "/images/" + imageName + suffix2;
}