import 'dart:convert';

import 'package:http/http.dart' as http;

class MLApi {
  var _uri = Uri(scheme: 'http', host: '18.234.247.124', port: 8000);
  Future makePrediction(String filePath) async {
    var request = http.MultipartRequest('POST', _uri);
    request.files.add(await http.MultipartFile.fromPath('image', filePath));
    var streamedResponce = await request.send();
    var response = await http.Response.fromStream(streamedResponce);
    if (response.statusCode == 200) {
      return (json.decode(response.body));
    }
    throw 'Error: status code ${response.statusCode}';
  }
}
