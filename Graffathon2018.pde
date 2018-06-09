// Trefoil, by Andres Colubri
// A parametric surface is textured procedurally
// by drawing on an offscreen PGraphics surface.

import moonlander.library.*;
import ddf.minim.*;

ArrayList<PShape> buildings;
//PShader windowShader;

float speed = 0.5;

Moonlander moonlander;

void setup() {
  size(1024, 768, P3D);
  frameRate(60);

  textureMode(IMAGE);
  ((PGraphicsOpenGL)g).textureSampling(2);
  
  noiseSeed(123561245);
  
  strokeWeight(2);
  stroke(0);
  //windowShader = loadShader("texfrag.glsl", "texvert.glsl");
  smooth(8);

  buildings = createCity(10, 10, false);
  //addTexture(buildings);
  
  //moonlander = Moonlander.initWithSoundtrack(this, "rebirth.mp3", 96, 4);
  //moonlander = new Moonlander(this, new TimeController(4));
  //moonlander.start();
}

float treshold = 0.9;
int camx = 0, camy = 0;

void draw() {
  //moonlander.update();
  background(0);
  
  //double bg_red = moonlander.getValue("background_red");
  //int bg_green = moonlander.getIntValue("background_green");
  
  camx = (int)(frameCount * speed);
  camy = -40;
  
  if(frameCount % 5 == 1){
    updateTextures(buildings, frameCount > 1000);
    if(treshold > 0.5)
      treshold -= 0.003;
  }
    //buildings = createCity(camx/meshScale, camy/meshScale, 10, 10);
    //buildings = createCity(0, 0, 10, 10);
  
 

  // Set perspective and cam position
  // cam position, scene center position, up vector
  camera(camx, camy, 5, 180, 40, 30, 0, 0, -1);
  // Fov, aspect ratio, near, far
  perspective(PI/3, width/height, 1, 2000);
  
  //translate(-frameCount, 0, 0);
  //rotateZ(-frameCount * PI / 500);
  
  lights();
  ambientLight(150, 150, 150);
  specular(150);
  drawLight(180, 80, 10);
  
  stroke(max(0, min(frameCount/2 - 100, 200)));
  pushMatrix();
  //shader(windowShader);
  for(PShape b: buildings)
    shape(b);
  popMatrix();
}
