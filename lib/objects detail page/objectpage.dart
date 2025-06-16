// this page excute when user pressed on any object from homepage,
// this page is containing a iamge of object and delete icon for deelete object, and deisng now bottm from where
// a dialog box will show and user will chose camera or gallery to move to ARview page or AR gallery page.

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onborading_screen/Home%20Page/homepage.dart';

import '../AR pages/ARviewPage.dart';
import '../other components/galleryArScreen.dart';

class ObjectDetailPage extends StatelessWidget {
  final String imageUrl; // Image URL from Firebase
  final String name;
  final String type;
  final String description;
  final String documentId; // Document ID in Firestore

  ObjectDetailPage({
    required this.imageUrl,
    required this.name,
    required this.type,
    required this.description,
    required this.documentId,
  });

  Future<void> _deleteImage(BuildContext context) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
      await FirebaseFirestore.instance.collection('objects').doc(documentId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image and object deleted successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainHomePage()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting image: $error")),
      );
    }
  }

  void _showDesignDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an Option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _openARView(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryOverlayPage(
              backgroundImagePath: pickedFile.path,
              overlayImageUrl: imageUrl,
            ),
          ),
        );
      }
    }
  }

  void _openARView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ARViewPage(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('    Object Details ',style: TextStyle(fontFamily: 'Kalam',fontSize: 26)),
        backgroundColor: Colors.lightBlue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover, // Fit image to the container
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red,size: 35,),
                    onPressed: () => _deleteImage(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                name.isEmpty ? 'No Name' : name, // Fallback for name
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Merienda', // Merienda font family
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                type.isEmpty ? 'Unknown Type' : type, // Fallback for type
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              description.isEmpty ? 'No Description Available' : description, // Fallback for description
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 50,),

            Center(
              child: ElevatedButton(
                onPressed: () => _showDesignDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[800], // Light-blue [800] button color
                  padding: EdgeInsets.symmetric(vertical: 15,horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Design Now",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
