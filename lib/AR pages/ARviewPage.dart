// // A page when user chose camera for AR then this page will work,
// // object will showen in AR theames over camera.
// // we are using ArView widget and scaling function for rotation and resizing
//
//
//
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:path_provider/path_provider.dart';
//
// class ARViewPage extends StatefulWidget {
//   final String imageUrl;
//
//   const ARViewPage({Key? key, required this.imageUrl}) : super(key: key);
//
//   @override
//   _ARViewPageState createState() => _ARViewPageState();
// }
//
// class _ARViewPageState extends State<ARViewPage> {
//   late CameraController _cameraController; // Controller to manage camera
//   bool isCameraInitialized = false; // Flag to check if camera is ready
//
//   // Persistent transformations for the AR image
//   double _scale = 1.0; // Scale factor for resizing the image
//   double _rotationAngle = 0.0; // Rotation angle for the image
//   Offset _position = Offset(0, 0); // Position for drag gesture
//
//   final ScreenshotController screenshotController = ScreenshotController();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera(); // Initialize the camera when the widget is created
//   }
//
//   // Function to initialize the camera
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras(); // Get list of available cameras
//     _cameraController = CameraController(cameras[0], ResolutionPreset.high); // Use the first camera with high resolution
//     await _cameraController.initialize(); // Initialize the camera controller
//     setState(() {
//       isCameraInitialized = true; // Set camera initialized flag to true
//     });
//   }
//
//   @override
//   void dispose() {
//     _cameraController.dispose(); // Dispose of the camera controller when the widget is disposed
//     super.dispose();
//   }
//
//   // Function to capture and save the image to Firebase
//   Future<void> _captureAndSaveImage() async {
//     final Uint8List? imageBytes = await screenshotController.capture(); // Capture the screenshot
//     if (imageBytes != null) {
//       final tempDir = await getTemporaryDirectory(); // Get the temporary directory
//       final filePath = '${tempDir.path}/AR_image_${DateTime.now()}.png'; // File path to save image
//       File imageFile = File(filePath);
//       await imageFile.writeAsBytes(imageBytes); // Save the image bytes to the file
//
//       final storageRef = FirebaseStorage.instance.ref().child('AR images').child('AR_image_${DateTime.now()}.png');
//       await storageRef.putFile(imageFile); // Upload the image to Firebase Storage
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image saved to Firebase in AR images folder!')));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isCameraInitialized
//           ? Screenshot( // Wrap the camera preview and AR content in a Screenshot widget
//         controller: screenshotController,
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: CameraPreview(_cameraController), // Show the live camera feed
//             ),
//             Center(
//               child: GestureDetector(
//                 onPanUpdate: (details) {
//                   setState(() {
//                     // Update the position for drag gesture
//                     _position += details.delta; // Drag the image on screen
//                   });
//                 },
//                 child: Transform(
//                   alignment: Alignment.center,
//                   transform: Matrix4.identity()
//                     ..translate(_position.dx, _position.dy) // Apply drag position to the image
//                     ..scale(_scale) // Apply scaling transformation to the image
//                     ..rotateZ(_rotationAngle), // Apply rotation to the image
//                   child: Container(
//                     width: 200, // Fixed width for the AR image
//                     height: 200, // Fixed height for the AR image
//                     alignment: Alignment.center,
//                     child: Image.network(
//                       widget.imageUrl, // Display the image from the URL
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             // Controls for scaling and rotation
//             Positioned(
//               bottom: 100,
//               left: 20,
//               right: 20,
//               child: Column(
//                 children: [
//                   // Slider for resizing the image
//                   Slider(
//                     value: _scale, // Current scale value
//                     min: 0.7, // Minimum scale
//                     max: 3.0, // Maximum scale
//                     onChanged: (value) {
//                       setState(() {
//                         _scale = value; // Update scale when the slider changes
//                       });
//                     },
//                     label: 'Resize', // Label for the slider
//                   ),
//                   // Slider for rotating the image
//                   Slider(
//                     value: _rotationAngle, // Current rotation value
//                     min: 0, // Minimum rotation (0 radians)
//                     max: 6.28, // Maximum rotation (2 * pi radians)
//                     onChanged: (value) {
//                       setState(() {
//                         _rotationAngle = value; // Update rotation when the slider changes
//                       });
//                     },
//                     label: 'Rotate', // Label for the slider
//                   ),
//                 ],
//               ),
//             ),
//             // Capture button at the very bottom
//             Positioned(
//               bottom: 0,
//               left: 20,
//               right: 20,
//               child: ElevatedButton(
//                 onPressed: _captureAndSaveImage, // Call capture function on button press
//                 child: Text('Capture & Save', style: TextStyle(color: Colors.black54),),
//               ),
//             ),
//           ],
//         ),
//       )
//           : Center(child: CircularProgressIndicator()), // Show a loading indicator while the camera initializes
//     );
//   }
// }
//


import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class ARViewPage extends StatefulWidget {
  final String imageUrl;

  const ARViewPage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _ARViewPageState createState() => _ARViewPageState();
}

class _ARViewPageState extends State<ARViewPage> {
  late CameraController _cameraController; // Controller to manage camera
  bool isCameraInitialized = false; // Flag to check if camera is ready

  // Persistent transformations for the AR image
  double _scale = 1.0; // Scale factor for resizing the image
  double _rotationAngle = 0.0; // Rotation angle for the image
  Offset _position = Offset(0, 0); // Position for drag gesture

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _initializeCamera(); // Initialize the camera when the widget is created
  }

  // Function to initialize the camera
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras(); // Get list of available cameras
    _cameraController = CameraController(cameras[0], ResolutionPreset.high); // Use the first camera with high resolution
    await _cameraController.initialize(); // Initialize the camera controller
    setState(() {
      isCameraInitialized = true; // Set camera initialized flag to true
    });
  }

  @override
  void dispose() {
    _cameraController.dispose(); // Dispose of the camera controller when the widget is disposed
    super.dispose();
  }

  // Function to capture and save the image to Firebase
  Future<void> _captureAndSaveImage() async {
    final Uint8List? imageBytes = await screenshotController.capture(); // Capture the screenshot
    if (imageBytes != null) {
      final tempDir = await getTemporaryDirectory(); // Get the temporary directory
      final filePath = '${tempDir.path}/AR_image_${DateTime.now()}.png'; // File path to save image
      File imageFile = File(filePath);
      await imageFile.writeAsBytes(imageBytes); // Save the image bytes to the file

      final storageRef = FirebaseStorage.instance.ref().child('AR images').child('AR_image_${DateTime.now()}.png');
      await storageRef.putFile(imageFile); // Upload the image to Firebase Storage
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image saved to Firebase in AR images folder!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isCameraInitialized
          ? Screenshot( // Wrap the camera preview and AR content in a Screenshot widget
        controller: screenshotController,
        child: Stack(
          children: [
            Positioned.fill(
              child: CameraPreview(_cameraController), // Show the live camera feed
            ),
            Center(
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    // Update the position for drag gesture
                    _position += details.delta; // Drag the image on screen
                  });
                },
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..translate(_position.dx, _position.dy) // Apply drag position to the image
                    ..scale(_scale) // Apply scaling transformation to the image
                    ..rotateZ(_rotationAngle), // Apply rotation to the image
                  child: Container(
                    width: 200, // Fixed width for the AR image
                    height: 200, // Fixed height for the AR image
                    alignment: Alignment.center,
                    child: Image.network(
                      widget.imageUrl, // Display the image from the URL
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            // Controls for scaling and rotation
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  // Slider for resizing the image
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Colors.grey, // Active track color
                      inactiveTrackColor: Colors.grey.shade300, // Inactive track color
                      thumbColor: Colors.grey, // Thumb color
                      overlayColor: Colors.grey.withOpacity(0.2), // Overlay when thumb is pressed
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0), // Thumb size
                      trackHeight: 4.0, // Height of the slider track
                    ),
                    child: Slider(
                      value: _scale, // Current scale value
                      min: 0.7, // Minimum scale
                      max: 3.0, // Maximum scale
                      onChanged: (value) {
                        setState(() {
                          _scale = value; // Update scale when the slider changes
                        });
                      },
                      label: 'Resize', // Label for the slider
                    ),
                  ),
                  // Slider for rotating the image
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Colors.grey, // Active track color
                      inactiveTrackColor: Colors.grey.shade300, // Inactive track color
                      thumbColor: Colors.grey, // Thumb color
                      overlayColor: Colors.grey.withOpacity(0.2), // Overlay when thumb is pressed
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0), // Thumb size
                      trackHeight: 4.0, // Height of the slider track
                    ),
                    child: Slider(
                      value: _rotationAngle, // Current rotation value
                      min: 0, // Minimum rotation (0 radians)
                      max: 6.28, // Maximum rotation (2 * pi radians)
                      onChanged: (value) {
                        setState(() {
                          _rotationAngle = value; // Update rotation when the slider changes
                        });
                      },
                      label: 'Rotate', // Label for the slider
                    ),
                  ),
                ],
              ),
            ),
            // Capture button at the very bottom
            Positioned(
              bottom: 0,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _captureAndSaveImage, // Call capture function on button press
                child: Text(
                  'Capture & Save',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      )
          : Center(child: CircularProgressIndicator()), // Show a loading indicator while the camera initializes
    );
  }
}
