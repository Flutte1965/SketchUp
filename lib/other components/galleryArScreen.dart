// this page will work when user pressed on gallery and pick image from gallery ,
// the object will displayed over the image and used as AR.


import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class GalleryOverlayPage extends StatefulWidget {
  final String backgroundImagePath; // Path to pick image from gallery
  final String overlayImageUrl;

  const GalleryOverlayPage({Key? key, required this.backgroundImagePath, required this.overlayImageUrl}) : super(key: key);

  @override
  _GalleryOverlayPageState createState() => _GalleryOverlayPageState();
}

class _GalleryOverlayPageState extends State<GalleryOverlayPage> {
  double _scale = 1.0;
  double _rotationAngle = 0.0; //  for rotation angle
  Offset _position = Offset(0, 0); // for position

  final ScreenshotController screenshotController = ScreenshotController();

  // Function to capture the current overlay and save it to Firebase
  Future<void> _captureAndSaveImage() async {
    final Uint8List? imageBytes = await screenshotController.capture(); // Capture the screenshot
    if (imageBytes != null) {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/Overlay_image_${DateTime.now()}.png';
      File imageFile = File(filePath);
      await imageFile.writeAsBytes(imageBytes);

      final storageRef = FirebaseStorage.instance.ref().child('AR images').child('Overlay_image_${DateTime.now()}.png'); // Firebase storage reference
      await storageRef.putFile(imageFile); // to upload our image to firestore
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image saved to Firebase in AR images folder!'))); // Show success message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screenshot( // Wrap the whole page in Screenshot widget to capture the screen
        controller: screenshotController,
        child: Stack( // Stack widget allows overlaying images on top of each other
          children: [
            // Background image from the gallery
            Positioned.fill(
              child: Image.file(
                File(widget.backgroundImagePath), // Display the background image selected from gallery
                fit: BoxFit.cover, // Ensure the image covers the entire screen
              ),
            ),
            // Overlay image with drag, scale, and rotation
            Positioned(
              top: _position.dy, // Position the overlay image based on drag position
              left: _position.dx, // Position the overlay image based on drag position
              child: GestureDetector( // GestureDetector to detect user gestures like drag
                onPanUpdate: (details) {
                  setState(() {
                    _position += details.delta; // Update position as the image is dragged
                  });
                },
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity() // Identity matrix for transformations
                    ..translate(_position.dx, _position.dy) // Apply translation for dragging
                    ..scale(_scale) // Apply scaling transformation based on slider value
                    ..rotateZ(_rotationAngle), // Apply rotation transformation based on slider value
                  child: Image.network(
                    widget.overlayImageUrl, // Load overlay image from URL
                    width: 200, // Set the width of the overlay image
                    height: 200, // Set the height of the overlay image
                    fit: BoxFit.cover, // Ensure the image fits well within the container
                  ),
                ),
              ),
            ),
            // Controls for scaling and rotation
            Positioned(
              bottom: 100, // Position the control panel above the bottom of the screen
              left: 20,
              right: 20,
              child: Column(
                children: [
                  // Slider for resizing the overlay image
                  Slider(
                    value: _scale, // Current scale value
                    min: 0.7, // Minimum scale value
                    max: 3.0, // Maximum scale value
                    onChanged: (value) {
                      setState(() {
                        _scale = value; // Update the scale as the slider moves
                      });
                    },
                    label: 'Resize', // Label for the resize slider
                  ),
                  // Slider for rotating the overlay image
                  Slider(
                    value: _rotationAngle, // Current rotation angle
                    min: 0, // Minimum rotation value (0 radians)
                    max: 6.28, // Maximum rotation value (2 * pi radians, full rotation)
                    onChanged: (value) {
                      setState(() {
                        _rotationAngle = value; // Update the rotation angle as the slider moves
                      });
                    },
                    label: 'Rotate', // Label for the rotation slider
                  ),
                ],
              ),
            ),
            // Capture button at the bottom to save the image
            Positioned(
              bottom: 0,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _captureAndSaveImage, // Capture and save the image when the button is pressed
                child: Text('Capture & Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
