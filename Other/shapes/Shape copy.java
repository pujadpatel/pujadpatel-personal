import java.awt.Color;
import java.awt.Graphics2D;

public abstract class Shape
{
  private int x;
  private int y;
  private Color color;
  
  public Shape ( int _x , int _y , Color _color )
  {
    x = _x;
    y = _y;
  }
  
  public final void changeColor( Color newColor )
  {
    color = newColor;
  }
  
  public final Color getColor()
  {
    return color;
  }
  
  public final int getX()
  {
    return x;
  }
  
  public final int getY()
  {
    return y; 
  }
  
  public final void translate( int dx , int dy )
  {
    x += dx;
    y += dy;
  }
  
  public String toString()
  {
    return shapeType() + " @ " + x + "," + y + attributes(); 
  }
  
  protected abstract String attributes();
  protected abstract String shapeType();
  
  public abstract double getPerimeter();
  public abstract double getArea();
  public abstract void drawWith ( Graphics2D g2d );
}