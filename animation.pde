//This is a custom function I programmed to display frames as animations (sprite sheets). 
//We can also set size and speed of animation by passing the required parameters

class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  int speedValue;
  int frameWidth, frameHeight;
  int playCounter = 0;
  Animation(String imagePrefix, int count, int animWidth, int animHeight, int animSpeed) {
    imageCount = count;
    images = new PImage[imageCount];
    speedValue=animSpeed;
    frameWidth = animWidth;
    frameHeight = animHeight;
    
    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(i+1, 4) + ".png";
      images[i] = loadImage(filename);//loading images in an array
    }
  }
  int speed = 0;
  void display(float xpos, float ypos) {
    if(speed>speedValue)//counter/timer to control animation speed
    {
    frame = (frame+1) % imageCount;
    speed = 0;
    }
    else
    {speed++;
    frame = (frame) % imageCount;
    }
    //println(speed);
    image(images[frame], xpos, ypos, frameWidth, frameHeight); //display the frames one after the other
  }
  
  void playTimes(float xpos, float ypos, int playCount) {
    playCounter = playCount;
    while(playCount!=0)
    {
    if(speed>speedValue)//counter/timer to control animation speed
    {
    frame = (frame+1) % imageCount;
    speed = 0;
    }
    else
    {speed++;
    frame = (frame) % imageCount;
    }
    //println(speed);
    image(images[frame], xpos, ypos, frameWidth, frameHeight); //display the frames one after the other
    playCounter--;
    }
  }
  
  
  
  int getWidth() {
    return images[0].width;
  }
}