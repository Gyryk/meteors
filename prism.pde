class Prism {
  float px, py, pz;

  Prism(float x, float z, float y) {
    px = x;
    pz = z;
    py = y;
  }

  void prismLog() {
    if (up) pz += prisVel;
    if (down) pz -= prisVel;
    if (left) px += prisVel;
    if (right) px -= prisVel;

    if (prisOver()) {
      prismCollect.play();
      score++;
      px = random(-600, 600);
      pz = random(-600, 600);
    }

    noiseoff += 0.01;
    py = map(noise(noiseoff), 0, 1, height/3, 3*height/5-128);
  }

  void drawPrism() {
    pushMatrix();
    //yoff = displacement[(80+(pX/width*2))%160][40]+32;
    x += PI/180;
    translate(width+px, py, 200+pz);
    scale(0.5, 0.5, 0.5);
    rotate(x);

    fill(100, 100, 255);
    beginShape(TRIANGLES);
    //fill(255, 0, 0);
    vertex(0, 0, 100);
    //fill(0, 0, 255);
    vertex(-100, 100, 0);
    //fill(0, 255, 0);
    vertex(100, 100, 0);

    //fill(255, 0, 0);
    vertex(0, 0, 100);
    //fill(0, 255, 0);
    vertex(100, 100, 0);
    //fill(0, 0, 255);
    vertex(0, -100, 0);

    //fill(255, 0, 0);
    vertex(0, 0, 100);
    //fill(0, 0, 255);
    vertex(0, -100, 0);
    //fill(0, 255, 0);
    vertex(-100, 100, 0);

    //fill(0, 255, 0);
    vertex(-100, 100, 0);
    //fill(255, 0, 0);
    vertex(100, 100, 0);
    //fill(0, 0, 255);
    vertex(0, -100, 0);
    endShape();
    popMatrix();
  }

  boolean prisOver() {
    if (isBetween(px, 50, -50) && isBetween(pz, 450, 390) && isBetween(py, y+256, y)) return true;
    return false;
  }
}
