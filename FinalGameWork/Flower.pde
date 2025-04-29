// Flower class
class Flower {
  float x, y;
  float size = 100; 
  color col;
  PImage img;
//flower class//
  Flower(float x, float y, color c, PImage img) {
  this.x = x;
  this.y = y;
  this.col = c;
    this.img = img;
  }

  void display() {
    if (img != null) {
      image(img, x, y, size, size);
    } else {
     fill(col);
      rect(x, y, size, size);
    }
  }
}
