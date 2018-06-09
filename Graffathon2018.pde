// Trefoil, by Andres Colubri
// A parametric surface is textured procedurally
// by drawing on an offscreen PGraphics surface.

import moonlander.library.*;
import ddf.minim.*;

ArrayList<PShape> buildings;
ParticleSystem ps;
//PShader lightShader;

float speed = 0.5;

Moonlander moonlander;

void setup() {
  size(1024, 768, P3D);
  frameRate(60);
  
  fftInit();
  
  PImage part = createImage(5, 5, RGB); 
  part.loadPixels();
  for(int i = 0; i < part.pixels.length; i++){
    part.pixels[i] = color(128);
  }
  part.updatePixels();

  ps = new ParticleSystem(100, new PVector(0,0,0), part);

  textureMode(IMAGE);
  ((PGraphicsOpenGL)g).textureSampling(2);
  
  noiseSeed(123561245);
  
  strokeWeight(1);
  stroke(100);
  //windowShader = loadShader("texfrag.glsl", "texvert.glsl");
  smooth(8);

  buildings = createCity(10, 10, false);
  //addTexture(buildings);
  
  moonlander = Moonlander.initWithSoundtrack(this, "UNITY - Eternal Youth.mp3", 145, 4);
  //moonlander = new Moonlander(this, new TimeController(4));
  moonlander.start();
}

float camx = 0, camy = 0, camz = 0;
float treshold;

void draw() {
  moonlander.update();
  background(0);
  
  treshold = (float)moonlander.getValue("treshold");
  
  int roadCol = moonlander.getIntValue("roadCol");
  int FFT = moonlander.getIntValue("doFFT");
  
  camx = (float)moonlander.getValue("camX");
  camy = (float)moonlander.getValue("camY");
  camz = (float)moonlander.getValue("camZ");
  
  float lightx = (float)moonlander.getValue("lightX");
  float lighty = (float)moonlander.getValue("lightY");
  float lightz = (float)moonlander.getValue("lightZ");
  float lightSize = (float)moonlander.getValue("lightSize");
  
  float windowBrightness = (float)moonlander.getValue("windowBrightness");
  
  ps.setOrigin(new PVector(lightx, lighty, lightz));
  ps.addParticle();
  ps.run();
  
  //180, 40, 30
  if(frameCount % 5 == 1)
    updateTextures(buildings, FFT == 1, roadCol, windowBrightness);

  // Set perspective and cam position
  // cam position, scene center position, up vector
  camera(camx, camy, camz, lightx, lighty, lightz, 0, 0, -1);
  // Fov, aspect ratio, near, far
  perspective(PI/3, width/height, 1, 2000);
  
  //translate(-frameCount, 0, 0);
  //rotateZ(-frameCount * PI / 500);

  lights();
  ambientLight(150, 150, 150);
  specular(150);
  drawLight(lightx, lighty, lightz, lightSize);
  
  pushMatrix();
  //shader(windowShader);
  for(PShape b: buildings)
    shape(b);
  popMatrix();
}
