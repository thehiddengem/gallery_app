// lib/models/web_image.dart
class WebImage {
  final String id;
  final String author;
  final String imageUrl;
  bool isLiked;

  WebImage({
    required this.id,
    required this.author,
    required this.imageUrl,
    this.isLiked = false, // Initialize as not liked
  });

  factory WebImage.fromJson(Map<String, dynamic> json) {
    return WebImage(
      id: json['id'] as String,
      author: json['author'] as String,
      imageUrl: 'https://picsum.photos/id/${json['id']}/600',
    );
  }
}
