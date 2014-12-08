/*
ROUND RHYTHM
Developed by: Andrea Palazzi
Inspired by TED-Ed Talk: A different way to visualize rhythm - John Varney

    This file is part of ROUND RHYTHM.

    ROUND RHYTHM is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    ROUND RHYTHM is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with ROUND RHYTHM.  If not, see <http://www.gnu.org/licenses/>.
*/


//Audio context
Minim minim;

// Circle coordinates
int centerX;
int centerY;
float radius = 150;

// rotation angle and speed
float a = 0.0;
float rot_speed = 0.01;

// ArrayList that contains the elements
ArrayList<Element> elementList;

// ArrayList that contains paths to audio files
int soundFilesIndex;
ArrayList<String> soundFiles;

// Array that stores different colors (for different sounds)
color[] colorList;

// Two different modes: 1 for inserting elements, -1 for deleting
int mode;
public final static int INSERT = 1;
public final static int DELETE = -1;

// ArrayList that contains the set of point allowed to construct an Element with
// These point correspond to important angles: 0, PI/4, PI/2...
ArrayList<Point> allowedPoints;

void setup(){
  
  // Audio context initialization
  minim = new Minim(this);

  background(127);
  size(800, 800);
  rectMode(CENTER);
  
  centerX = width/2;
  centerY = height/2;
  
  // Starting mode is INSERT (insert new elements by clicking)
  mode = INSERT;  
  
  soundFilesIndex = 0;
  soundFiles = new ArrayList<String>();
  soundFiles.add("sounds/drum1.wav");
  soundFiles.add("sounds/drum6.wav");
  soundFiles.add("sounds/drum3.wav");
  
  elementList = new ArrayList<Element>();
  
  // Warning: the number of colors is hardcoded (depends on the number of sound files)  
  colorList = new color[3];
  colorList[0] = color(255,0,0);
  colorList[1] = color(0,255,0);
  colorList[2] = color(0,0,255);
  
  // Fill the ArrayList of allowed points
  allowedPoints = new ArrayList<Point>();
  for(int degree = 0; degree < 360; degree += 30)
    allowedPoints.add(new Point(centerX + radius*cos(radians(degree)), centerY + radius*sin(radians(degree)))); // 0
  for(int degree = 0; degree < 360; degree += 45)
    allowedPoints.add(new Point(centerX + radius*cos(radians(degree)), centerY + radius*sin(radians(degree)))); // 0
}


void draw(){
  
  smooth(2);
  background(250);
  
  textSize(32);  
  // Display the current sound file used to fill construct the new elements
  fill(0);
  text("Current mode: ",50,50);
  text("Current sound: "+soundFiles.get(soundFilesIndex),50,100);
  // Show the current mode (insert or delete)
  if(mode == INSERT){
    fill(0,255,0);
    text("INSERT",285,50);
  } else {
    fill(255,0,0);
    text("DELETE",285,50);
  }
  
  // Title
  fill(0);
  textSize(55);
  text("Round Rhythm!", 50, 660);
  textSize(22);
  text("Developed by: Andrea Palazzi", 50, 700);
  text("Inspired by TED-Ed Talk:\n\"A different way to visualize rhythm - John Varney\"", 50, 740);
    
  // Update angle
  a += rot_speed;
  if(a > TWO_PI) { 
    a = 0.0;
    for(int i=0; i<elementList.size(); i++)
      elementList.get(i).setReadyToPlay(true);
  }
  
  strokeWeight(6);
  
  // Disegna primo anello
  fill(255,153,0);
  ellipse(centerX, centerY, 2*radius, 2*radius);
  
  // Disegna il centro
  ellipse(centerX, centerY, 9, 9);
  
  // Show allowed points
  fill(255);
  for(int i=0; i<allowedPoints.size(); ++i)
    ellipse(allowedPoints.get(i).getX(), allowedPoints.get(i).getY(), 9, 9);
  
  // Rotate the rectangle
  pushMatrix();
  translate(centerX,centerY);
  rotate(a);
  rect(0, 65, 5, radius);
  popMatrix();
  
  //e.display();
  for(int i=0; i<elementList.size(); i++)
    elementList.get(i).display();
  
  pushMatrix();
  translate(centerX,centerY);
  ellipse(radius*cos(a+HALF_PI), radius*sin(a+HALF_PI), 20, 20);
  popMatrix();
  
  // Check collision with every element
  int tmp_x = int(centerX+radius*cos(a+HALF_PI));
  int tmp_y = int(centerY+radius*sin(a+HALF_PI));
  //println(tmp_x + "  " + tmp_y + "  " + a);
  for(int i=0; i<elementList.size(); i++){
   Element e = elementList.get(i); 
    if(abs(tmp_x-e.getCenterX())<20 && abs(tmp_y-e.getCenterY())<20){
      e.playSound();
    }
  }
  
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      rot_speed += 0.005;
    } else if (keyCode == DOWN) {
      rot_speed -= 0.005;
      if(rot_speed<=0)
        rot_speed = 0.01;    
    }
  }
  // If 'M' is pressed, change mode between insertion and deletion
  else if (key == 'm' || key == 'M') 
    mode *= -1;
  else if (key == 'p' || key == 'P') {
    soundFilesIndex++;
    if(soundFilesIndex == soundFiles.size())
      soundFilesIndex=0;      
  }
}


void mouseClicked(){
  
  Point p = circleLineIntersect(centerX, centerY, mouseX, mouseY, centerX, centerY, radius);
  
  int minIndex = -1;
  float minDist = 9999;
  
  if(mode==INSERT){
    // Choose the nearest allowed point to construct the element
    for (int i=0; i<allowedPoints.size(); i++){
      float d = dist(mouseX, mouseY, allowedPoints.get(i).getX(), allowedPoints.get(i).getY());
      if(d < minDist){
        minDist = d;
        minIndex = i;
      }
    }
    // Construct the Element in the nearest point allowed
    Element e = new Element(allowedPoints.get(minIndex).getX(), allowedPoints.get(minIndex).getY(), soundFiles.get(soundFilesIndex));
    e.setColor(colorList[soundFilesIndex]);
    elementList.add(e);
    
  } else {
    // find and delete the nearest element
    for(int i=0; i<elementList.size(); i++){
      float d = dist(p.getX(), p.getY(), elementList.get(i).getCenterX(), elementList.get(i).getCenterY());
      if (d < minDist) {
        minDist = d;
        minIndex = i;
      }
    }
    if(minIndex >= 0)
      elementList.remove(minIndex);
  }
  
}

Point circleLineIntersect(float x1, float y1, float x2, float y2, float cx, float cy, float cr ) {
  float dx = x2 - x1;
  float dy = y2 - y1;
  float a = dx * dx + dy * dy;
  float b = 2 * (dx * (x1 - cx) + dy * (y1 - cy));
  float c = cx * cx + cy * cy;
  c += x1 * x1 + y1 * y1;
  c -= 2 * (cx * x1 + cy * y1);
  c -= cr * cr;
  float bb4ac = b * b - 4 * a * c;
 
  //println(bb4ac);
 
  if (bb4ac < 0) {  // Not intersecting
    return (new Point(0,0));
  }
  else {
     
    float mu = (-b + sqrt( b*b - 4*a*c )) / (2*a);
    float ix1 = x1 + mu*(dx);
    float iy1 = y1 + mu*(dy);
    mu = (-b - sqrt(b*b - 4*a*c )) / (2*a);
    float ix2 = x1 + mu*(dx);
    float iy2 = y1 + mu*(dy);
 
    // The intersection points
    //ellipse(ix1, iy1, 10, 10);
    //ellipse(ix2, iy2, 10, 10);
     
    float testX;
    float testY;
    // Figure out which point is closer to the circle
    if (dist(x1, y1, cx, cy) < dist(x2, y2, cx, cy)) {
      //ellipse(ix1, iy1, 10, 10);
      testX = x2;
      testY = y2;
      return(new Point(ix1,iy1));
    } else {
      //ellipse(ix2, iy2, 10, 10);
      testX = x1;
      testY = y1;
      return(new Point(ix2,iy2));
    }
     
//    if (dist(testX, testY, ix1, iy1) < dist(x1, y1, x2, y2) || dist(testX, testY, ix2, iy2) < dist(x1, y1, x2, y2)) {
//      return true;
//    } else {
//      return false;
//    }
  }
}
