import 'package:http/http.dart' as http;

class Api {
  Future<http.Response> post({required String url, required Map body}) async {
    final response = await http.post(
      Uri.parse(url),
      body: body,
    );
    return response;
  }

  Future<http.Response> get({required String url}) async {
    final response = await http.get(
      Uri.parse(url),
    );
    return response;
  }
}
