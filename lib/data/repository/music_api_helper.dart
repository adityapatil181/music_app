// music_api_helper.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class MusicApiHelper {
  MusicApiHelper._(); 

  /// Fetch lyrics from lyrics.ovh API
  static Future<String> fetchLyrics({
    required String artist,
    required String title,
  }) async {
    try {
      final url = Uri.parse("https://api.lyrics.ovh/v1/$artist/$title");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['lyrics'] ?? "Lyrics not found";
      } else if (response.statusCode == 404) {
        return "Lyrics not found";
      } else {
        return "Error fetching lyrics: ${response.statusCode}";
      }
    } catch (e) {
      return "Error fetching lyrics: $e";
    }
  }
}
