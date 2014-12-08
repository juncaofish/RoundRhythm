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

import ddf.minim.*;

class Element {

  int centerX, centerY;
  float radius = 15;
  boolean readyToPlay;
  color c;
  
  // AudioSnippet associated to this element
  AudioSnippet sound;
  
  Element(int x, int y, String filename){
    
    centerX = x; 
    centerY = y;
    
    c = color(255,0,0);
    
    readyToPlay = true;
    
    sound = minim.loadSnippet(filename);
  }
  
  void playSound(){
    if(readyToPlay){
     // rewind to the beginning
     sound.rewind();
     // play the sound associated to this element
     sound.play();
     // readyToPlay will be set to 'true' again after one whole loop
     readyToPlay = false;
    }
  }
  
  void display(){
    strokeWeight(3);
    fill(c);
    ellipse(centerX, centerY, radius, radius);
    noFill();
  }
  

  boolean getReadyToPlay(){
    return readyToPlay;
  }
  
  void setColor(color cx){
    c = cx;
  }
  
  int getCenterX() {
    return centerX;
  }
  
  int getCenterY(){
    return centerY;
  }
    
  void setReadyToPlay(boolean value){
    readyToPlay = value;
  }
}
