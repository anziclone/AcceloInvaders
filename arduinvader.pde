import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
//This is the music library which we will be using
  
  
import processing.sound.*;
import processing.serial.*; //Load the library to read
//information from the serial port. In this case we will
//load data from an Arduino.

PFont font, bitfont; //Declare a font.
Serial myPort; //Declare a serial port.
Minim minim; //declare sound Library class
AudioPlayer hitMe, hitScum, titleSfx, winSfx, loseSfx, medamage, scumdamage;//Declare  Audio player classes
  int enemylevel = 0;
  int scumBulletSpeed = 5;
AudioPlayer[] GameSfx = new AudioPlayer[6]; // Declare array of audioplayers for various soundtrack selection

String bgsfxfilename; //intermediate variable used to load audio files in player class
int [] copiedValues = new int[2]; //Make an array to store
//the values we get from the Arduino. This is necessary so
//we can use the data in Processing.

//The following code declares instances of four objects of the game.
you meYou;
youBullet myBullet;
alienScum myAlienScum;
scumBullet itsBullet;

//Declaration of other assets used in the game
int sfxselect=0;
int losingn =0;
 int winningn =0;
PImage alienship, alienship1, alienship2;
 PImage bg, gameoverbg, enemyhealth, skullship, gameWin;
 Animation splash, lives, splashChar, explosion;
 
 int YouStartHealth = 3;
 int ScumStartHealth = 3;
 int seperatorLength = 3;
 
//Will use the following four booleans to control
//whether movement and shooting are possible.
boolean goLeft = false;
boolean goRight = false;
boolean shoot = false;
boolean scumAttack = true;
int firedegree;
//Variables to control health, level and movement.
int youHealth;
int scumHealth;
int gameState;
float mappedValue,dialmap; 
int n=0;
int degreebuffer;

 
void setup() {
  println("Setup has started running...");
  //Initialize each of the variables reading the
  //output from the Arduino.
  copiedValues[0] = 0;
  copiedValues[1] = -1; //'-1' for the pushbutton
  //means the button isn't pressed.

 

  //println(Serial.list()); 
  //code to see a list of the serial ports and determine
  //which one the Arduino is plugged into.
  
  myPort = new Serial(this, Serial.list()[1], 9600);
  //The above opens the serial port
  println(" - Serial Port initialized");
  myPort.bufferUntil('\n');
  //we're using the line break character to separate out
  //each reading from Arduino into discrete chunks so we
  //can use it effectively in Processing. This code says
  //don't make a new serial event until the line break.
  size(1192, 722);
  //fullScreen();
  smooth();
  
  minim = new Minim(this);
  println(" - Sound Engine initialized");
 titleSfx = minim.loadFile("audio/titles/title.wav"); //Initialize  title screen music Audio player classes
 
 hitScum= minim.loadFile("audio/fire.wav"); //Initialize  title screen music Audio player classes
 hitMe= minim.loadFile("audio/scumfire.wav"); //Initialize  title screen music Audio player classes
 loseSfx= minim.loadFile("audio/gameOver.mp3"); //Initialize  title screen music Audio player classes
  medamage= minim.loadFile("audio/medamage.wav"); //Initialize  title screen music Audio player classes
 scumdamage= minim.loadFile("audio/scumdamage.wav"); //Initialize  title screen music Audio player classes
 
 
 println(" \t- Title Screen SFX initialized");
for(int i=0; i<6;i++)
{
  bgsfxfilename = "bgsfx_" + nf(i+1, 4) + ".mp3";
    GameSfx[i] = minim.loadFile("audio/"+bgsfxfilename);//Initialize  game music Audio player classes
    
}

//loading images and sprite sheets for animations
alienship = loadImage("sprites/aliensh.png");
alienship1 = loadImage("sprites/aliensh1.png");
alienship2 = loadImage("sprites/aliensh2.png");
bg = loadImage("sprites/8bitbg.png");
gameoverbg = loadImage("sprites/gameoverbg.png");
enemyhealth = loadImage("sprites/enemy_health_bar.png");
skullship = loadImage("sprites/skullship.png");
gameWin = loadImage("sprites/gameWin.png");
resetGame();
splash = new Animation("sprites/psych_", 12, 1192, 722, 0);
lives = new Animation("sprites/heart_", 22, 32, 32, 8);
splashChar = new Animation("sprites/splashChar_", 96, 304, 222, 0);
explosion = new Animation("sprites/splashChar_", 9, 256, 256, 2);


   
}

void draw() {
  //The potentiometer outputs from 0-1023. Scaling this
  //output proportionate to the width of the sketch using map.
  //We don't want movement off the screen, so we account for
  //the object's width in the mapping.   
  mappedValue = map(copiedValues[0], 0, 1023, 0, width-meYou.wide);
  //print("Mapped Value: " + mappedValue);

  if (copiedValues[1] >= 0) { //If player pressed the button

   //println("Degree Buffer: " + abs(degreebuffer-270));
    if (gameState == 0) { //If it's the title screen
      gameState = 1; //Move to the game play screen.
      //println("button pressed on title screen.");
    }
    else if(gameState == 2 || gameState == 3)
    {resetGame();
    gameState = 0;
    loseSfx.pause();
    loseSfx.rewind();
  //println("button pressed on win/lose screen.");
}
    else {
      
      shoot = true; //Otherwise enable shooting.
      //println("button pressed on game screen.");
    }
  }
  else {
    shoot = false; //Otherwise disable shooting.
  
  }
  
  if (gameState == 0) { //If it's the title screen

  if(!titleSfx.isPlaying())
    {titleSfx.rewind();
    titleSfx.loop();}
    else{}
   
    background(0);
    splash.display(0, 0);
    fill(0,0,0,140);
    noStroke();
    rect(0, 0, 1192, 722);
    fill(255);
  stroke(255);
  strokeWeight(1);
    textFont(font, 48);
    text("Accelo - Invader", width/2, 100);
    textFont(bitfont, 24);
    text("PAT 551 Project\nby Anay", 200, height/2);
    textFont(bitfont, 16);
    text("Roate dial to select difficulty\n[Fire] to begin", width-200, height/2);
    splashChar.display(width/2-152, height/2-201);
//println("Title Page is being run" + (n++)); 

/* Menu Code for Spaceship, Level and Enemy Selection - Work in Progress */
noFill();
stroke(200);
strokeWeight(20);

strokeJoin(MITER);
//arc(width/2, height-50, 600, 600, PI, PI/3-PI/60);
//arc(width/2, height-60, 600, 600, PI/3+PI/60, (2*PI/3)-(PI/60));
arc(width/2, height, 500, 500, radians(180), radians(235));
arc(width/2, height, 500, 500, radians(245), radians(295));
arc(width/2, height, 500, 500, radians(305), radians(360));

dialmap = map(copiedValues[0], 0, 1023, 181, 359);

if (dialmap>=180 && dialmap<240)
{
stroke(#00ff00, 200);
strokeWeight(18);
//fill(#00ff00, 200);
arc(width/2, height, 500, 500, radians(180), radians(235));

enemylevel = 0;
ScumStartHealth = 3;
scumBulletSpeed = 5;
}
else if(dialmap>=240 && dialmap<300)
{
stroke(#ffff00,200);
strokeWeight(18);
//fill(#ffff00,200);
arc(width/2, height, 500, 500, radians(245), radians(295));

enemylevel = 1;
ScumStartHealth = 6;
scumBulletSpeed =20;

}
else if(dialmap>=300 && dialmap<=360)
{
stroke(#ff0000,200);
strokeWeight(18);
//fill(#ff0000,200);
arc(width/2, height, 500, 500, radians(305), radians(360));

enemylevel = 2;
ScumStartHealth = 9;
scumBulletSpeed =35;

}

scumHealth = ScumStartHealth;

/*
stroke(0);
strokeWeight(18);
arc(width/2, height, 500, 500, radians(180), radians(dialmap));
*/


stroke(255);
strokeWeight(9);
line(width/2, height, width/2 + 220 * cos(radians(dialmap)), height + 220 * sin(radians(dialmap)));
    fill(#00ff00);
    textFont(font, 16);
    text("EASY", 300, height-100);
    
    fill(#ffff00);
    textFont(font, 16);
    text("MEDIUM", width/2, height-280);
    
    fill(#ff0000);
    textFont(font, 16);
    text("HARD", width-300, height-100);
    
    
}
  if (gameState == 1) { //If it's the game play screen
    //background(0);
    
    background(bg);
    //scumHealth
    
    
    fill(#FEF200);
    textFont(bitfont, 24);
    text("Lives ", 80, 40);
    
    titleSfx.pause();    
    GameSfx[sfxselect].play();
    
 
  
   
    
    for(int i=0; i<youHealth;i++)
    {
    lives.display(140+(42*i), 10);
    }
    image(enemyhealth, width/2-enemyhealth.width/2, 10);
    
    stroke(200);
    strokeWeight(1);
    strokeJoin(ROUND);
    fill(0,0,0);
    int ehWidth = enemyhealth.width-30;
    int barWidth = (ehWidth - (seperatorLength*ScumStartHealth));
    int pointHealth = barWidth/ScumStartHealth;
    
    for(int i=0; i<ScumStartHealth;i++)
    {      
      rect(((width/2)-(enemyhealth.width/2)+15)+(i*(pointHealth+seperatorLength)), 20, pointHealth, 12);
    
    }
    fill(255,0,0);
    for(int i=0; i<scumHealth;i++)
    {      
      rect(((width/2)-(enemyhealth.width/2)+15)+(i*(pointHealth+seperatorLength)), 20, pointHealth, 12);
    
    }
    noStroke();
    meYou.display();
    meYou.update();
    myBullet.display();
    myBullet.update(meYou.xPos, meYou.yPos, myAlienScum.xPos, myAlienScum.yPos);
    //Above we pass the ever-changing values of the character and
    //enemy object's positions into the update function for the bullet.
    myAlienScum.display();
    myAlienScum.update();
    itsBullet.display();
    itsBullet.update(myAlienScum.xPos, myAlienScum.yPos, meYou.xPos, meYou.yPos);
    //We do the same thing for the enemy's bullet as we did for our bullet.
    if (youHealth <= 0) { //If you reach zero health
      gameState = 2; //Load the game over screen.
    }
    if (scumHealth <= 0) { //If the enemy reaches zero health
      gameState = 3; //Load the game won screen.
      GameSfx[sfxselect].pause();
    }
  }
  
  if (gameState == 2) { //Game over screen.
  GameSfx[sfxselect].pause();
  GameSfx[sfxselect].rewind();
  titleSfx.rewind();
  
  loseSfx.play();
  
    background(gameoverbg);
    fill(0, 0, 255);
    textFont(bitfont, 64);
    text("YOU FAILED.", width/2, height/5);
    textFont(bitfont, 20);
    text("Oops! The Earth is lost.", width/2, 6*(height/7));
    textFont(font, 20);
    text("Fire Away to try again.", width/2, height-(height/9));
    noFill();
    
    //println("Losing screen is being run." + losingn++);
  }
  if (gameState == 3) { //Game won screen.
  GameSfx[sfxselect].pause();
  GameSfx[sfxselect].rewind();
  titleSfx.rewind();
   
  loseSfx.play();
  
  
   background(gameWin);
    fill(0, 0, 255);
    textFont(font, 64);
    text("YOU WIN!", width/2, height/5);
    textFont(bitfont, 16);
    text("Nice One! The Earth is saved.", width/2, 6*(height/7));
    textFont(bitfont, 16);
    text("Fire away to relive your glory.", width/2, height-(height/9));
    noFill();
    //println("Winning screen is being run." + winningn++);
  }
}

//NOTE: the following keyPressed and keyReleased events are relevant
//only if you're playing the game without an Arduino hooked up. In that
//case you can comment out the serial-port-related code and play the
//game using keyboard controls.

//We use key-triggered booleans to enable and disable movement,
//rather than putting the key presses directly into if statements
//updating the position of the object. This makes movement smoother
//and allows Processing to recognize multiple button presses at once.
//Once again I am indebted to Ramiro Corbetta for suggesting this method.
void keyPressed() {
  if (keyCode==LEFT) {
    goLeft = true;
  }
  if (keyCode==RIGHT) {
    goRight = true;
  }
  if (key==' ') { //Space bar.
    shoot = true;
  }

if (key=='w') { //Space bar.
    scumHealth=0;
  }
  
  if (keyCode==ENTER || keyCode==RETURN) {
    if (gameState == 0) { //If it's the title screen
    
      gameState = 1; //Move to the game play screen.
    }
  }
  if (key=='r' || key=='R') {
    //setup(); //Restart the game.
    
     
     if(GameSfx[sfxselect].isPlaying())
     {
     GameSfx[sfxselect].pause();
     GameSfx[sfxselect].rewind();}
     resetGame();
     gameState = 0;
    //NOTE: this doesn't work with the Arduino hooked up for some
    //reason. That seems to be the case for all of us in the class
    //who attempted to use a restart command, so I suspect it has
    //to do with Processing's communication with the Arduino unit.
  }
}

void keyReleased() {
  if (keyCode==LEFT) {
    goLeft = false;
  }
  if (keyCode==RIGHT) {
    goRight = false;
  }
  if (key==' ') {
    shoot = false;
  }
}




void serialEvent (Serial myPort) {

  String inString = myPort.readStringUntil('\n');// get the
  //ASCII string, read until we encounter a new line character
   // println(inString); // print the whole incoming message

  // We do three things here,
  // We split the incoming string when it finds a "," 
  // Copies each splitted string into an array
  // And we convert the string to an int
  int myValueString[] = int(split(inString, ",")); 
  //println(myValueString.length);

  if (myValueString.length>1) { //if the array is larger than two

    //print the info in a fancy way
    //print(" one :"   + myValueString[0]);
    //print(" two :"   + myValueString[1]);
   
    //println();

    //now copy those values into our array, so it can be used in the draw()
    for (int i = 0; i<copiedValues.length ;i++) {
      copiedValues[i] = myValueString[i];
    }
    
    if(copiedValues[1] > 0)
    {firedegree = abs(copiedValues[1]-270);
    println("Angle: "+copiedValues[1] + "\t Calculated Angle: " + firedegree);
if(gameState == 1)
{shoot = true;}
}
  }
  else
  {firedegree = -1;}
}
void resetGame()
{

  gameState = 0; //Set the game to the title screen.
  youHealth = YouStartHealth; //Only one health for you.
  scumHealth = ScumStartHealth; //The enemy gets three health. How
  //is that fair?
  titleSfx.rewind();
  fill(255);
  stroke(255);
  strokeWeight(2);
  meYou = new you(134, 53); //Width and height.
  myBullet = new youBullet();
  myAlienScum = new alienScum(100, 100); //Width and height.
  itsBullet = new scumBullet();
  font = loadFont("MineCrafter-3-24.vlw");
  bitfont = loadFont("MineCrafter-3-24.vlw");
  textAlign(CENTER);
     sfxselect=int(random(1,6));
     
println("Selected Track: " + sfxselect);
println("Reset game was run successfully!");
}