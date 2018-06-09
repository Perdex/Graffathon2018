


void drawLight(float x, float y, float z){
  
  pushMatrix();
  shininess(10);
  emissive(255, 255, 150);
  fill(255, 255, 150);
  
  //filter( BLUR, 6 );
  
  noStroke();
  translate(x, y, z);
  sphere(0.1);
  //filter( BLUR, 0 );
  popMatrix();
}
