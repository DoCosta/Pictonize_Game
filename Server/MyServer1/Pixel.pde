public class Pixel{
  int x,y;
  int r,g,b;
  public Pixel(int x, int y, int r,int g,int b){
    this.x = x;
    this.y = y;
    this.r = r;
    this.g = g;
    this.b = b;
    draw();
  }
  public void draw(){
    fill(r,g,b);
    rectMode(CENTER);
    noStroke();
    rect(x, y, 10, 10); 
  }
  
  public String toDataString(){
  
    return x + ", " + y + ", " +r+ ", " + g + ", " + b;
  
  }
}
