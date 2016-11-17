/*
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

http://www.gnu.org/licenses/
*/



int cx, cy;
float secondsRadius;
float minutesRadius;
float hoursRadius;
float hoursAngle;
float clockDiameter;

PVector horizon;
PVector alarmHand;
PVector centre;
PVector mouse;
PVector AlarmTip;
PVector newAlarmTip;
float ax;
float ay;
float alarmRadius;
float angle;
float angleRed;

boolean rectOver = false;
boolean circleOver = false;
int fade = 0;

boolean red;
boolean greenH;
boolean greenHPlus;
boolean greenHMinus;
boolean greenM;
boolean white;
boolean grey;

void setup() {
  size(640, 640);
  stroke(255);

  int radius     = min(width, height) / 2;
  secondsRadius  = radius * 0.80;
  minutesRadius  = radius * 0.60;
  hoursRadius    = radius * 0.50;
  alarmRadius    = radius * 0.75;
  clockDiameter  = radius * 1.8;

  mouse    = new PVector();
  centre   = new PVector(width/2, height/2);
  AlarmTip = new PVector(width/2, height/2 - secondsRadius);
  horizon  = new PVector(5, 0);


  cx = width  / 2;
  cy = height / 2;
}

void draw() {
  colorMode(RGB, 255, 255, 255, 255);
  update(mouseX, mouseY);
  mouse.set(pmouseX, pmouseY, 0);
  angle = atan2(pmouseY - height/2, pmouseX - width/2);
  background(0);

  //fade in/out
  if (circleOver && fade < 255) {
    fade += 15;
  } else if (!circleOver && fade > 0) {
    fade -= 15;
  }
  //println(fade);

  // Draw the clock background
  fill(80, 80, 80);
  noStroke();
  ellipse(cx, cy, clockDiameter-20, clockDiameter-20);

  // Angles for sin() and cos() start at 3 o'clock;
  // subtract HALF_PI to make them start at the top
  //float s = map(second(), 0, 60, 0, TWO_PI) - HALF_PI;
  float m = map(minute() + norm(second(), 0, 60), 0, 60, 0, TWO_PI) - HALF_PI; 
  float h = map(hour() + norm(minute(), 0, 60), 0, 24, 0, TWO_PI * 2) - HALF_PI;

  ax = (width/2 + (cos(angle) * secondsRadius));
  ay = (height/2 + (sin(angle) * secondsRadius));

  alarmHand = new PVector(ax - width/2, ay - height/2); 


  //alarm cursor
  if (circleOver && mousePressed) {
    //if(mousePressed){  //start here with if if you want to see the cursor
    newAlarmTip = new PVector (ax, ay);
    //stroke(80);
    //strokeWeight(2);
    //line(width / 2, height / 2, ax, ay);
    AlarmTip = newAlarmTip;
    angleRed = atan2(alarmHand.y, alarmHand.x)+HALF_PI;
    if (angleRed < 0) {
      angleRed = angleRed + TWO_PI;
    }
    //println(degrees(angleRed));
    //} //end here with if if you want to see the cursor
  }

  // Draw the hands of the clock
  //stroke(255);
  //strokeWeight(1);
  //line(cx, cy, cx + cos(s) * secondsRadius, cy + sin(s) * secondsRadius);
  strokeWeight(2);
  line(cx, cy, cx + cos(m) * minutesRadius, cy + sin(m) * minutesRadius);
  strokeWeight(4);
  line(cx, cy, cx + cos(h) * hoursRadius, cy + sin(h) * hoursRadius);
  strokeWeight(3);

  // Draw the points
  beginShape(POINTS);  
  for (int a = -90; a < 270; a+=6) {
    float angle = radians(a);
    float x = cx + cos(angle) * secondsRadius;
    float y = cy + sin(angle) * secondsRadius;

    //determine whether an angle needs to be a certain color
    //red alarm
    if (degrees(angleRed) >= 358 && degrees(angleRed) <= 360) {
      angleRed = 0;
    }
    if ((degrees(angleRed)-92) <= a && a <= (degrees(angleRed)-88) // cursor on point
      ||(degrees(angleRed)-88) <= a && a <= (degrees(angleRed)-85)// cursor before point
      ||(degrees(angleRed)-94) <= a && a <= (degrees(angleRed)-92)// cursor behind point
      ||(degrees(angleRed)-88) <= a+360 && a+360 <= (degrees(angleRed)-85)// cursor almost round
      ) { //cursor 
      red = true;
    } else {
      red = false;
    }

    //green Hour
    if (degrees(h)-3 <= a && degrees(h)+2 >= a
      || degrees(h)-3 <= a+360 && degrees(h)+3 >= a+360) {
      greenH = true;
    } else {
      greenH = false;
    }

    //green minute
    if ((degrees(m)-6) <= a && a < degrees(m)) {
      greenM = true;
    } else {
      greenM = false;
    }

    //white hour
    if (a%5 == 0 && a < 270) {
      white = true;
    } else {
      white = false;
    }

    /*booleans: circleOver red greenH greenM white grey */
    strokeWeight(15);

    if (red) {
      stroke(255, 0, 0, fade); //red
    } else if (!red && !greenH && !greenHPlus && !greenHMinus && !greenM && white) {
      stroke(255, 255, 255, fade); //white
    } else if (!red && !greenH && greenM) {
      stroke(0, 255, 0, fade); //green minute
    } else if (!red && !greenH && !greenM && !white) {
      stroke(100, 100, 100, fade); //grey
    } else if (!red && greenH) {
      strokeWeight(25);
      stroke(0, 255, 0, fade); //green hour
    }

    vertex(x, y);
    /*
    textSize(10);
     fill(255);
     text((a/6)+15, x+10, y+10);
     */
  }
  endShape();


  fill(0);
  noStroke();
  ellipse(width/2, height/2, 470, 470);
}


void update(int x, int y) {
  if (overCircle(cx, cy, int(clockDiameter)) ) {
    circleOver = true;
  } else {
    circleOver = false;
  }
}


boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {  
    return true;
  } else {
    return false;
  }
}



//if mouse come close to line
boolean pointInsideLine(PVector thePoint, 
  PVector theLineEndPoint1, 
  PVector theLineEndPoint2, 
  int theTolerance) {

  PVector dir = new PVector(theLineEndPoint2.x, 
    theLineEndPoint2.y, 
    theLineEndPoint2.z);
  dir.sub(theLineEndPoint1);
  PVector diff = new PVector(thePoint.x, thePoint.y, 0);
  diff.sub(theLineEndPoint1);

  // inside distance determines the weighting
  // between linePoint1 and linePoint2
  float insideDistance = diff.dot(dir) / dir.dot(dir);

  if (insideDistance>0 && insideDistance<1) {
    // thePoint is inside/close to
    // the line if insideDistance>0 or <1
    // println( ((insideDistance<0.5) ?
    //       "closer to p1":"closer to p2" ) +
    //     "\t p1:"+nf((1-insideDistance),1,2)+
    //   " / p2:"+nf(insideDistance,1,2) );

    PVector closest = new PVector(theLineEndPoint1.x, 
      theLineEndPoint1.y, 
      theLineEndPoint1.z);
    dir.mult(insideDistance);
    closest.add(dir);
    PVector d = new PVector(thePoint.x, thePoint.y, 0);
    d.sub(closest);
    // println((insideDistance>0.5) ? "b":"a");
    float distsqr = d.dot(d);

    // check the distance of thePoint to the line against our tolerance.
    return (distsqr < pow(theTolerance, 2));
  }
  return false;
}