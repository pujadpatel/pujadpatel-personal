public class TPiece extends TetrisPiece
  
{
  private int myX;
  private int myY;
  
  private char direction;
  
  public String getName()
  {
    return "T";
  }
  
  
  private int orientation;
  
  private static int UP = 1;
  private static int DOWN = 2;
  private static int RIGHT = 3;
  private static int LEFT = 4;
  
  public TPiece (int _x, int _y)
  {
    myX= _x;
    myY= _y;
    
    orientation = UP;
  }
  
  public void toLeft()
  {
    myX -= 2;
  }
  
  public void toRight()
  {
    myX += 1;
  }
  
  public int [][] getCoordinates ()
  {
    if (orientation == UP)
    {
      int[][] coords = { {myX,myY},{myX+1,myY},{myX-1,myY},{myX,myY-1}};
      return coords;
    }
    else if (orientation == DOWN)
    {
      int [][] coords = {{myX,myY},{myX,myY+1},{myX-1,myY},{myX+1,myY}};
      return coords;
    }
    else if (orientation == RIGHT)
    {
      int[][] coords = {{myX,myY},{myX, myY-1},{myX+1,myY},{myX,myY+1}};
      return coords;
    }
    else
    {
      int[][] coords = {{myX,myY},{myX-1,myY},{myX,myY+1},{myX, myY-1}};
      return coords;}
  }

    
    public void clockwise()
  {
   if (orientation == UP)
   {
     orientation = RIGHT;
   }
   else if (orientation == RIGHT)
   {
     orientation = DOWN;
   }
   else if (orientation == DOWN)
   {
     orientation = LEFT;
   }
   else if (orientation == LEFT)
   {
     orientation = UP;
   }
  }
  
    
  public void counterClockwise()
  {
   if (orientation == UP)
   {
     orientation = LEFT;
   }
   else if (orientation == LEFT)
   {
     orientation = DOWN;
   }
   else if (orientation == DOWN)
   {
     orientation = RIGHT;
   }
   else if (orientation == RIGHT)
   {
     orientation = UP;
   }
  }
    
  }
  