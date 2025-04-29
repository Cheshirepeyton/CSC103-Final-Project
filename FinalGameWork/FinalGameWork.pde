//Peyton's Final Game!! CSC 103/////

//main sketch///
PImage bgIntro;
PImage bgLevel1;
PImage bgLevel2;
PImage gameOver;
PImage winScreen;
PImage basketImg; 
PImage beeImg;
PImage[] targetFlowerImages=new PImage[3];
PImage[] flowerImages = new PImage[9];
import processing.sound.*; 
SoundFile music; 

void preload() {
  flowerImages[0] = loadImage("flower1.png");
  flowerImages[1] = loadImage("flower2.png");
  flowerImages[2] = loadImage("flower3.png");
  flowerImages[3] = loadImage("flower4.png");
  flowerImages[4] = loadImage("flower5.png");
  flowerImages[5] = loadImage("flower6.png");
  flowerImages[6] = loadImage("flower7.png");
  flowerImages[7] = loadImage("flower8.png");
  flowerImages[8] = loadImage("flower9.png");
}

int level = 1;
int score = 0;
int hits = 0;
boolean playing = true;
boolean intro = false;
boolean hitThisFrame = false;

Player player;
Flower[] flowers;
color[] targetColors = new color[3];
boolean[] colorCollected;
Bee[] bees;

color[] palette = {
  #F57CA6, #9D16C4, #FFD166, #118AB2, #EF476F, #06D6A0, #A3D9A5,#FF9F1C, #2EC4B6 
};

void setup() {
  size(600, 600);
  rectMode(CORNER);
  textSize(16);

  gameOver = loadImage("gameOver.jpeg");
  winScreen = loadImage("win.jpeg");
  bgIntro = loadImage("introBackground.jpeg");
  bgLevel1 = loadImage("level1Background.png");
  bgLevel2 = loadImage("level2Background.png");
  basketImg=loadImage("basket.png"); 
  beeImg=loadImage("bee.png");
  
  music=new SoundFile(this, "background.mp3");
  music.loop(); 

  for (int i = 0; i < 9; i++) {
    flowerImages[i] = loadImage("flower" + (i+1) + ".png");
  }

  initGame();
}

void initGame() {
  int totalFlowers;
  int beeCount;
  float beeMinSpd;
  float beeMaxSpd;

  if (level == 1) {
    totalFlowers = 14;
    beeCount = 3;
    beeMinSpd = 2;
    beeMaxSpd = 3;
  } else {
    totalFlowers = 24;
    beeCount = 6;
    beeMinSpd = 3;
    beeMaxSpd = 5;
  }

  score = 0;
  player = new Player();
  colorCollected = new boolean[]{ false, false, false };

  flowers = new Flower[totalFlowers];
  int placed = 0;
  while (placed < totalFlowers) {
 float x = random(20, width - 45);
    float y = random(height/2, height - 45); 
 boolean overlaps = false;
    for (int i = 0; i < placed; i++)
      if (dist(x, y, flowers[i].x, flowers[i].y) < 50) overlaps = true;
    if (!overlaps) {
   int imgIndex = int(random(flowerImages.length));
      flowers[placed++] = new Flower(x, y, palette[imgIndex], flowerImages[imgIndex]);
    }
  }
  int picked = 0;
while (picked < 3) {
  int randIndex = int(random(flowers.length));
  Flower randomFlower = flowers[randIndex];
 color c = randomFlower.col;
  boolean exists = false;
  for (int i = 0; i < picked; i++) {
    if (targetColors[i] == c) exists = true;
  }
  if (!exists) {
    targetColors[picked] = c;
    targetFlowerImages[picked] = randomFlower.img;
    picked++;
  }
}


 
  bees = new Bee[beeCount];
  for (int i = 0; i < beeCount; i++) bees[i] = new Bee(beeMinSpd, beeMaxSpd);

  intro = true;
  playing = false;
}

void draw() {
  if (intro) {
    showIntro();
    return;
  }
  if (playing) {
    background(#206C3A);
    updateGame();
  } else {
    showEnd();
  }
}

void showIntro() {
  image(bgIntro, 0, 0, width, height);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(32);
  text("Level " + level, width/2, height/2);
  textSize(16);
  text("Click to begin", width/2, height/2 + 40);
}

void showEnd() {
  background(0);
  if (level == 2 && score == 3) {
    image(winScreen, 0, 0, width, height);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(28);
    text("YOU WIN! (click to restart)", width/2, height - 50);
  } else {
    image(gameOver, 0, 0, width, height);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(28);
    text("GAME OVER (click to restart)", width/2, height - 50);
  }
}

void updateGame() {
  hitThisFrame = false;

  if (level == 1) {
    image(bgLevel1, 0, 0, width, height);
  } else {
    image(bgLevel2, 0, 0, width, height);
  }

  if (keyPressed) {
    if (keyCode == UP) player.y -= 3;
    if (keyCode == DOWN) player.y += 3;
    if (keyCode == LEFT) player.x -= 3;
    if (keyCode == RIGHT) player.x += 3;
  }
  player.keepInBounds();

  for (Bee b : bees) {
    b.update();
    b.display();
    if (player.hitBee(b) && !hitThisFrame) {
      hits++;
      hitThisFrame = true;
    }
  }

  for (int i = 0; i < flowers.length; i++) {
    Flower f = flowers[i];
    if (f == null) continue;
    f.display();
    if (player.collects(f)) {
      for (int t = 0; t < 3; t++) {
        if (!colorCollected[t] && f.col == targetColors[t]) {
          score++;
          colorCollected[t] = true;
        }
      }
      flowers[i] = null;
    }
  }

  if (score == 3) {
    if (level == 1) {
      level = 2;
      initGame();
    } else {
      playing = false;
    }
  }

  if (hits >= 1) playing = false;

  player.display();
  drawHUD();
  drawTargetBox();
}

void drawHUD() {
  int boxW = 230, boxH = 54, boxX = 5, boxY = height - boxH - 5;
  fill(0, 120);
  rect(boxX, boxY, boxW, boxH, 4);
  fill(255);
  textAlign(LEFT, TOP);
  text("Level " + level + "  Score " + score + "/3", boxX + 8, boxY + 8);
  text("Stings: " + hits + " /1", boxX + 8, boxY + 30);
}

void drawTargetBox() {
  int flowerSize = 80; 
  int spacing = 10;    
  int bx = width - (flowerSize * 3 + spacing * 4);
  int by = 10;
  int boxW = flowerSize * 3 + spacing * 4;
  int boxH = flowerSize + spacing * 2;

  fill(0, 120);
  rect(bx, by, boxW, boxH, 4); 

  for (int i = 0; i < 3; i++) {
    float flowerX = bx + spacing + i * (flowerSize + spacing);
    float flowerY = by + spacing;
    image(targetFlowerImages[i], flowerX, flowerY, flowerSize, flowerSize);

    if (colorCollected[i]) {
      stroke(255, 200);
      strokeWeight(4);
      line(flowerX, flowerY, flowerX + flowerSize, flowerY + flowerSize);
      line(flowerX + flowerSize, flowerY, flowerX, flowerY + flowerSize);
      noStroke();
    }
  }
}

void mousePressed() {
  if (intro) {
    intro = false;
    playing = true;
  } else if (!playing) {
    level = 1;
    hits = 0;
    intro = false;
    playing = true;
    initGame();
  }
}
  
