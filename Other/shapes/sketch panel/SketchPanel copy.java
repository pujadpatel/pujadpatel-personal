import javax.swing.JPanel;
import javax.swing.JFrame;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Color;
import java.awt.Rectangle;

/**
* A simple self-driving {@link JPanel} subclass that allows Java programming students to
* explore the AWT graphics drawing commands.
* 
* @author Dennis Yeh
*/

public class SketchPanel extends JPanel {


/**
* To be implemented by the student
* 
* @param g the {@link Graphics} context in which to paint
*/
  public void paintComponent (Graphics g) {

 Graphics2D g2d = (Graphics2D)g;

 ////////////////////////////////////////////////////////////
 //   Add your drawing commands here                       //

 Shape[ ] shapes = { new House(100,100, Color.BLUE)};
    For ( Shape shape : shapes )
    {
      shape.drawWith(g2d);
      shape.translate (10,10);
      shape.drawWith(g2d);
    }
//                                                        //
 ////////////////////////////////////////////////////////////
  }


  /**
   * Drives SketchPanel by showing a JFrame and setting an instance of
   * SketchPanel as its content pane
   * 
   * @param args command-line arguments (not used)
   */
  public static void main (String[] args) {
    
    JFrame canvas = new JFrame();
    
    canvas.setContentPane( new SketchPanel() );
    canvas.setSize( 800 , 600 );
    canvas.setVisible ( true );
    canvas.toFront ( );
    canvas.setDefaultCloseOperation( JFrame.EXIT_ON_CLOSE );
  }
  }

