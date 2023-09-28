import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_gallery_app/models/web_image.dart';
import 'dart:math';

class ImageWebService {
  final http.Client _client;
  final Random _random = Random();

  ImageWebService(this._client);

  Future<List<WebImage>> fetchWebImages(int count) async {
    // Generate a random page number
    final int page = _random.nextInt(10) + 1; // Adjust the range as needed

    final response = await _client.get(Uri.parse(
        'https://picsum.photos/v2/list?page=$page&limit=$count')); // Fetch up to 'count' images from a random page
    if (response.statusCode == 200) {
      final List<dynamic> parsedJson = jsonDecode(response.body);
      return parsedJson.map((json) => WebImage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load web images');
    }
  }
}
