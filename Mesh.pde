
PShape createCity(float s, int ny, int nx, PImage tex) {
  
  PShape obj = createShape();
  obj.beginShape(TRIANGLES);
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
  
  for (int j = 0; j < nx; j++) {
    
    for (int i = 0; i < ny; i++) {
      
      float h = 1;
      
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
        makeQuad(obj, p000, p001, p101, p100, back, true);
        makeQuad(obj, p010, p011, p001, p000, back, true);
        makeQuad(obj, p110, p111, p011, p010, back, true);
        makeQuad(obj, p100, p101, p111, p110, back, true);
  
      // Roof
        makeQuad(obj, p001, p011, p111, p101, back, true);
        
      // Street
        makeQuad(obj, p100, p120, p220, p200, back, true);
        makeQuad(obj, p010, p020, p210, p110, back, true);
    }
  }
  obj.endShape();
  return obj;
}

void makeQuad(PShape obj, PVector vec0, PVector vec1, PVector vec2, PVector vec3,
        PVector normal, boolean windows){
      float texBase = windows ? 0 : 0.5;
      
      setNormal(obj, normal);
      setVertex(obj, vec0, texBase, texBase);
      setNormal(obj, normal);
      setVertex(obj, vec1, texBase, texBase + 0.5);
      setNormal(obj, normal);
      setVertex(obj, vec2, texBase + 0.5, texBase + 0.5);
      
      setNormal(obj, normal);
      setVertex(obj, vec2, texBase + 0.5, texBase + 0.5);
      setNormal(obj, normal);
      setVertex(obj, vec3, texBase + 0.5, texBase);
      setNormal(obj, normal);
      setVertex(obj, vec0, 0, 0.5);
}

void setVertex(PShape obj, PVector vec, float xtex, float ytex){
  obj.vertex(vec.x, vec.y, vec.z, xtex, ytex);
}
void setNormal(PShape obj, PVector vec){
  obj.normal(vec.x, vec.y, vec.z);
}
// Evaluates the surface normal corresponding to normalized 
// parameters (u, v)
PVector evalNormal(float u, float v) {
  // Compute the tangents and their cross product.
  PVector p = evalPoint(u, v);
  PVector tangU = evalPoint(u + 0.01, v);
  PVector tangV = evalPoint(u, v + 0.01);
  tangU.sub(p);
  tangV.sub(p);
  
  PVector normUV = tangV.cross(tangU);
  normUV.normalize();
  return normUV;
}

// Evaluates the surface point corresponding to normalized 
// parameters (u, v)
PVector evalPoint(float u, float v) {
  float a = 0.5;
  float b = 0.3;
  float c = 0.5;
  float d = 0.1;
  float s = TWO_PI * u;
  float t = (TWO_PI * (1 - v)) * 2;  
        
  float r = a + b * cos(1.5 * t);
  float x = r * cos(t);
  float y = r * sin(t);
  float z = c * sin(1.5 * t);
        
  PVector dv = new PVector();
  dv.x = -1.5 * b * sin(1.5 * t) * cos(t) -
         (a + b * cos(1.5 * t)) * sin(t);
  dv.y = -1.5 * b * sin(1.5 * t) * sin(t) +
         (a + b * cos(1.5 * t)) * cos(t);
  dv.z = 1.5 * c * cos(1.5 * t);
        
  PVector q = dv;      
  q.normalize();
  PVector qvn = new PVector(q.y, -q.x, 0);
  qvn.normalize();
  PVector ww = q.cross(qvn);
        
  PVector pt = new PVector();
  pt.x = x + d * (qvn.x * cos(s) + ww.x * sin(s));
  pt.y = y + d * (qvn.y * cos(s) + ww.y * sin(s));
  pt.z = z + d * ww.z * sin(s);
  return pt;
}
