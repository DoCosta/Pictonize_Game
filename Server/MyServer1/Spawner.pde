import java.util.*;
class Spawner{
  private Coin c = new Coin();
  public Street s = new Street();
  private Player p = new Player();
  private float x;
  private float x2;
  private float amount = 100;
  public boolean isAlive;
  private Random r = new Random();
  public Spawner(){
    x = width;
    x2 = 0;
    isAlive = true;
  }
  public void run(){
      if(s.checkHit(mouseX,mouseY)){isAlive = false;}
      if(isAlive){
        // Street
          fill(255);
          noStroke();
          rectMode(CORNER);
          rect(0, 150, width, 50);  
          rect(0, 375, width, 50);
          rect(0, 600, width, 50);
          
        c.draw();
        p.draw();
        s.run();
      int randomNumber = (int)r.nextDouble(amount);
        
        switch(randomNumber){
          case 0:
            if(!s.checkHit(x - 50, 225)){s.addCar(new Car(x, 225));}
            break;
          case 1:
            if(!s.checkHit(x - 50, 325)){s.addCar(new Car(x, 325));}
            break;
          case 2:
            if(!s.checkHit(x2 + 50, 450)){s.addCar(new Car(x2, 450));}
            break;
          case 3:
            if(!s.checkHit(x2 + 50, 550)){s.addCar(new Car(x2, 550));}
            break;
          default:
            break;
          
        }if(amount >= 15){amount -= 0.02;}
      }else{
          fill(0);
          background(255);
          textSize(20);
          textFont(createFont("Arial",40));
          text("You Lost :(", width / 2 - 100, height / 2);
          text("Score: " + c.score , width / 2 - 100, height / 2 + 80);
          }
          
    
  }
    
}
