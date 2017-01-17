import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JButton;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Color;
import java.awt.event.MouseEvent;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.BasicStroke;
import java.lang.Object;
import java.awt.geom.Arc2D.Double;
import java.awt.RenderingHints;
import java.util.Random;
import java.awt.GridLayout;
import java.awt.Rectangle;

public class spacegame2 extends ListenerPanel
{
  
//  public AnimationPanel animation()
  //{
 //  Rectangle rectange = new Rectangle(); 
 // }
  
  private static int DELAY = 20;
  static int random= (int) (Math.random() * 800 + 1);
  private boolean gameover = false;
  private static Rectangle rectangle = new Rectangle( random , 0 , 20 , 20 );
  private JFrame window;
  private int _x, _y, _height, _width;
  public static final int size = 50;
  private boolean firing = false;

  public void paintComponent (Graphics g) {
       Graphics2D g2d = (Graphics2D)g;
    g.setColor ( new Color(0,0,128) );
    g.fillRect( 0 , 0 , getWidth() , getHeight() );
    
    g.setColor( new Color(105,105,105));
    g.fillRect ( random, 0 , 10, 10);
    
    g.setColor ( Color.yellow );
    g2d.setStroke ( new BasicStroke(4.0f) );  
    g.drawRoundRect ( _x , _y , 50 , 80 , 40 , 40);
    g.drawLine( _x, _y+5, _x+25, _y-30); 
    g.drawLine( _x+50, _y+5, _x+25, _y-30);
    g.drawLine( _x, _y+40, _x-20, _y+70);
    g.drawLine( _x-20, _y+70, _x, _y+70);
    g.drawLine( _x+50, _y+40, _x+70, _y+70);
    g.drawLine( _x+70, _y+70, _x+50, _y+70);
    
    if (firing)
    {
    //g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING,RenderingHints.VALUE_ANTIALIAS_ON);
    g.setColor(Color. red);
    g.drawLine(_x+25, _y-30, _x+25, _y-130);
    }
    
    
   // g.setColor( new Color(105 ,105 ,105 ));
   // g.fillRect(random, 0,20,20);
    //clear(g2d);
    //rectangle.translate(0,2);
    //g2d.fill( rectangle );
  }
  
/*  private void clear( Graphics2D g2d ) {
    Color current = g2d.getColor();
    g2d.setColor( Color.WHITE );
    g2d.fillRect(0,0,getWidth(),getHeight());
    g2d.setColor( current );
  }
*/
  private void animate () { 
    while ( true ) {
      try {
        Thread.sleep ( DELAY );
       } catch (Exception ex) {}
    repaint();
  }
  }
 
  //static int random= (int) (Math.random() * 800 + 1);
  
  public void init()
  {
   setLayout (new GridLayout(20,20));
  }
  
 /* private JFrame window;
  private int _x, _y, _height, _width;
  public static final int size = 50;
  private boolean firing = false;
 */   
  public void keyPressed ( KeyEvent e )
  {
    int code = e.getKeyCode();
    switch ( code )
    {
      case KeyEvent.VK_SPACE:
        firing = true;
        break;
    }
    repaint();
  }  
     
  public void keyReleased ( KeyEvent e )
  {
    int code = e.getKeyCode();
    switch ( code )
    {
      case KeyEvent.VK_LEFT:
        _x -= 8;
        break;
      case KeyEvent.VK_RIGHT:
        _x += 8;
        break;
      case KeyEvent.VK_UP:
        _y -= 8;
        break;
      case KeyEvent.VK_DOWN:
        _y += 8;
        break;
      case KeyEvent.VK_SPACE:
        firing = false;
        break; 
      default:
    }
    repaint();
  }
  
   /* public class spacegame2 ( )
  {
    _x  = 400;
    _y  = 600;
    _width = _height = 200;
    window = getWindow();
    window.setSize( 800 , 800 );
    window.setVisible ( true );
    window.setDefaultCloseOperation ( JFrame.EXIT_ON_CLOSE );
  }
   */  
  /*
    public void paintComponent (Graphics g)
  {
    Graphics2D g2d = (Graphics2D)g;
    g.setColor ( new Color(0,0,128) );
    g.fillRect( 0 , 0 , getWidth() , getHeight() );
    
    g.setColor( new Color(105,105,105));
    g.fillRect ( random, 0 , 10, 10);
    
    g.setColor ( Color.yellow );
    g2d.setStroke ( new BasicStroke(4.0f) );  
    g.drawRoundRect ( _x , _y , 50 , 80 , 40 , 40);
    g.drawLine( _x, _y+5, _x+25, _y-30); 
    g.drawLine( _x+50, _y+5, _x+25, _y-30);
    g.drawLine( _x, _y+40, _x-20, _y+70);
    g.drawLine( _x-20, _y+70, _x, _y+70);
    g.drawLine( _x+50, _y+40, _x+70, _y+70);
    g.drawLine( _x+70, _y+70, _x+50, _y+70);
    
    if (firing)
    {
    //g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING,RenderingHints.VALUE_ANTIALIAS_ON);
    g.setColor(Color. red);
    g.drawLine(_x+25, _y-30, _x+25, _y-130);
    }
     
  } 
  */
   /* private void fire()
    {
    g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
    g.setColor(Color. red);
    g2d.fillOval(_x, _y, 30, 30);
    _x=_x;
    _y=_y+1;
    }
  */
  public static void main (String[] args) 
  {
    JFrame canvas = new JFrame();
    AnimationPanel panel = new AnimationPanel();
    canvas.setContentPane( panel );
    canvas.setSize( 800 , 800 );
    canvas.setVisible ( true );
    canvas.setFocusable ( true );
    canvas.setDefaultCloseOperation( JFrame.EXIT_ON_CLOSE );
    //panel.animate();
    spacegame2 gui = new spacegame2();
  }
}