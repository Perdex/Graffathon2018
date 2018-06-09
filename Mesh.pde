
int meshScale = 100;
int textScale = 64;
int maxh = 4;

PShape createCity(int camx, int camy, int ny, int nx) {
  
  PShape obj = createShape();
  obj.beginShape(QUADS);
  
  PVector back = new PVector(0, -1, 0);
  PVector front = new PVector(0, 1, 0);
  PVector left = new PVector(1, 0, 0);
  PVector right = new PVector(-1, 0, 0);
  PVector up = new PVector(0, 0, 1);
  PVector down = new PVector(0, 0, -1);
  
  // The building size
  float bsizeX = 0.5;
  float bsizeY = 0.5;
  
  for (int j = -nx; j <= +nx; j++) {
    for (int i = -ny; i <= +ny; i++) {
      
      int buildingResolution = 128;
      float h = (int)(buildingResolution * noise(i + camx * 0.03, j + camy * 0.02));
      h /= buildingResolution;
      if(h < 0.1 || h > 0.7)
        h = 0;
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
        makeQuad(obj, p000, p001, p101, p100, back, h, true);
        makeQuad(obj, p010, p011, p001, p000, left, h, true);
        makeQuad(obj, p110, p111, p011, p010, front, h, true);
        makeQuad(obj, p100, p101, p111, p110, right, h, true);
        
      // Roof
        makeQuad(obj, p001, p011, p111, p101, up, h, false);
        
      // Street
        //makeQuad(obj, p100, p120, p220, p200, up, h, false);
        //makeQuad(obj, p010, p020, p120, p110, up, h, false);
    }
  }
  
  makeQuad(obj, new PVector(-nx * meshScale, -ny * meshScale, 0),
                new PVector(-nx * meshScale, ny * meshScale, 0),
                new PVector(nx * meshScale, ny * meshScale, 0),
                new PVector(nx * meshScale, -ny * meshScale, 0),
                up, 1, false);
  obj.endShape();
  addTexture(obj, camx, camy, treshold);
  return obj;
}

void makeQuad(PShape obj, PVector vec0, PVector vec1, PVector vec2, PVector vec3,
        PVector normal, float h, boolean windows){
      int texLeft, texRight, texBottom, texTop;
      if(windows){
        texLeft = 0;
        texRight = 31;
        texBottom = 0;
        texTop = (int)(textScale * h / maxh);
      }else{
        texLeft = 65;
        texRight = 66;
        texBottom = 0;
        texTop = 1;
      }
      
      setNormal(obj, normal);
      setVertex(obj, vec0, texLeft, texBottom);
      setNormal(obj, normal);
      setVertex(obj, vec1, texLeft, texTop);
      setNormal(obj, normal);
      setVertex(obj, vec2, texRight, texTop);
      setNormal(obj, normal);
      setVertex(obj, vec3, texRight, texBottom);
}

void setVertex(PShape obj, PVector vec, float xtex, float ytex){
  obj.vertex(meshScale * vec.x, meshScale * vec.y, meshScale * vec.z, xtex, ytex);
}
void setNormal(PShape obj, PVector vec){
  obj.normal(vec.x, vec.y, vec.z);
}


PImage img;
void addTexture(PShape obj, int x, int y, float treshold){
  
  int imgScale = 128;
  int half = 64;
  img = createImage(imgScale, imgScale, ARGB);
  for(int i = 0; i < half; i++) {
    for(int j = 0; j < imgScale; j++) {
      
      // walls
      int r = 0;//map(j, 0, half, 60, 0);
      int g = 0;//map(j, 0, half, 50, 20);
      int b = 0;//map(j, 0, half, 30, 30);
      int a = 255;
      img.pixels[i + j * imgScale] = color(r, g, b, a); 
      
      // windows
      if(i % 2 == 1 && j % 2 == 1){
        float noise = noise(i + x * 0.02, j + y * 0.02);
        if(noise < treshold)
          noise = 0;
        img.pixels[i + j * imgScale] = color(lerp(r, 255, noise),
                                            lerp(g, 235, noise), 
                                            lerp(b, 0, noise)); 
      }
    }
  }

  // roads and rooftops
  for(int i = half; i < imgScale; i++) {
    for(int j = 0; j < imgScale; j++) {
      img.pixels[i + j * imgScale] = color(5, 5, 5, 255); 
    }
  }
  obj.setTexture(img);
}
