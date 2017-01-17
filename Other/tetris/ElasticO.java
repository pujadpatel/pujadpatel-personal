public class ElasticO extends TetrisPiece

{
  private int myX;
  private int myY;
  
  private char direction;
  
  public String getName()
  {
    return "ElasticO";
  }
  

  public ElasticOPiece (int _x, int _y)
  {
    myX= _x;
    myY= _y; 
  }
  
 public Color getForegroundColor()
 {
    return PURPLE;
 }
 public Color getBorderColor()
 {
    return Color.BLACK;
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
}