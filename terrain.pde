import processing.sound.*;

int col, row, scale;
float[][] displacement;

float moveY, moveX;
boolean up, down, right, left;

float y, startHeight, gravity;
boolean jump;

float noiseoff, yoff;
float prisX, prisZ, prisY;
float prisVel, x;
Prism prism;

float metSize;
float metTargX, metTargZ, metY;
ArrayList<Meteor> meteors = new ArrayList<Meteor>();
Meteor meteor1;
Meteor meteor2;

int score;
boolean playing;

SoundFile jumpSound, metCrash, prismCollect, die;
PImage background;

void setup() {
  size(1280, 960, P3D);
  frameRate(24);

  playing = true;

  scale = 16;
  col = width*2/scale;
  row = height/scale;
  displacement = new float[col][row];

  moveY = 0;
  moveX = 0;
  gravity = 1.1;

  up = false;
  down = false;
  left = false;
  right = false;

  x = 0;
  y = 2*height/3;
  yoff = 128;
  
  prismCollect = new SoundFile(this, "prism.wav");
  metCrash = new SoundFile(this, "hihat.wav");
  jumpSound = new SoundFile(this, "kickDrum.wav");
  die = new SoundFile(this, "death.wav");
  
  background = loadImage("sky.png");

  noiseoff = 0;
  prisX = random(-400, 400);
  prisZ = random(-400, 400);
  prisVel = 12;
  prism = new Prism(prisX, prisZ, prisY);

  metSize = random(24, 48);
  metTargX = random(-400, 400);
  metTargZ = random(-400, 400);
  metY = height/10;
  meteor1 = new Meteor(metTargX, metY, metTargZ, metSize);
  
  metSize = random(24, 48);
  metTargX = random(-400, 400);
  metTargZ = random(-400, 400);
  metY = height/12;
  meteor2 = new Meteor(metTargX, metY, metTargZ, metSize);
  
  meteors.add(meteor1);
  meteors.add(meteor2);
}

void draw() {
  background(#B7E4E8);
  image(background, 0, -height/5);
  noStroke();

  // state check
  if (!playing) {
    camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(96);
    text("GAME OVER\n", width/2, 0.2*height);
    fill(0);
    textSize(72);
    text("You collected %s artifacts".formatted(score), width/2, height*0.3);

    pushMatrix();
    translate(0, 3*height/5);
    rotateX(PI/2);

    terrainGen();
    popMatrix();

    up = true;
  } else {
    //fill(0);
    //textAlign(CENTER, TOP);
    //textSize(48);
    //text("Alien Artifacts: " + str(score), width, height*0.25);

    //lights
    directionalLight(240, 208, 176, -1, 1, -1);
    directionalLight(176, 208, 240, 1, 1, 1);

    //camera
    perspective(PI/3, float(width)/float(height), ((height/2.0) / tan(PI/6.0))/10, ((height/2.0) / tan(PI/6.0))*20);
    camera(width, 0, (height/1.5) / tan(PI/6), width, height, 0, 0, 1, 0);

    //action
    grav();

    pushMatrix();
    translate(0, 3*height/5);
    rotateX(PI/2);

    terrainGen();

    pushMatrix();
    translate(width, 2*height/3, y);

    fill(115, 155, 195);
    sphere(32);
    popMatrix();
    popMatrix();

    // actors
    prism.prismLog();
    prism.drawPrism();

    //meteor1.my += 22;
    //meteor1.metLog();
    //meteor2.my += 20;
    //meteor2.metLog();

    if(int(score/8)+2 > meteors.size()) meteors.add(new Meteor(random(-400, 400), height/10, random(-400, 400), random(24, 48)));
    
    for(int i = 0; i < meteors.size(); i++){
      meteors.get(i).my += random(18, 24);
      meteors.get(i).metLog();
    }
  }
}

void keyPressed() {
  if (playing) {
    if (key == 'w' || key == UP) {
      up = true;
    }
    if (key == 's'|| key == DOWN) {
      down = true;
    }
    if (key == 'a' || key == LEFT) {
      left = true;
    }
    if (key == 'd' || key == RIGHT) {
      right = true;
    }
    if (key == ' ' && !jump) {
      jumpSound.play();
      jump = true;
      startHeight = y;
      gravity = 5;
    }
  }
}

void keyReleased() {
  if (playing) {
    if (key == 'w' || key == UP) {
      up = false;
    }
    if (key == 's' || key == DOWN) {
      down = false;
    }
    if (key == 'a' || key == LEFT) {
      left = false;
    }
    if (key == 'd' || key == RIGHT) {
      right = false;
    }
  }
}

void terrainGen() {
  if (up) moveY -= 0.05;
  if (down) moveY += 0.05;
  if (left) moveX -= 0.05;
  if (right) moveX += 0.05;

  float offY = moveY;
  for (int y = 0; y < row; y++) {
    float offX = moveX;
    for (int x = 0; x < col; x++) {
      displacement[x][y] = map(noise(offX, offY), 0, 1, -128, 128);
      offX += 0.05;
    }
    offY += 0.05;
  }

  for (int y = 0; y < row-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < col; x++) {
      float r = map(displacement[x][y], -64, 128, 90, 184);
      float g = map(displacement[x][y], -64, 128, 61, 201);
      float b = map(displacement[x][y], -64, 128, 13, 77);
      fill(r, g, b);
      vertex(x*scale, y*scale, displacement[x][y]);
      float m = map(displacement[x][y+1], -64, 128, 90, 184);
      float k = map(displacement[x][y+1], -64, 128, 61, 201);
      float c = map(displacement[x][y+1], -64, 128, 13, 77);
      fill(m, k, c);
      vertex(x*scale, (y+1)*scale, displacement[x][y+1]);
    }
    endShape();
  }
}

void grav() {
  if (y-32 <= displacement[80][40]) {
    //y += 4;
    y = displacement[80][40]+32;
    gravity = 5;
  } else {
    gravity *= 1.1 ;
    y -= gravity;
  }

  if (y <= startHeight+128 && y <= 2*height/5) {
    if (jump) y += 24;
  } else {
    jump = false;
  }
}

boolean isBetween(float check, float upper, float lower) {
  if (check <= upper && check >= lower) return true;
  else return false;
}

//&& isBetween(metY, (3*height/5)-yoff+metSize, (3*height/5)-yoff-metSize)
