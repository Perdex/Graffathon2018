// Trefoil, by Andres Colubri
// A parametric surface is textured procedurally
// by drawing on an offscreen PGraphics surface.

import moonlander.library.*;
import ddf.minim.*;

PShape buildings;
//PShader windowShader;

Moonlander moonlander;

void setup() {
  size(1024, 768, P3D);
  frameRate(60);

  textureMode(IMAGE);
  ((PGraphicsOpenGL)g).textureSampling(2);
  
  noiseSeed(1235612415);
  
  strokeWeight(1);
  stroke(0);
  //windowShader = loadShader("texfrag.glsl", "texvert.glsl");

  buildings = createCity(0, 0, 10, 10);
  //addTexture(buildings);
  
  //moonlander = Moonlander.initWithSoundtrack(this, "rebirth.mp3", 96, 4);
  //moonlander = new Moonlander(this, new TimeController(4));
  //moonlander.start();
  addTexture(buildings, 0, 0, 1);
}

float treshold = 0.78;

void draw() {
  //moonlander.update();
  background(0);
  
  //double bg_red = moonlander.getValue("background_red");
  //int bg_green = moonlander.getIntValue("background_green");
  
  int camx = frameCount;
  int camy = -40;
  
  
  if(frameCount % 5 == 1){
    buildings = createCity(camx, camy, 10, 10);
    if(treshold > 0.5)
      treshold -= 0.001;
  }
    //buildings = createCity(camx/meshScale, camy/meshScale, 10, 10);
    //buildings = createCity(0, 0, 10, 10);
  
 

  // Set perspective and cam position
  // cam position, scene center position, up vector
  camera(camx, camy, 20, 180, 20, 30, 0, 0, -1);
  // Fov, aspect ratio, near, far
  perspective(PI/3, width/height, 1, 2000);
  
  //translate(-frameCount, 0, 0);
  //rotateZ(-frameCount * PI / 500);
  
  lights();
  ambientLight(150, 150, 150);
  specular(150);
  drawLight(80, -20, 10);
  
  stroke((int)(noise(frameCount * 0.01) * min(frameCount*4, 255)));
  pushMatrix();
  //shader(windowShader);
  shape(buildings);
  popMatrix();
}
