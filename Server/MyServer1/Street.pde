class Street{
  private ArrayList<Car> myCars;
  
  public Street(){
    myCars = new ArrayList();
  }
  public void addCar(Car c){
    myCars.add(c);
  }
  
  public void run(){
    for(int i = 0; i < myCars.size(); i++){
      myCars.get(i).update();
      deleteOld(myCars.get(i));
    }
  }
  public ArrayList<Car> returnCars(){
    return myCars;
  }
  
  public void deleteOld(Car c){
    if(c.returnCarX() > 800 || c.returnCarX() < -100){
      myCars.remove(c);
    }
  }
  
  public boolean checkHit(float x, float y){
    for(Car c : myCars){
      if(c.checkHitbox(x,y)){return true;}
    }
    return false;
  }
}
