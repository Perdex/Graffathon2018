
int meshScale = 100;
int textScale = 64;
int maxh = 4;

int yellowR = 235;
int yellowG = 215;
int yellowB = 40;

void updateTextures(ArrayList<PShape> arr, int FFT, double t, int roadColor,
                    float windowBrightness, float buildingColor) {
  if(FFT > 0){
    float[] fft = fftGet((float)t);
    PImage tex[] = new PImage[20];
    for(int i = 0; i < 20; i++)
      tex[i] = FFT == 1 ? makeTextureFFT((int)(fft[i] * 128))
                     : makeTexture(windowBrightness, buildingColor, fft[i]);
                     
    for(int i = 0; i < arr.size() - 1; i++)
      arr.get(i).setTexture(tex[i / 20]);
                     
  }else{
    PImage tex = makeTexture(windowBrightness, buildingColor, 1);
    for(int i = 0; i < arr.size() - 1; i++)
      arr.get(i).setTexture(tex);
  }
  arr.get(arr.size() - 1).setTexture(makeTextureRoad(roadColor));
}
ArrayList<PShape> createCity(int ny, int nx) {
  
  ArrayList<PShape> objs = new ArrayList();
  //PShape objs[] = new PShape[(2*ny + 1) * (2*nx + 1) + 1];
  
  PImage tex = makeTexture(0, 0, 1);
  
  PVector back = new PVector(0, -1, 0);
  PVector front = new PVector(0, 1, 0);
  PVector left = new PVector(1, 0, 0);
  PVector right = new PVector(-1, 0, 0);
  PVector up = new PVector(0, 0, 1);
  PVector down = new PVector(0, 0, -1);
  
  // The building size
  float bsizeX = 0.5;
  float bsizeY = 0.5;
  
  for (int j = -nx; j < nx; j++) {
    for (int i = -ny; i < ny; i++) {
      PShape obj = createShape();
      obj.beginShape(QUADS);
      obj.texture(tex);
      
      int buildingResolution = 128;
      float h = (int)(buildingResolution * noise(i + camx * 0.0, j + camy * 0.0));
      h /= buildingResolution;
      h *= maxh;
      
      PVector p000 = new PVector(i, j, 0);
      PVector p100 = new PVector(i + bsizeX, j, 0);
      PVector p200 = new PVector(i + 1, j, 0);      
      PVector p010 = new PVector(i, j + bsizeY, 0);
      PVector p110 = new PVector(i + bsizeX, j + bsizeY, 0);
      PVector p210 = new PVector(i + 1, j + bsizeY, 0);
      PVector p020 = new PVector(i, j + 1, 0);
      PVector p120 = new PVector(i + bsizeX, j + 1, 0);
      PVector p220 = new PVector(i + 1, j + 1, 0);
      
      // Roof
      PVector p001 = new PVector(i, j, h);
      PVector p101 = new PVector(i + bsizeX, j, h);
      PVector p011 = new PVector(i, j + bsizeY, h);
      PVector p111 = new PVector(i + bsizeX, j + bsizeY, h);

      // Walls: front, left, back, right
        makeQuad(obj, p000, p001, p101, p100, back, h, true, true);
        makeQuad(obj, p010, p011, p001, p000, left, h, true, false);
        makeQuad(obj, p110, p111, p011, p010, front, h, true, true);
        makeQuad(obj, p100, p101, p111, p110, right, h, true, false);
        
      // Roof
        makeQuad(obj, p001, p011, p111, p101, up, h, false, false);
        
      // Street
        //makeQuad(obj, p100, p120, p220, p200, up, h, false);
        //makeQuad(obj, p010, p020, p120, p110, up, h, false);
          
      obj.endShape();
      objs.add(obj);
    }
  }
  
  PShape roads = createShape();
  roads.beginShape(QUADS);
  makeQuad(roads, new PVector(-nx * meshScale, -ny * meshScale, 0),
                new PVector(-nx * meshScale, ny * meshScale, 0),
                new PVector(nx * meshScale, ny * meshScale, 0),
                new PVector(nx * meshScale, -ny * meshScale, 0),
                up, 1, false, false);
  roads.endShape();
  roads.setTexture(makeTextureRoad(0));
  objs.add(roads);
  return objs;
}

void makeQuad(PShape obj, PVector vec0, PVector vec1, PVector vec2, PVector vec3,
        PVector normal, float h, boolean windows, boolean transpose){
      int texLeft, texRight, texBottom, texTop;
      if(windows){
        texLeft = (int)(96 * noise(vec0.x, vec0.y));
        texRight = texLeft + 32;
        texBottom = 0;
        texTop = (int)(textScale * h / maxh);
      }else{
        texLeft = 0;
        texRight = 1;
        texBottom = 127;
        texTop = 128;
      }
      
      setNormal(obj, normal);
      setVertex(obj, vec0, texLeft, texBottom, transpose);
      setNormal(obj, normal);
      setVertex(obj, vec1, texLeft, texTop, transpose);
      setNormal(obj, normal);
      setVertex(obj, vec2, texRight, texTop, transpose);
      setNormal(obj, normal);
      setVertex(obj, vec3, texRight, texBottom, transpose);
}

void setVertex(PShape obj, PVector vec, float xtex, float ytex, boolean transpose){
  if(transpose)
    obj.vertex(meshScale * vec.x, meshScale * vec.y, meshScale * vec.z, ytex, xtex);
  else
    obj.vertex(meshScale * vec.x, meshScale * vec.y, meshScale * vec.z, xtex, ytex);
}
void setNormal(PShape obj, PVector vec){
  obj.normal(vec.x, vec.y, vec.z);
}


PImage makeTexture(float windowBrightness, float buildingColor, float fft){
  
  int imgScale = 128;
  PImage img = createImage(imgScale, imgScale, ARGB);
  for(int i = 0; i < imgScale; i++) {
    for(int j = 0; j < imgScale; j++) {
      
      // walls
      int r = (int)(map(j, 0, imgScale, 60, 0) * buildingColor);
      int g = (int)(map(j, 0, imgScale, 50, 20) * buildingColor);
      int b = (int)(map(j, 0, imgScale, 30, 30) * buildingColor);
      int a = 255;
      img.pixels[i + j * imgScale] = color(r, g, b, a); 
      
      if(i % 2 == 1 && j % 2 == 1){
        float noise = noise(i * 2 + camx * 0.002, j * 2 + camy * 0.002);
        noise = max(0, min(noise, 1));
        if(noise < treshold)
          noise = 0;
        noise += windowBrightness;
        noise *= fft;
        img.pixels[i + j * imgScale] = color(lerp(r, yellowR, noise),
                                            lerp(g, yellowG, noise), 
                                            lerp(b, yellowB, noise)); 
      }
    }
  }
/*
  // roads and rooftops
  for(int i = half; i < imgScale; i++) {
    for(int j = 0; j < imgScale; j++) {
      img.pixels[i + j * imgScale] = color(5, 5, 5, 255); 
    }
  }
  */
  return img;
}

PImage makeTextureFFT(int h){
  
  int imgScale = 128;
  PImage img = createImage(imgScale, imgScale, ARGB);
  for(int i = 0; i < imgScale; i++) {
    for(int j = 0; j < imgScale; j++) {
      // windows
      if(j < h)
        img.pixels[i + j * imgScale] = color(yellowR, yellowG, yellowB); 
      else
        img.pixels[i + j * imgScale] = color(0, 0, 0); 
    }
  }
/*
  // roads and rooftops
  for(int i = half; i < imgScale; i++) {
    for(int j = 0; j < imgScale; j++) {
      img.pixels[i + j * imgScale] = color(5, 5, 5, 255); 
    }
  }
  */
  return img;
}
PImage makeTextureRoad(int roadColor){
  
  PImage img = createImage(1, 1, ARGB);
  img.pixels[0] = color(roadColor);
  return img;
}
