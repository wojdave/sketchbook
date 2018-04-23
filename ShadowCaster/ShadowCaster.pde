Grid g = new Grid();
Shadow fov = new Shadow();

void setup() {
  size(320, 480);
  frameRate(60);
  g.generate();
  //noLoop();
}

void draw() {
  fov.computeFov(g, Constants.PCX, Constants.PCY, fov.maxRadius ,true);
  //fov.maxRadius--;
  for (int i = 0; i < g.x; i++) {
    for (int j = 0; j < g.y; j++)
    g.display(i, j);  }  println(frameRate); //test consistency of frameRate
} 
