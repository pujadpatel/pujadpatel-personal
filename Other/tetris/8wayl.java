public class P8wayl extends TetrisPiece

{
  private int myX;
  private int myY;
  
  private char direction;
  
  public String getName()
  {
    return "8wayl";
  }
  
  public Color getForegroundColor()
 {
    return PURPLE;
 }
  public Color getBorderColor()
 {
    return Color.BLACK;
 }
  
  private int orientation;
  
  private static int N = 1;
  private static int NE = 2;
  private static int E = 3;
  private static int SE = 4;
  private static int S = 5;
  private static int SW = 6;
  private static int W = 7;
  private static int NW=8;
  
  public P8wayl (int _x, int _y)
  {
    myX= _x;
    myY= _y;
    
    orientation = N;
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
    if (orientation == N)
    {
      int[][] coords = { {myX,myY},{myX,myY-1},{myX,myY-2},{myX,myY-3}};
      return coords;
    }
    else if (orientation == NE)
    {
      int [][] coords = {{myX,myY},{myX+1,myY-1},{myX+2,myY-2},{myX+3,myY-3}};
      return coords;
    }
    else if (orientation == E)
    {
      int[][] coords = {{myX,myY},{myX+1,myY},{myX+2,myY},{myX+3,myY}};
      return coords;
    }
    else if (orientation == SE)
    {
      int[][] coords = {{myX,myY},{myX+1,myY+1},{myX+2,myY+2},{myX+3,myY+3}};
      return coords;
    }
    else if (orientation == S)
    {
      int[][] coords = {{myX,myY},{myX,myY+1},{myX,myY+2},{myX,myY+3}};
      return coords;
    }
    else if (orientation == SW)
    {
      int[][] coords = {{myX,myY},{myX-1,myY+1},{myX-2,myY+2},{myX-3,myY+3}};
      return coords;
    }
    else if (orientation == W)
    {
      int[][] coords = {{myX,myY},{myX-1,myY},{myX-2,myY},{myX-3,myY}};
      return coords;
    }
    else
    {
      int[][] coords = {{myX,myY},{myX-1,myY-1},{myX-2,myY-2},{myX-3, myY-3}};
      return coords;}
  }

    
    public void clockwise()
  {
   if (orientation == N)
   {
     orientation = NE;
   }
   else if (orientation == NE)
   {
     orientation = E;
   }
   else if (orientation == E)
   {
     orientation = SE;
   }
   else if (orientation == SE)
   {
     orientation = S;
   }
   else if (orientation == S)
   {
     orientation = SW;
   }
   else if (orientation == SW)
   {
     orientation = W;
   }
   else if (orientation == W)
   {
     orientation = NW;
   }
   else if (orientation == NW)
   {
     orientation = N;
   }
   }
  
    
  public void counterClockwise()
  {
   if (orientation == N)
   {
     orientation = NW;
   }
   else if (orientation == NW)
   {
     orientation = W;
   }
   else if (orientation == W)
   {
     orientation = SW;
   }
   else if (orientation == SW)
   {
     orientation = S;
   }
   else if (orientation == S)
   {
     orientation = SE;
   }
   else if (orientation == SE)
   {
     orientation = E;
   }
   else if (orientation == E)
   {
     orientation = NE;
   }
   else if (orientation == NE)
   {
     orientation = N;
   }

  }
    
  }