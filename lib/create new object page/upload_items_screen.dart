// this page is main page for create new object or add new object.
// this page will execute when user pressed on add + icon from homepage,
// in this page there are 3 screeens
// one for add new item // second for show dilog box
// third for remove backgound and save object
// this page handling background of images with API , and Saving of object to firebase and diloug box



import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class ItemUpload extends StatefulWidget {
  final Uint8List? capturedImage; // Optional parameter to accept image from NavBar

  ItemUpload({this.capturedImage}); // Constructor to optionally pass an image

  @override
  State<ItemUpload> createState() => _ItemUploadState(); // Create the state for ItemUpload
}


class _ItemUploadState extends State<ItemUpload> {
  Uint8List? imageFileUint8List;
  Uint8List? processedImage;

  // Controllers for text fields
  TextEditingController objectNameTextEditingController = TextEditingController();
  TextEditingController objectTypeTextEditingController = TextEditingController();
  TextEditingController objectDescriptionTextEditingController = TextEditingController();

  bool isUploading = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Initialize with captured image if passed
    if (widget.capturedImage != null) {
      imageFileUint8List = widget.capturedImage;
    }
  }

  Future<void> removeBackground(Uint8List imageBytes) async {
    setState(() {
      isProcessing = true; // Set the processing flag to true to show loading indicator
    });

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.remove.bg/v1.0/removebg'), // API endpoint for background removal
    );
    request.headers['X-Api-Key'] = 'zsABjB5KjxkMDBSWZX5983Ku'; // Replace with your API key (authentication)
    // Adding the image file to the request body, the key 'image_file' is the field name expected by the API
    request.files.add(http.MultipartFile.fromBytes('image_file', imageBytes, filename: 'image.png'));

    try {
      final response = await request.send();
      if (response.statusCode == 200) { // Check if the response status is OK (200)
        final responseData = await response.stream.toBytes(); // Get the response data (processed image)
        setState(() {
          processedImage = responseData; // Update the processed image state
          isProcessing = false; // Set processing flag to false
        });
      } else { // If the response is not successful
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to remove background.'))); // Show error message
        setState(() {
          isProcessing = false; // Set processing flag to false on failure
        });
      }
    } catch (e) {
      print(e.toString()); // Print any errors for debugging
      setState(() {
        isProcessing = false; // Set processing flag to false in case of error
      });
    }
  }


  Future<void> _saveObject() async {
    // Check if any required fields are empty or processed image is null
    if (processedImage == null ||
        objectNameTextEditingController.text.isEmpty ||
        objectTypeTextEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Please fill all required fields and remove the background from the image')));
      return;
    }

    setState(() {
      isUploading = true; // Set uploading flag to true
    });

    try {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      // Create a reference to the Firebase storage for the object image
      Reference storageRef = FirebaseStorage.instance.ref().child('objects').child('$imageName.png');
      UploadTask uploadTask = storageRef.putData(processedImage!); // Upload the image
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL(); // Get image URL after upload

      // Add object data to Firestore
      await FirebaseFirestore.instance.collection('objects').add({
        'name': objectNameTextEditingController.text,
        'type': objectTypeTextEditingController.text,
        'description': objectDescriptionTextEditingController.text.isEmpty
            ? null
            : objectDescriptionTextEditingController.text,
        'imageUrl': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        isUploading = false; // Set uploading flag to false
        imageFileUint8List = null;
        processedImage = null;
        objectNameTextEditingController.clear();
        objectTypeTextEditingController.clear();
        objectDescriptionTextEditingController.clear();
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Object saved successfully!')));
    } catch (error) {
      setState(() {
        isUploading = false; // Set uploading flag to false on error
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to upload object.')));
    }
  }


  Widget uploadFromScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Item Screen"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          // Show progress indicator while uploading
          isUploading
              ? const LinearProgressIndicator(color: Colors.blue)
              : Container(),
          SizedBox(
            height: 250,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: processedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(processedImage!),
                )
                    : imageFileUint8List != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(imageFileUint8List!),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.blueAccent,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
          ),



          const Divider(color: Colors.white70, thickness: 2),
          // Show loading indicator if image background is being processed
          isProcessing
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
            onPressed: () {
              if (imageFileUint8List != null) {
                removeBackground(imageFileUint8List!);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select an image first')));
              }
            },
            child: const Text("Remove Background", style: TextStyle( color: Colors.black54),),
          ),



          // Input fields for object details (name, type, description)
          ListTile(
            leading: const Icon(
                Icons.drive_file_rename_outline_rounded, color: Colors.blue),
            title: TextField(
              controller: objectNameTextEditingController,
              decoration: InputDecoration(hintText: 'Object Name'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.merge_type_sharp, color: Colors.blue),
            title: TextField(
              controller: objectTypeTextEditingController,
              decoration: InputDecoration(hintText: 'Object Type'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description_rounded, color: Colors.blue),
            title: TextField(
              controller: objectDescriptionTextEditingController,
              decoration: InputDecoration(
                  hintText: 'Object Description (Optional)'),
            ),
          ),
          SizedBox(height: 30),
          // Save button for uploading the object
          ElevatedButton(
            onPressed: _saveObject,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue[800],
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Save Object",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }


  Widget defaultScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Upload new item",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_photo_alternate, color: Colors.white, size: 200),
            ElevatedButton(
              onPressed: showDialogBox,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
              child: Text(
                "Add new Item",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showDialogBox() {
    return showDialog(
      context: context,
      builder: (c) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select image From?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: captureImageWithCamera,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text(
                          "Camera",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: chooseFromGallery,
                        icon: const Icon(Icons.image),
                        label: const Text(
                          "Gallery",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  captureImageWithCamera() async {
    Navigator.pop(context);
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        imageFileUint8List = await pickedImage.readAsBytes();
        setState(() {
          imageFileUint8List;
        });
      }
    } catch (errorMsg) {
      print(errorMsg.toString());
      setState(() {
        imageFileUint8List = null;
      });
    }
  }

  chooseFromGallery() async {
    Navigator.pop(context);
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        imageFileUint8List = await pickedImage.readAsBytes();
        setState(() {
          imageFileUint8List;
        });
      }
    } catch (errorMsg) {
      print(errorMsg.toString());
      setState(() {
        imageFileUint8List = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: imageFileUint8List == null ? defaultScreen() : uploadFromScreen(),

    );
  }
}
