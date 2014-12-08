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

class Point {

  int x;
  int y;
  
  Point(){
    x = 0;
    y = 0;
  }
  
  Point (int x, int y){
    this.x = x;
    this.y = y;
  }
  
  Point (float x, float y){
    this.x = int(x);
    this.y = int(y);
  }
  
  int getX(){
    return x;
  }
  
  int getY(){
    return y;
  }
  
  void setX(int x){
    this.x = x;
  }
  
  void setY(int y){
    this.y = y;
  }  
}
