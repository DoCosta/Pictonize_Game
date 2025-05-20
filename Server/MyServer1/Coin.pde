import java.util.Random;
public class Coin{
  private Random rn;
  private int x,y;
  public int score;
  public Coin(){
    rn = new Random();
    x = rn.nextInt(600 - 100) + 50;
    y = rn.nextInt(500 - 100) + 200;
  }
  
  public void draw(){
    fill(255,255,0);
    rect(x, y,20,20);
    collected();
    fill(0);
    textSize(20);
    text("Score: "+ score, width - 150 , 30);
  }
  
  public void collected(){
     if((mouseX <= this.x + 20 && mouseX >= this.x) && (mouseY >= y && mouseY <= y + 20)){
       x = rn.nextInt(width - 100) + 50;
       y = rn.nextInt(500 - 100) + 200;
       score++;
     }
  }
}
