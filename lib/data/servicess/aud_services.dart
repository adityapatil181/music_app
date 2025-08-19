import 'dart:convert';
import 'package:http/http.dart' as http;

class AudDService {
  static const String _apiKey = 'c656209c4e8f1468279055c176932e44';

  static Future<Map<String, dynamic>?> recognizeSong(String filePath) async {
    try {
      final uri = Uri.parse('https://api.audd.io/');
      final request = http.MultipartRequest('POST', uri)
        ..fields['api_token'] = _apiKey
        ..fields['return'] = 'lyrics'
        ..files.add(await http.MultipartFile.fromPath('file', filePath));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final json = jsonDecode(responseData);

      if (json['status'] == 'success' && json['result'] != null) {
        return json['result'];
      } else {
        return null;
      }
    } catch (e) {
      print("AudD API Error: $e");
      return null;
    }
  }
}
