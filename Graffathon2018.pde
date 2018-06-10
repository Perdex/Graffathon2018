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
  size(1920, 1080, P3D);
  frameRate(58);
  
  fftInit();
  
  PImage part = createImage(5, 5, RGB); 
  part.loadPixels();
  for(int i = 0; i < part.pixels.length; i++)
    part.pixels[i] = color(128);

  part.updatePixels();

  ps = new ParticleSystem(100, new PVector(0,0,0), part);

  textureMode(IMAGE);
  ((PGraphicsOpenGL)g).textureSampling(2);
  
  noiseSeed(123561245);
  
  strokeWeight(1);
  stroke(100);
  //windowShader = loadShader("texfrag.glsl", "texvert.glsl");
  smooth(8);

  buildings = createCity(10, 10);
  //addTexture(buildings);
  
  moonlander = Moonlander.initWithSoundtrack(this, "UNITY - Eternal Youth.mp3", 145, 4);
  //moonlander = new Moonlander(this, new TimeController(4));
  moonlander.start();
}

float camx = 0, camy = 0, camz = 0;
float treshold;

void draw() {
  moonlander.update();
  
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
  
  boolean makeSun = moonlander.getIntValue("makeSun") == 1;
  
  float windowBrightness = (float)moonlander.getValue("windowBrightness");
  
  float bg = (float)moonlander.getValue("background");
  float buildingColor = bg;
  
  background(lerp(0, 79, bg), lerp(0, 108, bg), lerp(0, 155, bg));
  
  ps.setOrigin(new PVector(lightx, lighty, lightz));
  for(int i = 0; i < moonlander.getIntValue("particles"); i++){
    ps.addParticle();
  }
  ps.run();
  
  //180, 40, 30
  if((FFT > 0 && frameCount % 2 == 0) || frameCount % 6 == 1)
    updateTextures(buildings, FFT, moonlander.getCurrentTime(), roadCol, windowBrightness, buildingColor);

  // Set perspective and cam position
  // cam position, scene center position, up vector
  camera(camx, camy, camz, lightx, lighty, lightz, 0, 0, -1);
  // Fov, aspect ratio, near, far
  perspective(PI/3, width/height, 1, 8000);
  
  //translate(-frameCount, 0, 0);
  //rotateZ(-frameCount * PI / 500);

  lights();
  ambientLight(150, 150, 150);
  specular(150);
  drawLight(lightx + 2 * noise(frameCount * 0.1 + 332),
            lighty + 2 * noise(frameCount * 0.1 + 676),
            lightz + 2 * noise(frameCount * 0.1 - 257), lightSize);
  if(makeSun)
    drawLight(-2000, 2000, 1000, 40);
  
  pushMatrix();
  //shader(windowShader);
  for(PShape b: buildings)
    shape(b);
  popMatrix();
}
