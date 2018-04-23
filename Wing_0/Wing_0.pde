//final static int R = 10;
final static float maneuverability = 24.5;
PVector space; 
PVector origin;
PMatrix3D cam;
Star [] star;

void setup(){
  size(360, 480, P3D);
  smooth();
  space = new PVector (400,400,400);
  origin = new PVector (width/2, height/ 2, space.z / 2);
  cam = new PMatrix3D();
  
  //create 500 random stars
  star = new Star[500];
  for(int i = 1; i < star.length; i++){
    star[i] = new Star(random(-space.x, space.x), random(-space.y ,space.y), random(-space.z ,space.z));
  }
}


void draw(){ 
  background(0); //clear
  
  //populate cosmos with stars
  for (int b=1;b<star.length;b++){
    star[b].display();
  }
  
  /*** primary perspective ***/
  cam.rotateX(-(mouseY - height / 2.0) / height / maneuverability);
  cam.rotateY(-(mouseX - width  / 2.0) / width  / maneuverability);
  PVector x = cam.mult(new PVector(1, 0, 0), new PVector(0, 0, 0));
  PVector y = cam.mult(new PVector(0, 1, 0), new PVector(0, 0, 0));
  PVector d = x.cross(y);// d.normalize(); d.mult(R);
  camera(0, 0, 0, d.x, d.y, d.z, y.x, y.y, y.z);
  
  /*** secondary perspective - controls do not work properly ***/
  
  /**************************************************************
  
  camera(0, 0, 0, 0, map(mouseX, 0, height, 0, PI), map(mouseY, 0, width, 0, -PI), 0.0, 1.0, 0.0);
  translate(origin.x, origin.y, origin.z);
  rotateY(map(mouseX, 0, width, 0, PI));
  rotateZ(map(mouseY, 0, height, 0, -PI));
  pushMatrix(); 
  translate(-origin.x, -origin.y, -origin.z);
  popMatrix(); 
  
  **************************************************************/
}