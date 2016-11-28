


class scumBullet {
  //Use one bullet object over and over again.

  float xPos = 10000;
  float yPos = 10000;
  float wide = 48;
  float tall = 48;
  int yVel = scumBulletSpeed;//5+(15*enemylevel);
  int interval = 15;
  

    
    
  Animation scumbull = new Animation("sprites/aliendropping", 8, 41, 70, 0);
//The bullet need to come from the enemy ship, which changes
//position, and detect if it collides with the hero ship,
//which changes position. This code updates the update function
//continuously with whatever the current position data are.
  void update(float _xPos, float _yPos, float you_xPos, float you_yPos) {

    if (yPos >= height+tall) { //If the bullet's position is past
    //the top of the screen plus a little
      if (scumAttack == true) { //If the enemy is still firing
        //Move the bullet back on screen to where it should appear
        //from the enemy ship:
        xPos = _xPos+(myAlienScum.wide/2)-(wide/2);
        yPos = _yPos+(tall*2);
        hitMe.rewind();
        hitMe.play();
      } 
      else { //Otherwise place it way off screen again:
        xPos = 10000;
        yPos = 10000;
      }
    }
    //If the bullet is onscreen
    else if (xPos >= 0 && xPos <= width) {
      if (yPos <= height+tall && yPos >= 0) {
        yPos += 5+(10*enemylevel); //Give it downward velocity.
        //xPos += yVel;
      }
    }
    
    
//Bullet Coverage(hit area) for X Axis
//line(you_xPos+meYou.wide,0, you_xPos+meYou.wide, 600);
//line(you_xPos,0, you_xPos, 600);


//If the bullet collides with the hero ship
    if ((xPos+20) >= you_xPos && (xPos+20) <= you_xPos+meYou.wide) {
      
      if ((yPos+70) >= you_yPos) {
        //println("COLLISION"); //debug code
        youHealth--; //Subtract a point of health.
        //explosion.playTimes(you_xPos,you_yPos, 2);
        medamage.rewind();
        medamage.play();
        if (scumAttack == true) { //If the enemy is still firing
          //Move the bullet back on screen to where it should appear
          //from the enemy ship:
          xPos = _xPos+(myAlienScum.wide/2)-(wide/2);
          yPos = _yPos+(tall*2);
        } 
        else { //Otherwise place it way off screen again:
          xPos = 10000;
          yPos = 10000;
        }
      }
    }
  }

  void display() {
    stroke(255, 0, 0);
    //Draw three bullets, just for debugging purposes
    
    scumbull.display(xPos, yPos);
    //ellipse(xPos+interval, yPos, wide, tall);
    //ellipse(xPos-interval, yPos, wide, tall);
    //fill(180);
    //ellipse(xPos, yPos, wide, tall);
   
    
    stroke(255);
    
  }
}