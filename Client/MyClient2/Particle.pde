public class Particle{
  private float x, y;
  private float xS, yS;
  private int r,g,b, alpha;
  private int SIZE = 40;
  private float angle = 0;
  
  public boolean isBurst = false;
  
  public Particle(){
    x = -1000;
    y = -1000;
    alpha = 255;
    r = (int)random(1,255);
    g = (int)random(1,255);
    b = (int)random(1,255);
  }
  public void draw(){
    stroke(r,g,b,alpha);
    fill(r,g,b,alpha);
    rectMode(CENTER);
    pushMatrix();
      translate(x,y);
      rotate(degrees(angle));
      rect(0,0,SIZE,SIZE);
    popMatrix();
  }
  public void update(){
    if(!isBurst){
      x = mouseX;
      y = mouseY;
    }
    else{
      if(x >= width - SIZE/2){x = width - SIZE/2; xS = 0;}
      else if(x <= 0 + SIZE/2){x = 0 + SIZE/2;xS = 0;}
      else{
        if(y != height-SIZE/2 ){x += xS;} else{x += xS; if(xS >0){xS -= 0.01;}else{xS -= 0.01;}}
      }
      
      if(y >= height - SIZE/2){y = height - SIZE/2;}
      else{
        y += yS;
        yS += 0.2;
        angle += 0.001;
      }if(y <= 0 + SIZE/2){y = 0 + SIZE/2;}
      alpha -= (int)random(2, 6);
    }
  }
  
  public void burst(float mx, float my){
    isBurst = true;
    x = mx;
    y = my;
    xS = random(-10,10);
    yS = random(-10,10);
  }
  
  public float getY(){return y;}
  public int getA(){return alpha;}
}
