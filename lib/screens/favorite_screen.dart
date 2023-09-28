import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_gallery_app/models/web_image.dart';
import 'package:image_gallery_app/widgets/web_image_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<WebImage> likedImages;

  FavoritesScreen({
    required this.likedImages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 79, 57, 186),
      ),
      body: likedImages.isNotEmpty
          ? LikedImagesCarousel(
              likedImages: likedImages,
            )
          : Center(
              child: Text("No liked images yet."),
            ),
    );
  }
}

class LikedImagesCarousel extends StatelessWidget {
  final List<WebImage> likedImages;
  final CarouselController _carouselController = CarouselController();

  LikedImagesCarousel({
    required this.likedImages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: likedImages.length,
            options: CarouselOptions(
              height: 550,
              enableInfiniteScroll: false,
              enlargeCenterPage: false,
              viewportFraction: 0.95,
              scrollDirection: Axis.horizontal,
            ),
            itemBuilder: (context, index, realIndex) {
              final webImage = likedImages[index];

              return Padding(
                key: Key(webImage.id), // Use a unique Key for each item
                padding: EdgeInsets.symmetric(horizontal: 1.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    WebImageCard(webImage: webImage),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  _carouselController.previousPage();
                },
                color: Colors.white,
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  _carouselController.nextPage();
                },
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
