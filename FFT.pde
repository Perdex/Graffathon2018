JSONArray fftData;
JSONArray times;

void fftInit() {
  fftData = loadJSONArray("fft");
  times = loadJSONArray("times");
}

float[] fftGet(float t) {
  int idx = -1;
  for(int i = 0; i < 3366; i++) {
     if(times.getFloat(i) > t) {
       idx = i;
       break;
     }
  }
  JSONArray arr = fftData.getJSONArray(idx);
  float[] res = new float[20];
  for(int i = 0; i < 20; i++) {
     res[i] = arr.getFloat(i);
  }
  return res;
}
