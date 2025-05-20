import controlP5.*;
import processing.net.*;
import java.util.*;

private Client myClient;

final String SERVER_IP = "127.0.0.1";
final int SERVER_PORT = 5204;

private ArrayList<Pixel> myPixels;
private ArrayList<Particle> p = new ArrayList<>(1600);
private String dataString;
private int l, a;
private float score;
private boolean hasWon, hasLost;

private ControlP5 p5;
private Textfield textFieldGuess, textFieldName;


void setup() { 
  size(800, 800);
  background(255);
  frameRate(120); 
  
  ControlFont cf1 = new ControlFont(createFont("Arial",20));
  p5 = new ControlP5(this);
  myPixels = new ArrayList<>();
  myClient = new Client(this, SERVER_IP, SERVER_PORT);
  score = 1000.0;
  
  // GUI
  p5.addButton("sendGuess").setFont(cf1).setLabel("Send Guess!").setSize(200,50).setPosition(450,650);
  textFieldGuess = p5.addTextfield("Enter Guess").setFont(cf1).setSize(200,50).setPosition(200,650).setColorLabel(0);
  textFieldName = p5.addTextfield("Username").setLabel("Enter Username").setFont(cf1).setSize(200,50).setColorLabel(0).setPosition(width / 2 - 100,50);
  // GUI END
} 
 
 
void draw() { 
  background(255);
  if (myClient.available() > 0) { 
    dataString = myClient.readString(); 
    createPixels(dataString);
  }
  particleHandling();
  fill(0);
  textSize(25);
  text("Score: " + (int)score, width - 160, 50);
  drawPixels();
} 

private void drawPixels(){
  for(Pixel pix : myPixels){
    pix.draw();
  }
}




private void createPixels(String dataString){
  String[] myArray = dataString.split(", ");
    if(Integer.parseInt(myArray[0]) == 10000){
      background(255);
      hasWon = true;
      myPixels.clear();
      a = 0;
    }
    
    else if(Integer.parseInt(myArray[0]) == -10000){
      background(255);
      hasLost = true;
      hasWon = true;
      myPixels.clear();
      a = 0;
    }
    
    else if(Integer.parseInt(myArray[0]) == -999){
      background(255);
      myPixels.clear();
    }
    
    else if(myArray.length == 5){
      myPixels.add(new Pixel(
      Integer.parseInt(myArray[0]), 
      Integer.parseInt(myArray[1]), 
      Integer.parseInt(myArray[2]),
      Integer.parseInt(myArray[3]),
      Integer.parseInt(myArray[4])));
      if(score >= 0){score -= 0.4;}
  } 
}

public void sendGuess(){
  myClient.write(textFieldName.getText() + ", "+ textFieldGuess.getText()+", "+ this.score);
}

private void checkOld(){
  for(int i = 0; i < p.size(); i++){
    if((p.get(i).getY() > height + 50) && p.get(i).isBurst == true || p.get(i).alpha <= 0){
      p.remove(i);
      l--;
    }
   } 
}

private void particleHandling(){
  if(hasWon && a < 500){
      createParticles();
    }
    else if(a >= 500){
      background(255);
      hasWon = false;
      hasLost = false;
      textFieldGuess.setText("");
      myPixels.clear();
      score = 1000.0;
      a = 0;
    }
    checkOld();
}


//Particles part start
private void createParticles(){
      int amount = (int)random(1,7);
      background(255);
      for(Particle c : p){
        c.draw();
        c.update();
       }  
       checkOld();
      while(l < p.size()){
        p.get(l).burst(mouseX,mouseY);
        l++;
        a++;
      }
       for(int i = 0; i < amount; i++){
        p.add(new Particle());
      }
    // Particles end
    if(hasLost){
    textSize(60);
    fill(0);
    text("You Lost!! :(", width / 2 - 150 ,height / 2);
  }else{
    textSize(60);
    fill(0);
    text("You Won!!", width / 2 - 150 ,height / 2); 
  }
}
