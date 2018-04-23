import java.util.Random;
public class Grid {
  
  private static final int CELL_SIZE = 8;
  //private static final int CELL_SIZE = 4;
  protected int x; // 20 * 16 * 16
  protected int y; // 30 * 16 * 16
  protected int tcells; // total of cells
  private Cell[][] cell; // = new Cell[rows][cols]; //Grid as matrix
     
 /**
  * Creates the grid.
  * @param x as the width of the grid in cells.
  * @param y as the height of the grid in cells.
  */
  public Grid() { //default to 320 * 480 resolution with 16 * 16 cells
    //this(20, 30);
    this(64, 96);
    //this(80, 120);
  }
  
  public Grid(int x, int y) {
    this.x = x;
    this.y = y;        
    tcells = x * y; // total of cells
    
    /* initialize cell as an empty matrix of Cell objects. */
    cell = new Cell[x][y]; empty(); 
  }
  
 /**
  *
  * Methods: empty(), generate, display()
  *
  */
  public void empty(){ // two nested loops allow us to visit every spot in a 2D array.   
    for (int i = 0; i < x; i++) {
      for (int j = 0; j < y; j++) {
        cell[i][j] = new Cell(); // fill 2D array with new Cell objects.
      }
    }
  }
  
  public void generate() { // generate random grid with 10% obstruction.
    Random rand = new Random();
    for (int i = 0; i < x; i++) { // two nested loops allow us to visit every spot in a 2D array.  
      for (int j = 0; j < y; j++) {
        int r = rand.nextInt(100);
     
        if(r > 10){ //90% walkable and transparant
          cell[i][j].transparent = true;
          cell[i][j].walkable = true;
        } else if (r < 10) { // 10% shadowcasting obstructions. 
          cell[i][j].transparent = false;
          cell[i][j].walkable = false;
        }
        cell[i][j].fov = false; // default every field of view to false
      
      }
    }
  }

  //display a tile
  public void display(int i, int j) {
    int idx= j * g.x + i;
    char c;
    if (idx == Constants.PCY * g.x + Constants.PCX){
      c = '@';
      fill(250,0,0);
      rect(i*CELL_SIZE,j* CELL_SIZE,CELL_SIZE,CELL_SIZE); 
      
    }else if (cell[i][j].walkable){
      c = (cell[i][j].fov ? '.' : ' ');
          if (c == '.')
            fill(250 , 250, 250);
          else if (c==' ')
            fill(0);
          rect(i*CELL_SIZE,j*CELL_SIZE,CELL_SIZE,CELL_SIZE); 
      
    }else{
      c = (cell[i][j].fov ? '#' : '?');
           if (c == '#')
            fill(100);
          else if (c=='?')
            fill(0,0,0,20);
          rect(i*CELL_SIZE,j*CELL_SIZE,CELL_SIZE,CELL_SIZE); 
    } 
    //System.out.print(c);
  }
}