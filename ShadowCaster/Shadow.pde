/** Field of View Octants
 *
 *      \ 1 | 2 /
 *     8 \  |  / 3
 *     -----|-----
 *     7 /  |  \ 4
 *      / 6 | 5 \
 *    
 */ 
 
 /** Field of View Quadrants
 *
 *          | 
 *       NW | NE
 *     -----|-----
 *       SW | SE 
 *          |
 *    
 */ 
 
public class Shadow { 
  
  int maxRadius;
 /**
  * Creates the a Field of View.
  * @param maxRadius radius of light source.
  */
  public Shadow() {
    this(30); //default to a radius of 5
  }
  
  public Shadow(int maxRadius) { 
    this.maxRadius = maxRadius;
  }
  
  public void computeFov(Grid g, int playerX, int playerY, int maxRadius, boolean lightWalls) {
    int maxObstacles;
    
    for (int i = 0; i < g.x; i++) {
      for (int j = 0; j < g.y; j++) {
        g.cell[i][j].fov = false; // clear the fov of each Cell object in on the grid.
      }
    }
    
    maxObstacles = g.tcells / 7; // calculate an approximated (excessive, just in case) maximum number of obstacles per octant
    g.cell[playerX][playerY].fov = true;  // set Hero's position as visible
    
    computeQuadrant(g, playerX, playerY, maxRadius, lightWalls, maxObstacles, 1, 1); // north east quadrant
    computeQuadrant(g, playerX, playerY, maxRadius, lightWalls, maxObstacles, 1, -1); // south east quadrant
    computeQuadrant(g, playerX, playerY, maxRadius, lightWalls, maxObstacles, -1, 1); // north west quadrant
    computeQuadrant(g, playerX, playerY, maxRadius, lightWalls, maxObstacles, -1, -1); // south west quadrant
  } /* End of computeFov() */
  
  private void computeQuadrant (Grid g, int playerX, int playerY, int maxRadius, boolean lightWalls, int maxObstacles, int dx, int dy) {
    double startAngle[], endAngle[];
    startAngle = new double[maxObstacles * 2]; 
    endAngle = new double[maxObstacles];
    //octant vertical edge 1, 2, 5, 6
    {
      int iteration = 1;
      boolean done = false;
      int totalObstacles = 0;
      int obstaclesInLastLine = 0;
      double minAngle = 0.0;
      int x, y; // crosshairs of scan
      // do while there are unblocked slopes left and the algo is within the grid matrix boundaries
      // scan progressive rows/columns from the Hero outwards
      y = playerY + dy;
      if (y < 0 || y >= g.y) //check if scan is within boundries
        done = true;
      while (!done) {
        //process cells in the rows
        double slopesPerCell = 1.0 / (double)(iteration + 1);
        double halfSlopes = slopesPerCell * 0.5;
        int processedCell = (int)(minAngle / slopesPerCell);
        int minx = Math.max(0, playerX - iteration), maxx = Math.min(g.x - 1, playerX + iteration);
        done = true;
        
        for (x = playerX + (processedCell * dx); x >= minx && x <= maxx; x += dx) {
          //calculate slopes per cell
          boolean visible = true;
          double startSlope = (double)processedCell * slopesPerCell;
          double centreSlope = startSlope + halfSlopes;
          double endSlope = startSlope + slopesPerCell;
          
          if (obstaclesInLastLine > 0 && g.cell[x][y].fov == false) { 
            int idx = 0;
            while (visible && idx < obstaclesInLastLine) {
              if (g.cell[x][y].transparent == true) {
                if (centreSlope > startAngle[idx] && centreSlope < endAngle[idx]){ visible = false; }
              }
              else { // if cell is not transparent or other
                if (startSlope >= startAngle[idx] && endSlope <= endAngle[idx]){ visible = false; }
	      }
              if (visible && (g.cell[x][y - dy].fov == false || !g.cell[x][y - dy].transparent) && (x - dx >= 0 && x - dx < g.y && (g.cell[x- dx][y - dy].fov == false || !g.cell[x- dx][y - dy].transparent))){ visible = false; }
	      idx++;
	    }
	  }

          if (visible) {
	    g.cell[x][y].fov = true;
	    done = false;
	    // if the cell is opaque, block the adjacent slopes
	    if (!g.cell[x][y].transparent) {
	      if (minAngle >= startSlope)
	        minAngle = endSlope;
	      else {
	        startAngle[totalObstacles] = startSlope;
		endAngle[totalObstacles++] = endSlope;
	      }
	      if (!lightWalls){ g.cell[x][y].fov = false; } // alternate option
	    }
	  }
	  processedCell++;
        }
	if (iteration == maxRadius)
	  done = true;
	iteration++;
	obstaclesInLastLine = totalObstacles;
	y += dy;
	if (y < 0 || y >= g.y)
	  done = true;
	if (minAngle == 1.0)
	  done = true;
      }
    }
    //octant horizontal edge 3, 4, 7, 8
    {
      int iteration = 1; //iteration of the algo for this octant
      boolean done = false;
      int totalObstacles = 0;
      int obstaclesInLastLine = 0;
      double minAngle = 0.0;
      int x, y; // crosshairs of scan
      //do while there are unblocked slopes left and the algo is within the map's boundaries
      // scan progressive rows/columns from the Hero outwards
      x = playerX + dx; //the outer slope's coordinates (first processed line)
      if (x < 0 || x >= g.x)
        done = true;
      while (!done) {
        //process cells in the row
	double slopesPerCell = 1.0 / (double)(iteration + 1);
	double halfSlopes = slopesPerCell * 0.5;
	int processedCell = (int)(minAngle / slopesPerCell);
	int miny = Math.max(0, playerY - iteration), maxy = Math.min(g.y - 1, playerY + iteration);
	done = true;

	for (y = playerY + (processedCell * dy); y >= miny && y <= maxy; y += dy) {
	  int c = x + (y * g.y);
	  //calculate slopes per cell
	  boolean visible = true;
	  double startSlope = (double) (processedCell * slopesPerCell);
	  double centreSlope = startSlope + halfSlopes;
	  double endSlope = startSlope + slopesPerCell;

	  if (obstaclesInLastLine > 0 && g.cell[x][y].fov == false) {
	    int idx = 0;
	    while (visible && idx < obstaclesInLastLine) {
	      if (g.cell[x][y].transparent == true) {
	        if (centreSlope > startAngle[idx] && centreSlope < endAngle[idx]){ visible = false; } 
	      } else {// if cell is not transparent or other
	          if (startSlope >= startAngle[idx] && endSlope <= endAngle[idx]){ visible = false; }
	      }
	      if (visible && (g.cell[x - dx][y].fov == false || !g.cell[x - dx][y].transparent) && (y - dy >= 0 && y - dy < g.x && (g.cell[x - dx][y - dy].fov == false || !g.cell[x - dx][y - dy].transparent))){ visible = false; }
	      idx++;
	    }
          }
	  if (visible) {
            g.cell[x][y].fov = true;
	    done = false;
	    // if the cell is opaque, block the adjacent slopes
	    if (!g.cell[x][y].transparent) {
	      if (minAngle >= startSlope)
		minAngle = endSlope;
	      else {
		startAngle[totalObstacles] = startSlope;
		endAngle[totalObstacles++] = endSlope;
	      }
	      if (!lightWalls){ g.cell[x][y].fov = false; }// alternate option.
	    }
          }
	  processedCell++;
	}
	if (iteration == maxRadius)
	  done = true;
	iteration++;
	obstaclesInLastLine = totalObstacles;
	x += dx;
	if (x < 0 || x >= g.x)
	  done = true;
	if (minAngle == 1.0)
	  done = true;
      }
    }
  }
}




