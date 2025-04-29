//player class////
class Player {
  float x, y;
  float size = 40;

  Player() {
    x = width/2;
    y = height - 60;
  }

  void display() {
   image(basketImg, x, y, size, size);
  }

  void keepInBounds() {
    x = constrain(x, 0, width - size);
   y = constrain(y, 0, height - size);
  }

  boolean collects(Flower f) {
    return dist(x + size/2, y + size/2, f.x + f.size/2, f.y + f.size/2) < (size + f.size * 0.5) / 2;
  }

  boolean hitBee(Bee b) {
   return dist(x + size/2, y + size/2, b.x, b.y) < (size/2 + b.size*0.2);
  }
}
