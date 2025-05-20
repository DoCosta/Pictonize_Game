class Car{
  private float speed = 3.0;
  private final float HEIGHT = 30.0;
  private final float WIDTH = 50.0;
  private float x, y;
  public Car(float x, float y){
    this.x = x - WIDTH / 2;
    this.y = y - HEIGHT / 2; 
    form();
  }  
  public void update(){
    if(this.y >= height/2){this.x+=speed;}
    else if(this.y <= height/2){this.x-=speed;}
    form();
  }
  
  private void form(){
    fill(10,10,10);
    rect(this.x, this.y, WIDTH, HEIGHT);  
  }
  
  public float returnCarX(){return x;}
  public float returnCarY(){return y;}
  
  public boolean checkHitbox(float xx, float yy){
    if((xx <= this.x + WIDTH && xx >= this.x) && (yy >= y && yy <= y + HEIGHT)){return true;}
    return false;
  }
}
