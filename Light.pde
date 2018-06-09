


void drawLight(float x, float y, float z){
  
  pushMatrix();
  shininess(10);
  emissive(255, 255, 150);
  
  //filter( BLUR, 6 );
  
  noStroke();
  fill(255);
  translate(x, y, z);
  sphere(0.5);
  //filter( BLUR, 0 );
  popMatrix();
}
