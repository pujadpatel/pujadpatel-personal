// all circles are shapes
// circle is a subclass of Shape, Shape is a superclass of circle
// circle inherits from Shape

public class Circle extends Shape
{
  public Circle ( int _x, int _y, double _radius)
  {
    //how am I a shape? I am like new Shape (_x,_y)
    super ( _x, _y);
    radius = _radius;
  }
  
  public String toString ()
  {
   return shapeType() + " : radius = " + radius;
  }
  
  public String shapeType()
  {
    return "Circle";
  }
  
  //override getPerimenter
  public double getPerimeter()
  {
    return 2 * radius * Math.PI;
  }
  public double getArea()
  {
    return radius * radius * Math.PI;
  }
  
  public double getarea()
  {
  return radius * radius* Math.Pi;
  }
}