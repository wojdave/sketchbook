int sizeX, sizeY ;
int gridSizeX, gridSizeY;
 
GravityField gF[] = new GravityField[3];
Grid grid;
 
boolean showGravityFieldLabel = true;
 
boolean RESET = false;

//------------------------------------------------------------------------------------------
// bullet elements

float beginX, beginY, endX, endY, distX, distY;
float exponent = 4.0;
float shotX = 0.0;
float shotY = 0.0;
float step = 0.04;
float pct = 0.0;

//------------------------------------------------------------------------------------------
// partical elements 

float angle = 0.0;
float speed = 0.5;
float radius = 30.0;
float sx = 1.4;
float sy =1.6;

//------------------------------------------------------------------------------------------

void setup() {
  size(320, 480,P3D);
  stroke(250);
  smooth();
  
  sizeX = width; sizeY = height;
  gridSizeX = int((sizeX + sizeY)/2);
  gridSizeY = int((sizeX + sizeY)/2);
  
  //------------------------------------------------------------------------------------------
  // initialize Grid
  int res = 17;
  int gridPointsX = gridSizeX / res;
  int gridPointsY = gridSizeY / res;
  grid = new Grid(gridPointsX, gridPointsY);
  float s = 1.5; // scale Grid
  for(int i = 0; i < gridPointsY; i++){
    for(int j = 0; j < gridPointsX; j++){
      int index = i*gridPointsX + j;
      float x = j * res * s + (sizeX - gridSizeX*s) / 2;
      float y = i * res * s + (sizeY - gridSizeY*s) / 2;
      float z = 0;
      grid.setGridPoint(index, x, y, z);
    } // end for j
  } // end for i
  
  int border = 0;
  //------------------------------------------------------------------------------------------
  // initialize gravityFields
  for(int i = 0; i < gF.length; i++){
    int id       = i;
    float x      = 0;//random(border, gridSizeX-border);
    float y      = 0;//random(border, gridSizeY-border);
    float radius = 0;//random(20, 40);
    color col = color( random(200,255), random(200,255),  random(1));
    gF[i] = new GravityField(id, x, y, radius, col);
  } // end for i

  
  //------------------------------------------------------------------------------------------
  endX = width;
  endY = height/2;
  beginX = 0.0;
  beginY = height/2;
  distX = endX - beginX;
  distY = endY - beginY;
}

void draw() {
  //println(frameRate);
  frameRate(60);
  noLights();
  fill(0, 5);
  
  /* calculate the planets new Information
  for(int i = 0; i < pl.length; i++){
    for(int j = 0; j < gF.length; j++)              pl[i].setNewDirection(gF[j].x, gF[j].y, gF[j].radius, 1500*gF.length, .4);
    for(int j = 0; j < pl.length; j++){ if( j != i) pl[i].setNewDirection(pl[j].x, pl[j].y, pl[j].radius, 2000,           .6); }
    pl[i].setNewPosition();
  } // end for i
  */
  
  
  
  //for(int i = 0; i < gF.length; i++) grid.setGridPointPositionZ( gF[i].x, gF[i].y, gF[i].radius ); 
  //for(int i = 0; i < pl.length; i++) grid.setGridPointPositionZ( pl[i].x, pl[i].y, pl[i].radius ); 
  
 
                                                                 // draw grid
  //for(int i = 0; i < gF.length; i++) gF[i].drawSphere(20, 30);                     // draw GravityFields
  //for(int i = 0; i < pl.length; i++) pl[i].drawSphere(10, 20);                     // draw Planets
  //if (showGravityFieldLabel) for(int i = 0; i < gF.length; i++) gF[i].drawLabel(); // draw GravityFieldsLabel
 
   rect(0, 0, width, height);
  grid.drawGrid();
  grid.REsetGridPointPositionZ(); // calculate the grid deformation
  //grid();

  shotX = 0.0;
  shotY = 0.0;
  if (pct < 1.0) {
    pct = pct + step;
    float rate = pow(pct, exponent);
    shotX = beginX + (rate * distX);
    shotY = beginY + (rate * distY);
    grid.setGridPointPositionZ( gF[0].x, gF[0].y, gF[0].radius);
  
  fill(shotX);
  stroke(250, 35);
  //stroke(#6900FF); fill(#FF00A2);
  drawParticale(shotX, shotY);
  }

  
  fill(shotX);
  stroke(250,35);
 // stroke(#FF00A2);
 // fill(#6900FF);
  ellipse(shotX, shotY, 3,3);
  
  //------------------------------------------------------------------------------------------
  // initialize gravityFields
  for(int i = 0; i < gF.length; i++){
    int id       = i;
    float x      = shotX;//random(border, gridSizeX-border);
    float y      = shotY;//random(border, gridSizeY-border);
    float radius = noise(25)*100;
    color col = color( random(200,255), random(200,255),  random(1));
    gF[i] = new GravityField(id, x, y, radius, col);
  } // end for i
}

void drawParticale(float x, float y) {
  fill(0,25); //set to 25
  rect(0, 0, width, height);
  angle += speed; // Update the angle
  float sinval = sin(angle);
  float cosval = cos(angle);
  // Set the position of the small circle based on new
  // values from sine and cosine
   x += (cosval * radius);
   y += (sinval * radius);
  // Set the position of the large circles based on the
  // new position of the small circle
  float x2 = x + cos(angle * sx) * radius/2;
  float y2 = y + sin(angle * sy) * radius/2;
  

  stroke(250);
  ellipse(x, y, 1, 1); // Draw smaller circle
  
  stroke(100);
  ellipse(x2, y2, 1, 1); // Draw larger circle
  
  stroke(225);
  ellipse(x, y2,1 , 1); // Draw hybrid circle
  
  stroke(150);
  ellipse(x2, y, 1, 1); // Draw hybrid circle
}

/*
void grid(){
  int space = 25;
  float c = 50;
  for(x = 0; x < width; x+=space){
    for(y = 0; y < height; y+=space){
      stroke(c*.5);
      line(x , y, width, y);
      stroke(c);
      line(x , y, x, height);
      c++;
    }
  }
}
*/
void mousePressed() {
  pct = 0.0;
  beginX = width/2;
  beginY = height/2;;
  distX = mouseX - beginX;
  distY = mouseY - beginY;;
}

