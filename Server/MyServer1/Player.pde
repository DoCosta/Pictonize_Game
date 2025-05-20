public class Player{
  private final int WIDTH = 10, HEIGHT = 10;
  public Player(){
    
  }
  public void draw(){
    fill(0, 128, 0);
    rect(mouseX -WIDTH/2 , mouseY - HEIGHT/2, WIDTH, HEIGHT);
  }
}
