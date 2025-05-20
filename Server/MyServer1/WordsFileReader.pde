import java.io.BufferedReader;
import java.util.*;

class WordsFileReader{
  private BufferedReader reader;
  private String line;
  private Random rn;
  private ArrayList<String> words;
  
  public WordsFileReader(){
    words = new ArrayList<>();
    rn = new Random();
    reader = createReader("Words.txt");
    try {
       while ((line = reader.readLine()) != null) {
        words.add(line);
      }
      }catch (IOException e) {
      e.printStackTrace(); 
    }
  }
  
  public String returnWord(){
    return words.get(rn.nextInt(words.size()));
  }
}
