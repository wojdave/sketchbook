public class Star {
  PVector loc;
  color c;
  
    public Star(float x, float y, float z){
      loc = new PVector(x, y, z);      
      c = color(random(0, 255));
    }
    
    void display(){
      rectMode(CENTER);
      stroke(c);
      fill(c);
      
      pushMatrix();
      translate(loc.x, loc.y, loc.z);
      box(1);
      popMatrix(); 
      
      pushMatrix();
      translate(0, 0, 0);
      stroke(250,250,0); 
      box(10);
      popMatrix(); 
    }
}


