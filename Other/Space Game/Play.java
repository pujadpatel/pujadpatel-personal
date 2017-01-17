import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.Graphics2D;
import java.awt.BasicStroke;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.Timer;

public class Play extends JPanel implements KeyListener
{
  static JFrame mainFrame = new JFrame("Space Rocks");
  static int y = 625;
  static int[] locations = {0, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500,
                            550, 600, 650, 700, 750, 800};
  static Random generator = new Random();
  int x;
  int score;
  List<int[]> blocks = new ArrayList<int[]>();
  boolean needs_repaint;
  boolean on_title_screen;
  boolean on_game;
  boolean on_game_over;

  public void init_variables()
  {
    x = 400;
    score = 0;
    blocks.clear();
    on_title_screen = true;
    on_game = false;
    on_game_over = false;
    needs_repaint = true;
  }

  public void paintComponent(Graphics g)
  {
    super.paintComponent(g);
    if (on_title_screen)
    {
      g.setColor(Color.BLACK);
      g.drawString("Space Rocks! Press Spacebar to play", 230, 70);
    }

    else if (on_game) 
    {
      g.setColor(Color.RED);
      Graphics2D g2d = (Graphics2D)g;
      g2d.setStroke ( new BasicStroke(3.0f) );  
      g.drawRoundRect ( x , y , 13 , 20 , 10 , 10);
      g.drawLine( x, y+2, x+7, y-8); 
      g.drawLine( x+13, y+2, x+7, y-8);
      g.drawLine( x, y+10, x-5, y+18);
      g.drawLine( x-5, y+18, x, y+18);
      g.drawLine( x+13, y+10, x+18, y+18);
      g.drawLine( x+13, y+18, x+13, y+18);
      g.setColor(Color.BLACK);
      int i;
      for (i = 0; i < blocks.size(); i++)
      {
        g.setColor(Color.GRAY);
        g.fillRect(blocks.get(i)[0], blocks.get(i)[1], 30, 30);
      }
    }

    else 
    {
      g.drawString("Score ", 2, 40);
      g.drawString(Integer.toString(score), 50, 40);
    }
    needs_repaint = false;
  }

  public void blocks_gravity() 
  {
    int i;
    for (i = 0; i < blocks.size(); i++) 
    {
      blocks.get(i)[1] += 12;  //Speed
    }
  }

  public void add_blocks_on_random_location() 
  {
    int[] mylist = {locations[generator.nextInt(locations.length)], 0};
    blocks.add(mylist);
  }

  public void update() 
  {
    if (on_title_screen) 
    {
      if ( generator.nextInt(10) == 1 ) 
      {
        add_blocks_on_random_location(); 
      }

      blocks_gravity(); 
    }

    else if (on_game) 
    {
      add_blocks_on_random_location(); 
      blocks_gravity(); 
      score++; 
      int i;
      for (i = 0; i < blocks.size(); i++) 
      {
        if (blocks.get(i)[1] > 520 && blocks.get(i)[1] < 600 &&
            blocks.get(i)[0] == x) 
        {
          on_game = false;
          on_game_over = true;
        }
      }
    }

    this.repaint();
  }

  public void keyPressed(KeyEvent key) 
  {
    if (on_title_screen) 
    {
      if (key.getKeyCode() == KeyEvent.VK_SPACE) {
        on_title_screen = false;
        on_game = true;
        needs_repaint = true;
      }
    }

    else if (on_game) 
    {
      switch (key.getKeyCode()) 
      {
      case KeyEvent.VK_LEFT:
        if (x > 0) 
      {
          x -= 25;
          needs_repaint = true;
        }
        break;

      case KeyEvent.VK_RIGHT: 
        if (x < 800) 
      {
          x += 25;
          needs_repaint = true;
        }
        break;
      }
      
    }

    else 
    {
      if (key.getKeyCode() == KeyEvent.VK_SPACE) 
      {
        init_variables();
        needs_repaint = true;
      }
    }
    if (needs_repaint)
      this.repaint();
  }

  public void run() 
  {
    mainFrame.setVisible(true);
    this.requestFocus();
    init_variables(); 
  }

  public Play() 
  {
    this.setFocusable(true);
    this.addKeyListener(this);
    mainFrame.setSize(852, 800);
    mainFrame.setResizable(false);
    mainFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    mainFrame.getContentPane().add(this);
    Timer timer = new Timer(25, new ActionListener()
     {
      public void actionPerformed(ActionEvent e) 
      {
        update();
      }});
    timer.start();
  }
  public void keyReleased(KeyEvent arg0) {}
  public void keyTyped(KeyEvent arg0) {}
}