class Meteor {
  float mx, my, mz;
  float size, metVel;

  Meteor(float x, float y, float z, float s) {
    mx = x;
    my = y;
    mz = z;
    size = s;
    metVel = 16;
  }

  void metLog() {
    if (up) {
      mz += metVel;
    }
    if (down)
    {
      mz -= metVel;
    }
    if (left) {
      mx += metVel;
    }
    if (right) {
      mx -= metVel;
    }

    if (isBetween(mx, size+16, -size-16)
      && isBetween(mz, 250+size+16, 250-size-16)
      && isBetween(my+256+size, height-y+32-size, height-y-32-size)) {
      die.play();
      playing = false;
    }

    if (meteorHit()) {
      metCrash.play();
      mx = random(-400, 400);
      mz = random(-400, 400);
      my = height/10;
      size = random(24, 48);
      drawMeteor(0); // New meteor
    } else {
      // Take target and current position, calculate angle then calculate movement to add depth
      drawMeteor(0); // Move same meteor
    }
  }

  void drawMeteor(float angle) {
    int i = abs(int(80+((mx/(width*2))*160)))%160;
    int j = abs(int((30+(mz/height)*60)))%60;
    yoff = displacement[i][j];

    pushMatrix();              // Store the current transformation settings.
    translate(width+mx, my, 400+mz);// Shift it
    scale(1, 1.5, 1);            // Stretch it on along the y-axis
    rotateX(radians(angle));   // Rotate about its centre
    fill(75, 25, 25);         // Colour the meteor black-red
    sphere(size);                // Draw the first sphere.
    popMatrix();

    pushMatrix();              // Store the current transformation settings.
    translate(width+mx, (3*height/5)-yoff, 400+mz);// Shift itt
    scale(1.5, 0.75, 1.5);            // Stretch it on along the x/z-axis
    fill(125, 55, 55);         // Colour the spot red
    sphere(size);                // Draw the landing sphere.
    popMatrix();
  }

  boolean meteorHit() {
    if (my >= (3*height/5)-yoff) {
      return true;
    } else {
      return false;
    }
  }
}
