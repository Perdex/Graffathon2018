// Trefoil, by Andres Colubri
// A parametric surface is textured procedurally
// by drawing on an offscreen PGraphics surface.

//import moonlander.library.*;

PImage img;
PShape trefoil;

//Moonlander moonlander;

void setup() {
  size(1024, 768, P3D);

  textureMode(IMAGE);
  noStroke();

  int imgScale = 128;
  int half = 64;
  img = createImage(imgScale, imgScale, ARGB);
  for(int i = 0; i < half; i++) {
    for(int j = 0; j < half; j++) {
      
      // walls
      float a = map(j, 0, half, 30, 5);
      img.pixels[i + j * imgScale] = color(0, a * 0.66, a); 
      
      // windows
      if(i % 3 == 1 && j % 3 == 1){
        float noise = noise(i, j);
        if(noise < 0.5)
          noise = 0;
        img.pixels[i + j * imgScale] = color(lerp(0, 255, noise), lerp(a * 0.66, 235, noise), lerp(a, 0, noise)); 
      }
      
      // roads and rooftops
      img.pixels[i + half + (j + half) * imgScale] = color(5, 5, 5, 255); 
    }
  }
  
  //moonlander.start();
  // Saving trefoil surface into a PShape3D object
  trefoil = createCity(30, 15, img);
}

void draw() {
  //moonlander.update();
  background(0);
  
    //double bg_red = moonlander.getValue("background_red");
    //int bg_green = moonlander.getIntValue("background_green");

  // Set perspective and cam position
  camera(0, -40, 20, 1500, 750, 0, 0, 0, -1);
  perspective(PI/3, width/height, 1, 2000);
  translate(-frameCount*2, 0, 0);
  //rotateZ(-frameCount * PI / 500);
  
  lights();
  ambientLight(150, 150, 150);
  
  pushMatrix();
  shape(trefoil);
  popMatrix();
}
