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
import javax.swing.ImageIcon;
import java.awt.BorderLayout;
import javax.swing.JLabel;
import java.awt.Image;
import javax.swing.ImageIcon;
import java.awt.*;
import java.io.IOException;
import java.net.URL;
import javax.imageio.ImageIO;
import javax.swing.*;


public class RabbitChase extends JPanel implements KeyListener
{
  static JFrame mainFrame = new JFrame("Rabbit Chase");
  static Random generator = new Random();
  int x;
  int y;
  int wx;
  int wy;
  int score;
  int highscore;
  int delay;
  ArrayList<Integer> carrots;

  boolean needs_repaint;
  boolean on_title_screen;
  boolean on_game;
  boolean on_game_over;
  
  private String rabbitFileName = "rabbit.gif";
  private String wolfFileName = "wolf.gif";
  private Image rabbit;
  private Image wolf;
  public void init_variables()
  {
    delay = 500; //difficulty 
    y = 611;
    x = 335;
    carrots = new ArrayList<Integer>();
    wx = 335;
    wy = 13;
    score = 0;
    
    on_title_screen = true;
    on_game = false;
    on_game_over = false;
    needs_repaint = true;
    for (int i = 0; i < 20; i++)
     {
       Random rand = new Random();
       carrots.add(rand.nextInt(15)*46+13);
       carrots.add(rand.nextInt(15)*46+13);
     }
  }
     
  public void paintComponent(Graphics g)
  {
    super.paintComponent(g);
    if (on_title_screen)
    {
      mainFrame.setBackground( Color.decode("#DDA0DD") );
      g.setColor(Color.BLACK);
      g.drawString("Rabbit Chase! Press Spacebar to Begin!", 230, 200);
      g.drawString("Press 1 for Easy", 290, 100);
      g.drawString("Press 2 for Intermediate", 290, 120);
      g.drawString("Press 3 for Difficult", 290, 140); 
      g.drawString("Rules: Avoid the wolf and collect as many carrots as you can by pressing the spacebar.", 100,250);
      g.drawString("Use the arrow keys to move.", 142, 270);  
    }

    else if (on_game) 
    {
      //gets rabbit image
      URL imgUrl = getClass().getClassLoader().getResource(rabbitFileName);
      if (imgUrl == null) {
         System.err.println("Couldn't find file: " + rabbitFileName);
      } else {
         try {
            rabbit = ImageIO.read(imgUrl);
         } catch (IOException ex) {
            ex.printStackTrace();
         }
      }
      //gets wolf image
      URL imgUrl2 = getClass().getClassLoader().getResource(wolfFileName);
      if (imgUrl2 == null) {
         System.err.println("Couldn't find file: " + wolfFileName);
      } else {
         try {
            wolf = ImageIO.read(imgUrl2);
         } catch (IOException ex) {
            ex.printStackTrace();
         }
      }
      mainFrame.setBackground( Color.decode("#99FF33") );
      //draws grid
      for (int i = 0; i < 16; i++)
      {
        g.drawLine (0,i*46,700,i*46);
        g.drawLine (i*46, 0, i*46, 700);
      }
     //draws carrots
     for (int i = 0; i < carrots.size(); i+=2)
     {
       int xpos = carrots.get(i);
       int ypos = carrots.get(i+1);
       g.setColor(Color.ORANGE);
       g.fillOval(xpos,ypos,20,20);
     }
     g.drawImage(rabbit, x-7, y-8 , null);
     g.drawImage(wolf, wx-12, wy-8, null);
     }

    else 
    {
      mainFrame.setBackground( Color.decode("#AFEEEE") );
      if (score > highscore)
      {
        highscore = score;
      }
      g.drawString("Score: ", 230, 40);
      g.drawString(Integer.toString(score), 330, 40);
      g.drawString("High Score:", 230,60);
      g.drawString(Integer.toString(highscore),330,60);
    }
    needs_repaint = false;
  }
     
    public void wolf_moves()
  {
   //wolf moves in either the x or y direction depending on which is further
   //from the rabbit at that instance
   if (Math.pow(wy-y,2) > Math.pow(wx-x,2))
   {
     if (wy > y && wy>13) 
     {
       wy -= 46;
     }
     else if (wy < y && wy < 657)
     {
       wy += 46;
     }
   }
  else if (Math.pow(wy-y,2) < Math.pow(wx-x,2))
   {
     if (wx > x && wx > 13) 
     {
       wx -= 46;
     }
     else if (wx < x && wx < 657)
     {
       wy += 46;
     }
   } 
  //if the wolf is the same distance from the rabbit in the x and y, he just
  //moves in the x direction
  else
  {
    if (wx > x && wx > 13)
    {
      wx-=46;
    }
    else if (wx < x && wx < 657)
    {
      wx+=46;
    }
  }
  //this slows down the wolfs movement depending on the difficulty
    try 
    {
     Thread.sleep ( delay );
    } 
    catch (Exception ex) {}
    needs_repaint = true;
    
  }
 //checks if there are no more carrots, regrows carrots 
  public void check_carrots()
  {
    if (carrots.size()==0)
    {
     for (int i = 0; i < 20; i++)
     {
       Random rand = new Random();
       carrots.add(rand.nextInt(16)*46+13);
       carrots.add(rand.nextInt(16)*46+13);
     } 
    }
  }
 //checks if the wolf and rabbit are on the same square 
  public void check_death()
  {
    if (wx == x && wy == y)
    {
      on_game = false;
      on_game_over = true;
      needs_repaint = true;
    }
  }
//checks if the rabbit is on a carrot  
  public void check_eat()
  {
    for (int i=0; i<carrots.size(); i+=2)
    {
      if (carrots.get(i) == x && carrots.get(i+1) == y)
      { 
        carrots.remove(i+1);
        carrots.remove(i);
        score += 100;
      }
    }
  }
    

  public void update() 
  {
    if (on_game) 
    {
     wolf_moves();
     check_death();
     check_carrots();
     score++;
    }

    this.repaint();
  }
//User key inputs 
  public void keyPressed(KeyEvent key) 
  {
    if (on_title_screen) 
    { 
      //for difficulty
      if (key.getKeyCode() == KeyEvent.VK_1) {
        delay = 500;
      }
      if (key.getKeyCode() == KeyEvent.VK_2) {
        delay = 350;
      }
      if (key.getKeyCode() == KeyEvent.VK_3) {
        delay = 200;
      }
      //to start game
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
      //eat carrots, move  
      case KeyEvent.VK_SPACE:
          check_eat();
          needs_repaint = true;
          break;
          
      case KeyEvent.VK_LEFT:
        if (x > 13) 
        {
          x -= 46;
          score -= 10;
          needs_repaint = true;
        }
        break;

      case KeyEvent.VK_RIGHT: 
        if (x < 657) 
        {
          x += 46;
          score -= 10;
          needs_repaint = true;
        }
        break;
        
       case KeyEvent.VK_UP: 
        if (y > 13) 
        {
          y -= 46;
          score -= 10;
          needs_repaint = true;
        }
        break;
        
       case KeyEvent.VK_DOWN: 
        if (y < 657) 
        {
          y += 46;
          score -= 10;
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

  public RabbitChase() 
  {
    this.setFocusable(true);
    this.addKeyListener(this);
    mainFrame.setVisible(true);
    mainFrame.setSize(690, 710);
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