JSONArray fftData;

void fftInit(JSONArray js) {
  fftData = js; 
}

float[] fftGet(int t) {
  JSONArray arr = fftData.getJSONArray(t);
  float[] res = new float[16];
  for(int i = 0; i < 16; i++) {
    res[i] = arr.getFloat(i); 
  }
  return res;
}
