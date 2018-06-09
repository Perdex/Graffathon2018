JSONObject fftData;
JSONArray times;

void fftInit() {
  fftData = loadJSONArray("fft");
  times = loadJSONArray("times");
}

float[] fftGet(int t) {
  JSONArray arr = fftData.getJSONArray(t);
  float[] res = new float[16];
  for(int i = 0; i < 16; i++) {
    res[i] = arr.getFloat(i); 
  }
  return res;
}
