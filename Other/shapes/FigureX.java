import java.awt.Graphics2D;
import java.awt.Color;
import java.awt.BasicStroke;
import java.awt.Stroke;

public class FigureX extends Shape
{
 private int x;
 private int y;
}

protected String shapeType()
{
  return "Figure X"
}

 public double getArea ()
 {
   return 0.0;
 }
 
 public double getPerimeter ()
 {
   return 0.0;
 }
 
 private int size = 50; 
 private Color myColor;
 private Stroke myStroke = new BasicStroke (3.0f);

public FigureX ( int _x, int _y, int _size, Color _color, Stroke _stroke)
 {
  this(_x, _y, _size);
    myStroke=_stroke;
}
 
 public FigureX ( int _x, int _y, int _size, Color _color )
 {
    this(_x, _y, _size);
    myColor= _color;
  }
  public FigureX (int _x , int _y)
  {
    x= _x;
    y= _y;
  }
  
  public FigureX ( int _x, int _y, int _size)
  {
   this (_x,_y);
    size=_size;
  }
  
  
  public void drawWith (Graphics2D g2d)
  {
    Stroke currentStroke = g2d.getStroke();
    g2d.setStroke (myStroke);
    Color current = g2d.getColor ();
    g2d.setColor ( myColor);
    g2d.drawLine (x - size, y - size, x + size, y + size);
    g2d.drawLine (x - size, y + size, x + size, y - size);
    g2d.setColor (current);
    g2d.setStroke (currentStroke);
  }
  
  public void setSize (int newSize )
  {
    size= newSize;
  }
  
  //Box.setSize ( 70);
  
  public void translate (int dx, int dy)
  {
    x+=dx;
    y+=dy;
  }
}