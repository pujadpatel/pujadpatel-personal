import java.awt.Graphics2D;
import java.awt.Color;

public class House extends Shape
{
  private int x;
  private int y;
  
  public double getArea()
  {
    return 0.0;
  }
  
  public double getPerimeter()
  {
    return 0.0;
  }
  
  protected String shapeType()
  {
    return "House";
  }
  
  protected String attributes()
  {
    return " size = " + size;
  }
  
  
  private int size = 50;
  private Color color;
   
  public House (int _x , int _y, Color _color)
  {
    super( _x, _y);
    size = _size;
  }
  
   public void drawWith (Graphics2D g2d)
  {
    Color current = g2d.getColor ();
    g2d.setColor ( color);
    //House
    g2d.drawLine (x - size, y - size, x - size, y + size);
    g2d.drawLine (x - size, y - size, x + size, y - size);
    g2d.drawLine (x + size, y - size, x + size, y + size);
    g2d.drawLine (x - size, y + size, x + size, y + size);
    //Roof
    g2d.drawLine (x + size, y - size, x, y - 2*size);
    g2d.drawLine (x - size, y - size, x, y - 2*size);
    //Door
    g2d.drawLine (x - size/6, y + size, x - size/6, y + size/3);
    g2d.drawLine (x + size/6, y + size, x + size/6, y + size/3);
    g2d.drawLine (x - size/6, y + size/3, x + size/6, y + size/3);
    //Windows
    g2d.drawLine (x + size/6, y - size/6, x + 3*size/6, y - size/6);
    g2d.drawLine (x + size/6, y - size/6, x + size/6, y - 3*size/6);
    g2d.drawLine (x + 3*size/6, y - size/6, x + 3*size/6, y - 3*size/6);
    g2d.drawLine (x + size/6, y - 3*size/6, x + 3*size/6, y - 3*size/6);
    g2d.drawLine (x - size/6, y - size/6, x - 3*size/6, y - size/6);
    g2d.drawLine (x - 3*size/6, y - size/6, x - 3*size/6, y - 3*size/6);
    g2d.drawLine (x - size/6, y - 3*size/6, x - 3*size/6, y - 3*size/6);
    g2d.drawLine (x - size/6, y - size/6, x - size/6, y - 3*size/6);   
    g2d.setColor (current);
  }
}