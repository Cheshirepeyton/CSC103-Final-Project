// Bee class///
class Bee {
  float x, y, dx, dy, size = 50;

  Bee(float minS, float maxS) {
    int side = int(random(4));
    if (side == 0) {
      x = random(width); y = 0;
   } else if (side == 1) {
      x = width; y = random(height);
  } else if (side == 2) {
      x = random(width); y = height;
    } else {
      x = 0; y = random(height);
    }
   dx = random(minS, maxS);
    if (random(1) < 0.5) dx *= -1;
    dy = random(minS, maxS);
  if (random(1) < 0.5) dy *= -1;
  }

  void update() {
   x += dx; y += dy;
    if (x < 0 || x > width) dx *= -1;
    if (y < 0 || y > height) dy *= -1;
  }

  void display() {
    if(beeImg !=null){
      image(beeImg,x-size/2,y-size/2,size,size);
    } else{
      
    fill(255, 200, 0);
  ellipse(x, y, size, size);
  }
}
}
