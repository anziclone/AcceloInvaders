//Here is the code to program the Arduino Uno
//to read the information from one analog sensor
//and one digital sensor and output them to the
//serial port (from which Processing can read them.

//As is probably obvious, you would need to copy and
//paste this code into Arduino then upload it to the
//Uno for this to work. It doesn't do anything in
//Processing, which is why I commentented it out. But
//this way you can see it along with the Processing code.


int pushButton = 4; //Connected the pushbutton to digital
//pin 3 to read the button's state.
int potent = A5; //Connected the potentiometer to analog
//pin 0 to read the button's state.
int potValue = 0; //Measure potentiometer output.
int pushValue = 0; //Measure pushbutton output.
int timer;                // debounce timer
const int xpin = A3;                  // x-axis of the accelerometer
const int ypin = A2;                  // y-axis
const int zpin = A1;                  // z-axis (only on 3-axis models)
//The minimum and maximum values that came from
//the accelerometer while standing still
//You very well may need to change these
int minVal = 0;
int maxVal = 1023;

int lastread = 0;
//to hold the caculated values
double x;
double y;
double z;

int n = 0;
int nx =0, ny =0, nz =0;
int xtotal=0, ytotal=0, ztotal=0;
int xdev=0, ydev=0, zdev=0;
int xdevtotal=0, ydevtotal=0, zdevtotal=0;
int angle = 0;
int finalangle = 0;
int cooldowntime = 0;
int stabilizervalue = 200;


enum btn{ON,DEBOUNCE,OFF}; // our own type for button states

btn state;  


void setup(){
  Serial.begin(9600); //Initialize the serial port and
  //tell it to communicate at 9600 bauds.
  pinMode(pushButton, INPUT_PULLUP); //Get info from the button.
}

void loop(){
int xvalue = analogRead(xpin);
delay(1);
int yvalue = analogRead(ypin);
delay(1);
int zvalue = analogRead(zpin);
delay(1);

  potValue = analogRead(potent); //Measure potent. output.
  pushValue = buttonStep(); //Measure button output.
  Serial.print(potValue); //Send potent. reading to serial.
  Serial.print(","); //Will use this in Processing to separate
  //the different outputs.
  //Serial.print(pushValue); //Send button reading to serial.
  //Serial.print(",");
  int shoot = fireangle();
  if(shoot>0)
  {Serial.print(shoot);Serial.print(",");Serial.print("\n"); 
  Serial.print(potValue);Serial.print(",");Serial.print(shoot);Serial.print(",");Serial.print("\n"); 
  
  }
  else
  {Serial.print(shoot);
     Serial.print(",");
  Serial.print("\n");//Make a line break (again for
  }//Send fire reading to serial.
  
  //communicating with Processing.
  
  delay(1); //Add just a little bit of delay to balance out the
  //fact that we are getting and sending information all the time.
  
}

int buttonStep() {
  
  int reading = digitalRead(pushButton);  // check pin reading
  switch (state) {
    case OFF: 
      if (reading == LOW) { // button press?
        state = DEBOUNCE;
        timer = 15;
      } break;
    case DEBOUNCE:
     if (reading == LOW) {  // if button reading remains low
        if (timer <= 0) {   // and the time elapses
          state = ON;       // this is a "real" button press"
          return 0;   
        } else timer--;     // if time hasn't elapsed, but button is still low, keep waiting
     } else state = OFF;     
     break;
    case ON:
      if (reading == HIGH) {
        state = OFF;
        return 1;
      }
  }
}

int fireangle()
{
  int xvalue = analogRead(xpin);
delay(1);
int yvalue = analogRead(ypin);
delay(1);
int zvalue = analogRead(zpin);
delay(1);

if((xvalue > 700 || yvalue > 700 || zvalue > 700 || xvalue < 300 || yvalue < 300 || zvalue < 300) && cooldowntime<1){
 for(n=0; n<3; n++)
 {
  cooldowntime = stabilizervalue;
// print the sensor values:
  //Serial.print("X: ");
  if(xvalue>700 || xvalue < 300)
  { //Serial.print(xvalue-512); 
    nx++; xtotal += xvalue;
  int xd = xvalue - 512;
  xdev = abs(xd);
  xdevtotal += xdev;
  }
  else
  { //Serial.print("___");
  }
  // print a tab between values:
  //Serial.print("\t");
  //Serial.print("Y: ");
  if(yvalue>700 || yvalue < 300)
  { //Serial.print(abs(yvalue-512)); 
    ny++; ytotal += yvalue;
    int yd = yvalue - 512;
  ydev = abs(yd);
  ydevtotal += ydev;}
  else
  { //Serial.print("___");
    }
  // print a tab between values:
  //Serial.print("\t");
  //Serial.print("Z: ");
  if(zvalue>700 || zvalue < 300)
  { //Serial.print(zvalue-512); 
    nz++; ztotal += zvalue;
    int zd = zvalue - 512;
  zdev = abs(zd);
  zdevtotal += zdev;}
  else
  { //Serial.print("___");
    }

  //Serial.print("\t Angle: ");
  angle = RAD_TO_DEG * (atan2(abs(yvalue-512), (xvalue-512))-PI);;
  finalangle += (-angle);
  //Serial.print(-angle);
  //Serial.println();
  // delay before next reading:

 /*
   //read the analog values from the accelerometer
  int xRead = analogRead(xpin);
  int yRead = analogRead(ypin);
  int zRead = analogRead(zpin);

  //convert read values to degrees -90 to 90 - Needed for atan2
  int xAng = map(xRead, minVal, maxVal, -90, 90);
  int yAng = map(yRead, minVal, maxVal, -90, 90);
  int zAng = map(zRead, minVal, maxVal, -90, 90);

  //Caculate 360deg values like so: atan2(-yAng, -zAng)
  //atan2 outputs the value of -π to π (radians)
  //We are then converting the radians to degrees
  x = RAD_TO_DEG * (atan2(-yAng, -zAng) + PI);
  y = RAD_TO_DEG * (atan2(-xAng, -zAng) + PI);
  z = RAD_TO_DEG * (atan2(-yAng, -xAng) + PI);

  //Output the caculations
  Serial.print("x: ");
  Serial.print(x);
  Serial.print(" | y: ");
  Serial.print(y);
  Serial.print(" | z: ");
  Serial.println(z);
*/
  delay(1);

  
}


    /*
    Serial.println();Serial.println();
  Serial.print("X Sum:");Serial.print(xtotal-(nx*512));
  Serial.print("\tY Sum:");Serial.print(ytotal-(ny*512));
  Serial.print("\tZ Sum:");Serial.print(ztotal-(nz*512));

  Serial.println();
  
  Serial.print("X Values:");Serial.print(nx);
  Serial.print("\tY Values:");Serial.print(ny);
  Serial.print("\tZ Values:");Serial.print(nz);
  
  Serial.println();

    Serial.print("X Deviation:");Serial.print(xdevtotal/nx);
  Serial.print("\tY Deviation:");Serial.print(ydevtotal/ny);
  Serial.print("\tZ Deviation:");Serial.print(zdevtotal/nz);
  
  Serial.println(); Serial.println();
  */
  
  xtotal=0; ytotal=0; ztotal=0;
  n=0; nx =0; ny =0; nz =0;
  
  
//Serial.print("\t Final Angle:");Serial.print(finalangle/3);


 int returnangle = finalangle/3;
  finalangle = 0;
 return (returnangle);
}
  
  cooldowntime--;return -1;}
