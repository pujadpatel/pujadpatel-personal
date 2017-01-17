public class OPiece extends TetrisPiece
{
  private int myX;
  private int myY;
  
  public OPiece ( int _x, int _y)
   {
     myX = _x;
     myY = _y;
   }
  
  public String getName()
  {
    return "O";
  }
  
  public int[][] getCoordinates()
  {
    int[][] coords = {{myX,myY}, {myX + 1, myY}, {myX + 1, myY + 1}, {myX, myY+1}};
    return coords;
  }
  
  public void toLeft()
  {
    myX -= 2;
  }
  
  public void toRight()
  {
    myX += 1;
  }
  
  public void counterClockwise()
  {
  }
  
  public void clockwise()
  {
  }
  }