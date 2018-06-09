BufferedReader reader = createReader('fft');

float[] readLine() {
  String[] pieces = split(reader.readLine(), ',');
  float[] res = new float[pieces.length()];
  for(int i = 0; i < pieces.length(); i++) {
    res[i] = float(pieces[i]);
  }
  return res;
}
