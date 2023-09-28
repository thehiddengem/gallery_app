import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_gallery_app/models/web_image.dart';
import 'package:image_gallery_app/widgets/web_image_card.dart';

void main() {
  testWidgets('WebImageCard displays correctly', (WidgetTester tester) async {
    // Create a sample WebImage.
    final webImage = WebImage(
      id: '1',
      author: 'John Doe',
      imageUrl: 'https://example.com/image.jpg',
    );

    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WebImageCard(
            webImage: webImage,
          ),
        ),
      ),
    );

    // Verify that the widget displays the author's name.
    expect(find.text('John Doe'), findsOneWidget);

    // Verify that the widget displays the image.
    expect(find.byType(Image), findsOneWidget);

    // Verify that the widget's image URL matches the provided URL.
    final imageWidget = tester.widget<Image>(find.byType(Image));
    expect(imageWidget.image, isA<NetworkImage>());
    final networkImage = imageWidget.image as NetworkImage;
    expect(networkImage.url, 'https://example.com/image.jpg');
  });

  testWidgets('WebImageCard displays author name', (WidgetTester tester) async {
    // Create a sample WebImage with a different author.
    final webImage = WebImage(
      id: '2',
      author: 'Jane Smith',
      imageUrl: 'https://example.com/image2.jpg',
    );

    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WebImageCard(
            webImage: webImage,
          ),
        ),
      ),
    );

    // Verify that the widget displays the author's name.
    expect(find.text('Jane Smith'), findsOneWidget);
  });

  testWidgets('WebImageCard displays correct image',
      (WidgetTester tester) async {
    // Create a sample WebImage with a different image URL.
    final webImage = WebImage(
      id: '3',
      author: 'Alice Brown',
      imageUrl: 'https://example.com/image3.jpg',
    );

    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WebImageCard(
            webImage: webImage,
          ),
        ),
      ),
    );

    // Verify that the widget's image URL matches the provided URL.
    final imageWidget = tester.widget<Image>(find.byType(Image));
    expect(imageWidget.image, isA<NetworkImage>());
    final networkImage = imageWidget.image as NetworkImage;
    expect(networkImage.url, 'https://example.com/image3.jpg');
  });
}
