class Predictor {
  dynamic inputImage;
  Predictor({this.inputImage});
  dynamic resize() {
    return inputImage;
  }

  Future<Map> predict() async {
    await resize();
    return {"Disease": "Rust"};
  }
}
