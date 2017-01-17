import javax.swing.JPanel;
import javax.swing.JFrame;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Color;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import javax.swing.JRadioButton;
import javax.swing.ButtonGroup;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;


/**
 * A simple self-driving {@link JPanel} subclass that allows Java programming students to
 * draw N_omino blocks.
 * 
 * @author      Dennis Yeh
 */

public abstract class N_ominoPanel extends JPanel {
  
  private static final int FRAME_WIDTH = 800;
  private static final int FRAME_HEIGHT = 600;
  private static final int BLOCK_SIZE = 40;
  private static final int BLOCK_BORDER_WIDTH = 5;
  private static final int WIDTH_IN_BLOCKS = FRAME_WIDTH / BLOCK_SIZE;
  private static final int HEIGHT_IN_BLOCKS = FRAME_HEIGHT / BLOCK_SIZE;
  public static final int START_X = WIDTH_IN_BLOCKS / 2;
  public static final int START_Y = HEIGHT_IN_BLOCKS / 2;
  
  private static final N_ominoKeyAdapter adapter = new N_ominoKeyAdapter();
  private static final ButtonGroup chooser = new ButtonGroup();
  private static N_ominoPanel thePanel = null;
  
  private static int N;
  private static N_omino myN_omino;
  
  
  protected N_ominoPanel ( int _N , N_omino[] n_ominoArray ) {
    
   N = _N;
   int numTypes = n_ominoArray.length;
   myN_omino = n_ominoArray[0];
    for (int i = 0 ; i < numTypes ; i++ ) {
      
      JRadioButton nextButton = new JRadioButton( n_ominoArray[i].getName() , false );
      chooser.add( nextButton );
      add(nextButton);
      nextButton.addKeyListener( adapter );
      nextButton.addMouseListener( new ButtonHandler(n_ominoArray[i]));
    }
  }

  
  
  private static class ButtonHandler extends MouseAdapter{
    
    private N_omino piece;
    public ButtonHandler ( N_omino _piece ) {
     
      piece = _piece;
    }
    
    public void mouseClicked( MouseEvent event ) {
      
      myN_omino = piece;
      thePanel.repaint();
    }
  }


  /**
   * Draw the block 
   * 
   * @param g the {@link Graphics} context in which to paint
   */
  public void paintComponent (Graphics g) {
   super.paintComponent(g); // clear screen
   Graphics2D g2d = (Graphics2D)g;

   int[][] blockCoordinates = myN_omino.getCoordinates();
   if (blockCoordinates == null) return;
   checkBounds();
   for (int i = 0 ; i < N ; i++ ) {
     int x = blockCoordinates[i][0]  * BLOCK_SIZE;
     int y = blockCoordinates[i][1]  * BLOCK_SIZE;
    drawSquare ( x , y , g2d );
   }
  }
  
  private static void checkBounds () {
    while (atFarRight()) {
      myN_omino.toLeft();
    }
    while (atFarLeft()) {
      myN_omino.toRight();
    }
  }
      
  private static boolean atFarRight () {
   int[][] blockCoordinates = myN_omino.getCoordinates();
   for (int i = 0 ; i < N ; i++ )
     if ( blockCoordinates[i][0] >= WIDTH_IN_BLOCKS )
       return true;
   return false;
  }
  
  private static boolean atFarLeft () {
   
   int[][] blockCoordinates = myN_omino.getCoordinates();
   for (int i = 0 ; i < N ; i++ )
     if ( blockCoordinates[i][0] < 0 )
       return true;
   return false;
  }
  
  private static void drawSquare( int x , int y , Graphics2D g2d) {
    int borderWidth = BLOCK_BORDER_WIDTH;
    g2d.setColor ( myN_omino.getBorderColor() );
    g2d.fillRect( x, y, BLOCK_SIZE, BLOCK_SIZE);
    g2d.setColor ( myN_omino.getForegroundColor() );
    g2d.fillRect( x+borderWidth, y+borderWidth
                   , BLOCK_SIZE - borderWidth*2 , BLOCK_SIZE - borderWidth*2);
  }
  
  private static class N_ominoKeyAdapter extends KeyAdapter {
    
    public void keyPressed  ( KeyEvent event ) {

      switch ( event.getKeyCode() ) {
       
        case KeyEvent.VK_RIGHT :
          myN_omino.toRight();
          break;
        
        case KeyEvent.VK_LEFT :
          myN_omino.toLeft();
          break;

        case KeyEvent.VK_DOWN :
          myN_omino.toDown();
          break;
          
        case KeyEvent.VK_SHIFT :
          myN_omino.clockwise();
          break;

        case KeyEvent.VK_CONTROL :
          myN_omino.counterClockwise();
          break;
        case KeyEvent.VK_SPACE :
          myN_omino.flip();
          break;
        default:
          return;
      }
    
    thePanel.repaint();
    }
  }

  protected static void initializePanel ( N_ominoPanel _panel ) {
   JFrame canvas = new JFrame();
   canvas.addKeyListener( adapter );
   thePanel = _panel;
   canvas.setContentPane( thePanel );
   canvas.setSize( FRAME_WIDTH , FRAME_HEIGHT );
   canvas.setVisible ( true );
   canvas.setResizable( false );
   canvas.setFocusable ( true );
   canvas.setDefaultCloseOperation( JFrame.EXIT_ON_CLOSE );
  }
  
  /**
   * Drives N_ominoPanel by showing a JFrame and setting an instance of
   * N_ominoPanel as its content pane. By default the instance is a TetrisPanel.
   * 
   * @param args command-line arguments (not used)
   */
  public static void main (String[] args) {
  
    initializePanel( new TetrisPanel() );
  }
}

interface N_omino {
 
  int[][] getCoordinates();
  void toLeft();
  void toRight();
  void toDown();
  void clockwise();
  void counterClockwise();
  void flip();
  String getName();
  Color getForegroundColor();
  Color getBorderColor();
}

