import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/random_user_response.dart';

class RandomUserService {
  static const String _apiUrl = 'https://randomuser.me/api/';

  static Future<RandomUserResponse> fetchRandomUser() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return RandomUserResponse.fromJson(json);
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching random user: $e');
    }
  }
}
