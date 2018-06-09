
float meshScale = 100;
int textScale = 64;
int maxh = 3;

PShape createCity(int ny, int nx, PImage tex) {
  
  PShape obj = createShape();
  obj.beginShape(QUADS);
  obj.texture(tex);
  
  PVector back = new PVector(0, -1, 0);
  PVector front = new PVector(0, 1, 0);
  PVector left = new PVector(1, 0, 0);
  PVector right = new PVector(-1, 0, 0);
  PVector up = new PVector(0, 0, 1);
  PVector down = new PVector(0, 0, -1);
  
  // The building size
  float bsizeX = 0.5;
  float bsizeY = 0.5;
  
  for (int j = -nx; j <= nx; j++) {
    
    for (int i = -ny; i <= ny; i++) {
      
      float h = maxh * noise(i * 0.2, j * 0.4);
      
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
        makeQuad(obj, p100, p120, p220, p200, up, h, false);
        makeQuad(obj, p010, p020, p120, p110, up, h, false);
    }
  }
  obj.endShape();
  return obj;
}

void makeQuad(PShape obj, PVector vec0, PVector vec1, PVector vec2, PVector vec3,
        PVector normal, float h, boolean windows){
      float texLeft = windows ? 0 : textScale * 0.5;
      float texRight = texLeft + textScale * 0.5;
      float texBottom = windows ? 0 : textScale / 2;
      float texTop = textScale * (windows ? h / maxh  : 1);
      
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
