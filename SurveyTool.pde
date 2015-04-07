import java.io.BufferedWriter;
import java.io.FileWriter;

//turn off debugging framerate - DONE
//colors - red exit; blue help; darker arrow buttons - HELP?
//help menu turning off on any click - HELP?
//how many surveys submitted at top - DONE, OVERLAPS MENUS
//move answers to bottom and controls to top - DONE
//automatic email?

boolean FULLSCREEN = true;
TuioHandler myTuioHandler;

PFont digitalFont;
PFont regularFont;
PFont monoSpacedPlain128Font;
PFont monoSpacedPlain17Font;
PFont monoSpacedBold17Font;
PFont sansSerifBold100;
PFont sansSerifPlain100;

int matrixcount = 0;
int matrices = 0;

ArrayList<RadialMenu> menus;
ArrayList<Question> questions;
//ArrayList<String> answers;
int MENUCOUNT = 6; //Used for max possible menus on your display, also passed to maxCursors in TuioHandler
boolean MENUSINVERTED = true; //Call function's 2nd implementation (if necessary) if inverted, original otherwise
//float menuSize = 100;

int Boundary = 0;  //implemented with hard coded magic number height*13/16
float menuSize = 20;
int surveysSubmitted;


PImage qrCode;

void setup() {
  if(FULLSCREEN) size (displayWidth, displayHeight); //run from "Sketch->Present" or "Shift+Command+R"
  else size(1920, 1080);
  smooth(8);
  
  menuSize = width/15;
  
  menus = new ArrayList<RadialMenu>();
  questions = new ArrayList<Question>();
  //answers = new ArrayList<String>();
  myTuioHandler = new TuioHandler(this, MENUCOUNT);
  
  digitalFont = createFont("data/Digital.ttf", 128);
  regularFont = createFont("data/RefrigeratorDeluxeLight.ttf", 128);
  monoSpacedPlain128Font = loadFont("data/Monospaced.plain-128.vlw");
  monoSpacedPlain17Font = loadFont("data/Monospaced.plain-17.vlw");
  monoSpacedBold17Font = loadFont("data/Monospaced.bold-17.vlw");
  sansSerifBold100 = loadFont("data/SansSerif.bold-100.vlw"); 
  sansSerifPlain100 = loadFont("data/SansSerif.plain-100.vlw");
  textFont(monoSpacedBold17Font);
    
  parse();
  
  qrCode = loadImage("TACC_Vislab_Tour_Suggestions.png");
  //println(questions);
  
  //menus.add(new RadialMenu(width/2, height/2));
  
//  img = loadImage("data/background.jpg");
//  img.resize(width, height);
}

void draw() {
    println("At beginning of draw loop, push matrix count is: " + matrices);
    //background(1, 1, 25);
    //background(img);
    //background(25);
    background(0);
    
    RadialMenu bub;
    //drawGradient(width/4, height*3/4);
    float alpha = 44;
    for (int i = 0; i < menus.size(); i++) {
        bub = menus.get(i);
        if(bub.y + bub.radius > height*13/16){
            alpha = 200;
            break;
        }
    }    
    fill(255, alpha);
    rect(0, height * 13/16, width, height * 3/16);
    
    //PRINT SUBMISSION BOX TEXT
    pushStyle();
    textFont(monoSpacedPlain128Font);
    textAlign(CENTER);
    rectMode(CENTER);
    textSize(width/50);
    fill(#FFFF00);
    String text = "SUBMIT HERE";
    text(text, width/2, height * 45/50);
    
    //PRINT HOW MANY SURVEYS ARE SUBMITTED
    textSize(width/80);
    textAlign(LEFT);
    text = "SURVEYS SUBMITTED: " + surveysSubmitted;
    text(text, width/50, height/20);
    
    popStyle();
    
    //If screen is empty, ie, no menus
    if(menus.size() == 0){
        pushStyle();
        
        textFont(monoSpacedPlain128Font);
        textAlign(CENTER);
        //textMode(CENTER);
        textSize(width/40);
        fill(#FFFF00);
        
        text("TAP ANYWHERE", width/2, height/2 - height/50);
        
        popStyle();
    }
    
    for (int i = 0; i < menus.size(); i++) {
        bub = menus.get(i);
        if(MENUSINVERTED)
            bub.display2();
        else
            bub.display();
    }
  //myTuioHandler.debugCursors();
  
  //test email output
//  if(keyPressed){
//    if(key == 'm'){
//      sendEmail(); 
//    } 
//  }
    println("At end of draw loop, push matrix count is: " + matrices);
    matrices = 0;
}

void drawGradient(float x, float y) {
  pushStyle();
  background(0);
  colorMode(HSB, 360, 100, 100);
  noStroke();
  ellipseMode(RADIUS);
  int radius = width;
  float h = 100;
  for (int r = radius; r > 0; --r) {
    fill(205, h, 50);
    ellipse(x, y, r, r);
    if(r % 7 == 0)
      h--;
  }
  popStyle();
}

boolean subBoxContains(float x, float y){
    float radius = (5*menuSize/8) + 20;
    return y >= (height*13/16 - radius); 
}

//*
//            FILE OPERATIONS
//                                              */
                                              
//**
// * Appends text to the end of a text file located in the data directory, 
// * creates the file if it does not exist.
// * Can be used for big files with lots of rows, 
// * existing lines will not be rewritten
// */
void appendTextToFile(String filename, String text){
  File f = new File(dataPath(filename));
  if(!f.exists()){
    createFile(f);
    String words = new String();
    for(int i = 0; i < questions.size() - 1; i++){
      words = words + questions.get(i).question + ",";
    }
    words += "Time Stamp";
    appendTextToFile("answers.csv", words);  
  }
  try {
    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
    out.println(text);
    out.close();
  }catch (IOException e){
      e.printStackTrace();
  }
}

/**
 * Creates a new file including all subfolders
 */
void createFile(File f){
  File parentDir = f.getParentFile();
  try{
    parentDir.mkdirs(); 
    f.createNewFile();
  }catch(Exception e){
    e.printStackTrace();
  }
} 



float BOUNDRY_SIZE = Boundary/2;


