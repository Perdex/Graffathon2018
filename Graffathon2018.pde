// Trefoil, by Andres Colubri
// A parametric surface is textured procedurally
// by drawing on an offscreen PGraphics surface.

import moonlander.library.*;
import ddf.minim.*;

PImage img;
PShape trefoil;

Moonlander moonlander;

void setup() {
  size(1024, 768, P3D);
  frameRate(60);

  textureMode(IMAGE);
  //noStroke();

  int imgScale = 128;
  int half = 64;
  img = createImage(imgScale, imgScale, ARGB);
  for(int i = 0; i < half; i++) {
    for(int j = 0; j < half; j++) {
      
      // walls
      float r = map(j, 0, half, 60, 0);
      float g = map(j, 0, half, 50, 20);
      float b = map(j, 0, half, 30, 30);
      img.pixels[i + j * imgScale] = color(r, g, b); 
      
      // windows
      if(i % 3 == 1 && j % 3 == 1){
        float noise = noise(i, j);
        if(noise < 0.5)
          noise = 0;
        img.pixels[i + j * imgScale] = color(lerp(r, 255, noise), lerp(g, 235, noise), lerp(b, 0, noise)); 
      }
      
      // roads and rooftops
      img.pixels[i + half + (j + half) * imgScale] = color(5, 5, 5, 255); 
    }
  }
  ((PGraphicsOpenGL)g).textureSampling(2);
  // Saving trefoil surface into a PShape3D object
  trefoil = createCity(30, 15, img);
  //moonlander = Moonlander.initWithSoundtrack(this, "rebirth.mp3", 96, 4);
  //moonlander = new Moonlander(this, new TimeController(4));
  //moonlander.start();
}

void draw() {
  //moonlander.update();
  background(0);
  
  //double bg_red = moonlander.getValue("background_red");
  //int bg_green = moonlander.getIntValue("background_green");

  // Set perspective and cam position
  camera(0, -40, 20, 1500, 750, 0, 0, 0, -1);
  perspective(PI/3, width/height, 1, 2000);
  translate(-frameCount, 0, 0);
  //rotateZ(-frameCount * PI / 500);
  
  lights();
  ambientLight(150, 150, 150);
  
  pushMatrix();
  shape(trefoil);
  popMatrix();
}
