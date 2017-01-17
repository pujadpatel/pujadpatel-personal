public class IPiece extends TetrisPiece
{
  private int myX;
  private int myY;
  
  private boolean isVertical;
  
    
  public String getName()
  {
    return "I";
  }
  
  public IPiece (int _x, int _y)
  {
    myX = _x;
    myY = _y;
    
    isVertical = false;
  }
  
  public void toLeft()
  {
    myX -=2;
  }
  
  public void toRight()
  {
    myX += 1;
  }
  
  public int[][] getCoordinates()
  {
    if (isVertical)
    {
      int[][] coords = {{myX,myY-1},{myX,myY},{myX,myY+1},{myX,myY+2}};
      return coords;
    }
    else
    {
      int[][] coords= {{myX,myY},{myX+1,myY},{myX+2,myY},{myX-1,myY}};
      return coords;
    }
  }
  
  public void clockwise()
  {
   isVertical= !isVertical; 
  }
  
    
  public void counterClockwise()
  {
   isVertical= !isVertical;
  }
}

    