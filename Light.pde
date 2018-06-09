


void drawLight(float x, float y, float z, float size){
  
  pushMatrix();
  //emissive(255, 255, 128);
  fill(255, 235, 100);
  
  //filter( BLUR, 6 );
  
  noStroke();
  translate(x, y, z);
  sphere(size);
  //filter( BLUR, 0 );
  popMatrix();
}
