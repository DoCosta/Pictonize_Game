import processing.net.*;
import java.util.*;
import controlP5.*;
import de.bezier.data.sql.*;

private static final String MINIGAME_STOP_MESSAGE = "-999, 0";
private static final String CLIENT_WIN_MESSAGE = "10000, 0";
private static final String CLIENT_LOSE_MESSAGE = "-10000, 0";

private Server myServer;
private PImage img;
private Spawner sp;
private color selectedColor;
private WordsFileReader wfr;
private ArrayList<Pixel> myPixels;
private String guessWord;
private boolean isGuessed, hasEnteredGuessWord, playMiniGame, hasDrawed;

private ControlP5 p5;
private SQLite db;
private Button changeWord, miniGame, clearButton;
private Textfield guessInput;
// private ColorPicker cP;
private ControlFont cf1;
private Textarea scoreboardArea;

public void setup() {
  size(800, 800);
  background(255);
  frameRate(120);
  
  p5 = new ControlP5(this);
  img = loadImage("img_colormap.gif");
  sp = new Spawner();
  wfr = new WordsFileReader();
  myPixels = new ArrayList<>();
  myServer = new Server(this, 5204);
  db = new SQLite( this, "data/db.sqlite" ); 
  selectedColor = color(0);
  
  // if (db.connect()){db.query("CREATE TABLE Score (userName varchar(255), score int)");}
 
  // GUI START
  cf1 = new ControlFont(createFont("Arial",20));
  changeWord = p5.addButton("changeWord").setFont(cf1).setLabel("->").setSize(50,50).setPosition(460,650);
  miniGame = p5.addButton("miniGame").setFont(cf1).setLabel("Play Minigame").setSize(200,50).setPosition(50,25);
  clearButton = p5.addButton("clearButton").setFont(cf1).setLabel("Clear Screen").setSize(200,50).setPosition(50,85); // .setPosition(550,50); 
  guessInput = p5.addTextfield("Your Word").setFont(cf1).setSize(250,50).setPosition(200,650).setColorLabel(0).lock();
  // cP = p5.addColorPicker("d").setSize(200,50).setPosition(width / 2 - 125,50).setColorValue(color(0, 0, 0));;
  scoreboardArea = p5.addTextarea("scoreboard").setPosition(width - 200, 0).setSize(200, 200).setLineHeight(18).setColorBackground(color(50, 50, 50)).
  setColor(color(220, 220, 220)).setFont(createFont("Monospaced", 14)).setText(""); 
  
  // GUI END
  
  isGuessed = false;
  updateScoreboard();
}



void draw() {
   image(img, 300, 0);
   if (playMiniGame) {
    background(125);
    sp.run();
    if(!sp.isAlive && mousePressed){
      sp = new Spawner();
    }
    return; // Prevent any drawing
  }else{
    handleClientGuessing();
    if(isInCanvas(mouseY)){
      handleDrawing();
    }
  }
}

private boolean isInCanvas(float y){
  if(y >= 200){
    return true;
  }
  return false;
}

private void dbHandling(String user,int score){
  user = user.toLowerCase();
  if ( db.connect() )
    {
      db.query( "SELECT * FROM Score" );
      while (db.next()) 
      {      
        if(db.getString("userName").equals(user)){
          score += parseInt(db.getString("score"));
          db.query("UPDATE Score SET userName = '" + user + "', score = '"+ score +"' WHERE userName = '" + user + "'"); 
          return;
        }
      }
      try {
           db.query( "INSERT INTO Score VALUES('" + user + "', '" + score + "')");
           db.query( "SELECT * FROM Score" );
          }catch (Exception e) {
              e.printStackTrace();
            }
    }
}

private void handleClientGuessing(){
    Client thisClient = myServer.available();
    if (thisClient !=null && !isGuessed) {
      String clientGuess = thisClient.readString();
      String[] guessData = clientGuess.split(", ");
      String user = guessData[0];
      clientGuess = guessData[1];
      int score = parseInt(guessData[2]);
      if (clientGuess != null) {
        println(user + " guessed: " + clientGuess);
        // Check if user Won
        if(clientGuess.toLowerCase().equals(guessWord)){
          isGuessed = true;
          hasEnteredGuessWord = false;
          background(255);
          fill(0);
          textFont(createFont("Arial",40));
          text( "Player: " + user + " Won!!", 50 ,height / 2); 
          text( "Score: " + score, 50 ,height / 2 + 50); 
          hasDrawed = false;
          dbHandling(user, score);
          // Send clients info if they won or lost
          thisClient.write(CLIENT_WIN_MESSAGE);
          myServer.write(CLIENT_LOSE_MESSAGE);
          updateScoreboard();
        }
      } 
      } 
}
public void mousePressed(){
  color temp = get(mouseX,mouseY);
  if(temp != color(255) && !p5.isMouseOver()){
    selectedColor = temp;
  }
}

private void handleDrawing(){
    int r = int(red(selectedColor));
    int g = int(green(selectedColor));
    int b = int(blue(selectedColor));
    // Send Data to client
    if(mousePressed && hasEnteredGuessWord && !isGuessed && !p5.isMouseOver()){
      hasDrawed = true;
      Pixel p = new Pixel(mouseX,mouseY,r,g,b);
      myPixels.add(p);
      myServer.write(p.toDataString());
    } else if(mousePressed && isGuessed){
          isGuessed = false;
          hasEnteredGuessWord = false;
          guessWord = "";
          guessInput.setText("");
          myPixels.clear();
          hasDrawed = false;
          background(255);
        }
}


public void changeWord(){
  if(!hasDrawed){
    String word = wfr.returnWord();
    guessInput.setText(word);
    guessWord = word.toLowerCase();
    hasEnteredGuessWord = true;
  }
}

public void miniGame(){
  myPixels.clear();
  sp = new Spawner();
  myServer.write(MINIGAME_STOP_MESSAGE);
  if(playMiniGame == true){
    playMiniGame = false; 
    background(255);
    guessInput.setVisible(true);
    changeWord.setVisible(true);
    clearButton.setVisible(true);
    scoreboardArea.setVisible(true);
    miniGame.setLabel("Play miniGame");
  }
  else{
    playMiniGame = true;
    guessInput.setVisible(false);
    changeWord.setVisible(false);
    clearButton.setVisible(false);
    scoreboardArea.setVisible(false);
    hasDrawed = false;
    miniGame.setLabel("Stop Game");
}
}
private void updateScoreboard() {
    int rank = 0;
    StringBuilder sb = new StringBuilder();
    sb.append("--- SCOREBOARD ---\n\n");

    if (db.connect()) {
        try {
            String sqlQuery = "SELECT userName, score FROM Score ORDER BY score DESC";
            db.query(sqlQuery);

            boolean scoresFound = false;
            while (db.next()) {
                scoresFound = true;
                rank++; 
                String userName = db.getString("userName");
                String scoreValue = db.getString("score"); 
                sb.append(String.format("%d. %-12s  %s\n", rank, userName, scoreValue));
            }

            if (!scoresFound) {
                sb.append("No scores yet!\n");
            }

        } catch (Exception e) {
            e.printStackTrace();
            sb.setLength(0); 
            sb.append("--- SCOREBOARD ---\n\n");
            sb.append("Error loading scores.\n");
        } finally {
        }
    } else {
        sb.append("Could not connect to database.\n");
    }

    if (scoreboardArea != null) {
        scoreboardArea.setText(sb.toString());
    } else {
        System.err.println("scoreboardArea is null! Cannot set text.");
    }
}

public void clearButton(){
  myServer.write(MINIGAME_STOP_MESSAGE);
  background(255);
  myPixels.clear();
  hasDrawed = false;
}
