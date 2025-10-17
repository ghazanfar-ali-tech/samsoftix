import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pixels_api/models/pixel_model.dart';

class PexelsService {
  static const String apiKey =
      'your Api Key';

  static Future<PixelPhotos?> fetchPhotos({String query = 'nature'}) async {
    final url = 'https://api.pexels.com/v1/search?query=$query&per_page=20';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': apiKey},
    );

    if (response.statusCode == 200) {
      return PixelPhotos.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}
