class youBullet {
  //This all works exactly the same way as with the scumBullet,
  //just in reverse - the bullet comes from the hero ship at the
  //bottom of the screen and moves upward whenever the player
  //is firing. Otherwise we store the bullet off screen. It does
  //damage to the enemy, etc. See the scumBullet tab for detailed notes.
  float xPos = -1000;
  float yPos = -1000;
  float wide = 10;
  float tall = 10;
  
Animation mebullet = new Animation("sprites/orbullet_", 15, 40, 40, 1);
  
  //float deg = radians(abs(firedegree-270));
  float deg = radians(firedegree);
  float yVel; //= (5 * cos(deg));//-4;
  float xVel; //= 8 * sin(deg);
  int bulletspeed =10;
  
  void update(float _xPos, float _yPos, float scum_xPos, float scum_yPos) {
//println(degreebuffer);
    if (yPos <= -tall) {
      
      
      if (shoot == true) {
        deg = radians(firedegree);
        yVel = -abs((bulletspeed * cos(deg)));//-4;
        xVel = bulletspeed * sin(deg);
        //println("xVel: " + xVel + "\t yVel: " +yVel); 
        xPos = _xPos+(meYou.wide/2)-(wide/2);
        yPos = _yPos-(tall*2);
        hitScum.rewind();
        hitScum.play();
      } 
      else {
        xPos = -1000;
        yPos = -1000;
      }
    }
    
          
          
    else if (xPos >= 0 && xPos <= width) {
      
          if (xPos < wide || xPos>(width-wide))
     {
          xVel *= -1;          
          
          }
          
      if (yPos >= -tall && yPos <= height) {
        yPos += yVel;
        xPos += xVel;
        
      }
    }
    
    
          

    if (xPos >= scum_xPos && xPos <= scum_xPos+myAlienScum.wide) {
      if (yPos >= scum_yPos && yPos <= scum_yPos+myAlienScum.tall) {
        scumHealth--;
        scumdamage.rewind();
        scumdamage.play();
        if (shoot == true) {
          xPos = _xPos+(meYou.wide/2)-(wide/2);
          yPos = _yPos-(tall*2);
        } 
        else {
          xPos = -1000;
          yPos = -1000;
        }
      }
    }
  }

  void display() {
    //stroke(0, 255, 0);
    //rect(xPos, yPos, wide, tall);
    //stroke(255);
    mebullet.display(xPos, yPos);
  }
}