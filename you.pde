class you { 
  float xPos;
  float yPos;
  float wide;
  float tall;
  int xVel = 4;
Animation heroship;
  you(float _wide, float _tall) {
    
    wide = _wide;
    tall = _tall;
    heroship = new Animation("sprites/glowtube_", 2, int(wide), int(tall), 1);
    xPos = (width/2)-(wide/2); //Right in the middle
    //of the screen.
    yPos = height-(tall/2); //At the very bottom (minus a bit).
  }

//Option to use either arduino or keyboard for control
// for testing purposes only
  void update() {
    /* if (goLeft == true) {
      xPos -= xVel;
    }
    if (goRight == true) {
      xPos += xVel;
    }
    if (xPos >= width-wide) {
      xPos = width-wide;
    }
    if (xPos <= 0) {
      xPos = 0;
    } */
    xPos = mappedValue;
  }

  void display() {
    noFill();
    //rect(xPos, yPos, wide, tall);
    //fill(255,255,0);
    //textFont(font, 24);
    //text(youHealth, xPos+(wide/2), height-(tall/2));
    //The above displays your health on the hero ship.
    
    heroship.display(xPos, yPos-20);
    //noFill();
  }
}