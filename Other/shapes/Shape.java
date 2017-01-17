//Inheritance

public class Shape
{
  private int x;
  private int y;
  private Color color;
  
  public Shape (int _x,int _y, Color _color)
  {
    x=_x;
    y=_y;
  }
  
  
  //acesssor method
  
  public Color getColor()
  {
    return color;
  }
  
  public int getx()
  {
    return x;
  }
    public String shapeType()
  {
    return "Shape";
  }
    
  public int getY()
  {
    return y;
  }
  //mutator method
  public void translate ( int dx, int dy)
  {
    x +=dx;
    y +=dy;
  }
  public String toString()
  {
    return "Shape 0 " + x + "," + y;
  }
  public double getPerimeter()
  {
    
  }
  
  public double getArea()
  {
    return 0.0;
  }
}
  