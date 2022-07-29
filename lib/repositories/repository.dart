import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/test-model.dart';

const String SERVER = "https://jsonplaceholder.typicode.com";

// https://enable-cors.org/server.html - если будут проблемы с доступом к методу - httpXMLRequestError - включить CORS

class Repository {
  Future<TestModel> fetchTest() async {
    final url = Uri.parse("$SERVER/users");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return TestModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("response");
    }
  }
}