


void drawLight(float x, float y, float z, float size){
  
  pushMatrix();
  shininess(10);
  emissive(255, 255, 150);
  fill(255, 255, 150);
  
  //filter( BLUR, 6 );
  
  noStroke();
  translate(x, y, z);
  sphere(size);
  //filter( BLUR, 0 );
  popMatrix();
}
