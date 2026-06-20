import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List> getArticles() async {
    final response = await http.get(
      Uri.parse('https://api.spaceflightnewsapi.net/v4/articles/?limit=20'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    }

    return [];
  }
}