import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_app/models/web_image.dart';
import 'package:image_gallery_app/screens/favorite_screen.dart';
import 'package:image_gallery_app/services/image_service.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_app/widgets/web_image_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<WebImage> webImages = [];
  List<WebImage> likedImages = []; // Initialize the likedImages list
  int currentIndex = 0;
  final ImageWebService _imageService = ImageWebService(http.Client());
  final CarouselController _carouselController = CarouselController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Set<String> likedImageIds = Set<String>();

  @override
  void initState() {
    super.initState();
    fetchWebImages();
    loadLikedImages();
  }

  Future<void> fetchWebImages() async {
    try {
      final images = await _imageService.fetchWebImages(20);
      setState(() {
        webImages = images;
      });
    } catch (e) {
      print('Error fetching web images: $e');
    }
  }

  void goToPreviousImage() {
    if (currentIndex > 0) {
      _carouselController.previousPage();
    }
  }

  void goToNextImage() {
    if (currentIndex < webImages.length - 1) {
      _carouselController.nextPage();
    }
  }

  void toggleLike(String imageId) async {
    setState(() {
      if (likedImageIds.contains(imageId)) {
        likedImageIds.remove(imageId);
      } else {
        likedImageIds.add(imageId);
      }

      // Update likedImages based on the updated likedImageIds
      likedImages =
          webImages.where((image) => likedImageIds.contains(image.id)).toList();
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('likedImageIds', likedImageIds.toList());
  }

  Future<void> loadLikedImages() async {
    final prefs = await SharedPreferences.getInstance();
    final likedIds = prefs.getStringList('likedImageIds') ?? [];

    setState(() {
      likedImageIds = Set<String>.from(likedIds);
      likedImages =
          webImages.where((image) => likedImageIds.contains(image.id)).toList();
    });

    print('Liked Images: $likedImages');
  }

  void navigateToFavorites() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FavoritesScreen(
          likedImages: likedImages, // Pass the liked images
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Gallery App", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 79, 57, 186),
        actions: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: navigateToFavorites,
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: webImages.length,
              options: CarouselOptions(
                height: 550,
                enableInfiniteScroll: false,
                enlargeCenterPage: false,
                viewportFraction: 0.95,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              itemBuilder: (context, index, realIndex) {
                final webImage = webImages[index];
                final isLiked = likedImageIds.contains(webImage.id);

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      WebImageCard(webImage: webImage),
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.white,
                          ),
                          onPressed: () => toggleLike(webImage.id),
                        ),
                      ),
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
                  onPressed: goToPreviousImage,
                  color: Colors.white,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: goToNextImage,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
