public class SPiece extends TetrisPiece

{
  private int myX;
  private int myY;
  
  private boolean isVertical;
  
    
  public String getName()
  {
    return "S";
  }
  
  public SPiece (int _x, int _y)
  {
    myX = _x;
    myY = _y;
    
    isVertical = true;
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
      int[][] coords = {{myX,myY},{myX-1,myY},{myX,myY-1},{myX+1,myY-1}};
      return coords;
    }
    else
    {
      int[][] coords= {{myX,myY},{myX+1,myY},{myX,myY-1},{myX+1,myY+1}};
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
  