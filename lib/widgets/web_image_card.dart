import 'package:flutter/material.dart';
import 'package:image_gallery_app/models/web_image.dart';

class WebImageCard extends StatelessWidget {
  final WebImage webImage;

  WebImageCard({required this.webImage});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12.0), // Rounded corners for the entire card
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            title: Text(
              webImage.author,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            tileColor:
                Color.fromARGB(255, 206, 201, 247), // Set the background color
          ),
          Expanded(
            child: Image.network(
              webImage.imageUrl,
              fit: BoxFit.cover, // Ensure the image covers the entire space
            ),
          ),
        ],
      ),
    );
  }
}
