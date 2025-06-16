// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
//
// class SavedImagesPage extends StatefulWidget {
//   @override
//   _SavedImagesPageState createState() => _SavedImagesPageState();
// }
//
// class _SavedImagesPageState extends State<SavedImagesPage> {
//   late Future<List<Map<String, dynamic>>> _imagesFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _imagesFuture = _fetchSavedImages();
//   }
//
//   Future<List<Map<String, dynamic>>> _fetchSavedImages() async {
//     List<Map<String, dynamic>> files = [];
//     final storageRef = FirebaseStorage.instance.ref().child('AR images');
//     final ListResult result = await storageRef.listAll();
//
//     for (var ref in result.items) {
//       final String url = await ref.getDownloadURL();
//       files.add({
//         "url": url,
//         "name": ref.name,
//         "ref": ref,
//       });
//     }
//
//     return files;
//   }
//
//   Future<void> _downloadImage(String url) async {
//     // Check and request storage permissions
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.storage,
//       Permission.manageExternalStorage, // For Android 11 and higher
//     ].request();
//
//     if (statuses[Permission.storage]!.isGranted || statuses[Permission.manageExternalStorage]!.isGranted) {
//       // Permission granted
//       try {
//         // Image download and saving logic
//         final response = await http.get(Uri.parse(url));
//         if (response.statusCode == 200) {
//           final Uint8List imageData = response.bodyBytes;
//           final result = await ImageGallerySaver.saveImage(imageData);
//           if (result['isSuccess']) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("Image downloaded to gallery!")),
//             );
//           } else {
//             throw Exception("Failed to save image");
//           }
//         } else {
//           throw Exception("Failed to download image");
//         }
//       } catch (error) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error downloading image: $error")),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Storage permission required to download images")),
//       );
//     }
//   }
//
//
//   Future<void> _deleteImage(Reference? ref) async {
//     if (ref == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: Unable to delete image")),
//       );
//       return;
//     }
//
//     try {
//       await ref.delete();
//       setState(() {
//         _imagesFuture = _fetchSavedImages(); // Refresh images list after deletion
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Image deleted successfully!")),
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error deleting image")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.lightBlue[500],
//         title: Text("Saved AR Images"),
//         centerTitle: true,
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _imagesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error loading images"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text("No images found"));
//           }
//
//           final images = snapshot.data!;
//
//           return ListView.builder(
//             padding: EdgeInsets.all(16),
//             itemCount: images.length,
//             itemBuilder: (context, index) {
//               final image = images[index];
//               return Stack(
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(bottom: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 10,
//                           offset: Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: GestureDetector(
//                         onTap: () => _downloadImage(image['url']),
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             Image.network(
//                               image['url'],
//                               width: double.infinity,  // Make the image as wide as the container
//                               height: 200,  // Set the height of the image (adjust this as needed)
//                               fit: BoxFit.cover,  // Use BoxFit.cover, BoxFit.contain, or BoxFit.fill depending on your needs
//                               loadingBuilder: (context, child, progress) {
//                                 if (progress == null) return child;
//                                 return Center(
//                                   child: CircularProgressIndicator(
//                                     value: progress.expectedTotalBytes != null
//                                         ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
//                                         : null,
//                                   ),
//                                 );
//                               },
//                             ),
//
//                             Positioned(
//                               bottom: 10,
//                               child: Text(
//                                 "Download Image",
//                                 style: TextStyle(
//                                   color: Colors.white.withOpacity(0.8),
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 10,
//                     right: 10,
//                     child: GestureDetector(
//                       onTap: () => _deleteImage(image['ref']),
//                       child: Icon(
//                         Icons.delete,
//                         color: Colors.red.withOpacity(0.7),
//                         size: 30,
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:onborading_screen/Home%20Page/homepage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class SavedImagesPage extends StatefulWidget {
  @override
  _SavedImagesPageState createState() => _SavedImagesPageState();
}

class _SavedImagesPageState extends State<SavedImagesPage> {
  late Future<List<Map<String, dynamic>>> _imagesFuture;

  @override
  void initState() {
    super.initState();
    _imagesFuture = _fetchSavedImages();
  }

  Future<List<Map<String, dynamic>>> _fetchSavedImages() async {
    List<Map<String, dynamic>> files = [];
    final storageRef = FirebaseStorage.instance.ref().child('AR images');
    final ListResult result = await storageRef.listAll();

    for (var ref in result.items) {
      final String url = await ref.getDownloadURL();
      files.add({
        "url": url,
        "name": ref.name,
        "ref": ref,
      });
    }

    return files;
  }

  Future<void> _downloadImage(String url) async {
    // Check and request storage permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.manageExternalStorage, // For Android 11 and higher
    ].request();

    if (statuses[Permission.storage]!.isGranted || statuses[Permission.manageExternalStorage]!.isGranted) {
      // Permission granted
      try {
        // Image download and saving logic
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final Uint8List imageData = response.bodyBytes;
          final result = await ImageGallerySaver.saveImage(imageData);
          if (result['isSuccess']) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Image downloaded to gallery!")),
            );
          } else {
            throw Exception("Failed to save image");
          }
        } else {
          throw Exception("Failed to download image");
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error downloading image: $error")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Storage permission required to download images")),
      );
    }
  }

  Future<void> _deleteImage(Reference? ref) async {
    if (ref == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: Unable to delete image")),
      );
      return;
    }

    try {
      await ref.delete();
      setState(() {
        _imagesFuture = _fetchSavedImages(); // Refresh images list after deletion
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image deleted successfully!")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting image")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press by navigating to the home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainHomePage()),
        );
        return false;  // Prevent the default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue[500],
          title: Text("Saved AR Images"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Pop the current screen and navigate to MainHomePage()
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainHomePage()),
              );
            },
          ),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(  // Keep the rest of the code unchanged
          future: _imagesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading images"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No images found"));
            }

            final images = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: GestureDetector(
                          onTap: () => _downloadImage(image['url']),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.network(
                                image['url'],
                                width: double.infinity,  // Make the image as wide as the container
                                height: 200,  // Set the height of the image (adjust this as needed)
                                fit: BoxFit.cover,  // Use BoxFit.cover, BoxFit.contain, or BoxFit.fill depending on your needs
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                bottom: 10,
                                child: Text(
                                  "Download Image",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () => _deleteImage(image['ref']),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red.withOpacity(0.7),
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
