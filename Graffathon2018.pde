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
      if(i % 3 == 0 && j % 3 == 0){
        float noise = noise(i, j);
        if(noise < 0.5)
          img.pixels[i + j * imgScale] = color(255, 235, 0); 
          //noise = 0;
        //img.pixels[i + j * imgScale] = color(255, 235, 0, noise); 
      }else{
        float a = map(j, 0, half, 20, 10);
        img.pixels[i + j * imgScale] = color(0, a * 0.66, a); 
      }
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

  // Set default perspective
  // Set cam position
  camera(0, -30, 20, 1500, 750, 0, 0, 0, -1);
  //perspective();
  translate(-frameCount*2, 0, 0);
  //rotateZ(-frameCount * PI / 500);
  
  lights();
  ambientLight(150, 150, 150);
  
  pushMatrix();
  shape(trefoil);
  popMatrix();
}
