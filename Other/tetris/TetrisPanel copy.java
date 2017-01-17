import java.awt.Color;
/**
 * A simple self-driving {@link JPanel} subclass that allows Java programming students to
 * draw Tetris blocks.
 * 
 * @author      Dennis Yeh
 */

public class TetrisPanel extends N_ominoPanel {
  
  private static final TetrisPiece[] PIECES
    = {
 new OPiece(START_X , START_Y),
 new IPiece(START_X , START_Y),
 new TPiece(START_X , START_Y)
//      , new LPiece(START_X , START_Y)
//      , new JPiece(START_X , START_Y)
//      , new SPiece(START_X , START_Y)
//      , new ZPiece(START_X , START_Y)
      };

  public TetrisPanel () {
   super( 4 , PIECES );
  }

  public static void main (String[] args) {
    
    initializePanel ( new TetrisPanel() );
  }
}

abstract class TetrisPiece implements N_omino {
  public abstract String getName();
  public abstract int[][] getCoordinates();
  public void toLeft()
  {
  }
  public void toRight()
  {
  }
  public void clockwise()
  {
  }
  public void counterClockwise()
  {
  }

  public void toDown()
  {
  }
  public void flip()
  {
  }

  private static final Color PURPLE = new Color(100,0,200);
  public Color getForegroundColor() {
    return PURPLE;
  }
  public Color getBorderColor() {
    return Color.BLACK;
  }
}
