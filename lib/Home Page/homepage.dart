// this is home page, this page containing everything
// this page containing list of objects, list of containers , Nav bar , drawer , app etc..




import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onborading_screen/Login%20Screens/Loginscreen.dart';
import 'package:onborading_screen/Login%20Screens/Welcomescreen.dart';
import 'package:onborading_screen/other%20components/savedimages.dart';

import '../create new object page/upload_items_screen.dart';
import '../main.dart';
import '../objects detail page/objectpage.dart';
import '../other components/detailpage.dart';
import '../other components/fav objectspage.dart';
import '../other components/feedback.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  _MainHomePageState createState() => _MainHomePageState();
}


class _MainHomePageState extends State<MainHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, bool> favoritedItems = {};
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 50,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text(
          'SketchUp',
          style: TextStyle(
            fontFamily: 'Kalam',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          // image of logo showing on app bar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo.png', // logo image showing on app bar
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),




       // drawer with holding saved image , fav objects , feedback, pages
      drawer: Drawer(
        elevation: 20,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlue[800],
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade900,
                    blurRadius: 100,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              // we uses account widget for add logo imge, name etc.
              accountName: const Text(
                '                   SKETCHUP ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
              accountEmail: const Text(''),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/logo.png'), // logo image
                backgroundColor: Colors.white,
              ),
            ),


            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.list_alt, color: Colors.black, size: 30),
              title: Text(
                'Saved images',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SavedImagesPage()),
                );
              },
            ),


            ListTile(
              leading: Icon(Icons.favorite, color: Colors.black, size: 30),
              title: Text(
                'Favorite Objects',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StreamBuilder<QuerySnapshot>(


                      // StreamBuilder listens to changes in the 'objects' collection from Firestore
                      stream: FirebaseFirestore.instance.collection('objects').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {

                          // If the snapshot has data, process the objects in the 'objects' collection
                          List<QueryDocumentSnapshot> objects = snapshot.data!.docs;
                          return FavoriteObjectsPage(


                            // Passing favoritedItems and objects to the FavoriteObjectsPage widget

                            favoritedItems: favoritedItems,
                            objects: objects,
                          );
                        } else {

                          // If there's no data or loading, show a loading indicator
                          return Scaffold(
                            body: Center(child: CircularProgressIndicator()), // CircularProgressIndicator shows loading state
                          );
                        }
                      },
                    ),
                  ),

                );
              },
            ),

            ListTile(
              leading: Icon(Icons.feedback, color: Colors.black, size: 32),
              title: Text(
                'Feedback',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                   Navigator.pop(context);
                   Navigator.pushReplacement(
                    context,
                       MaterialPageRoute(builder: (context) => FeedbackScreen()),);
              },
            ),
            SizedBox(height: 220),

            Material(
              elevation: 5, // Add shadow
              child: Container(
                color: Colors.blue, // Blue background
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.white), // Logout Icon
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () =>  _signOut(context),
                ),
              ),
            ),

          ],
        ),
      ),




     // body is starting from here, column for showing containers for designs and object lists
      body: Column(
          children: [
      const Padding(
      padding: EdgeInsets.only(right: 180, left: 4, top: 10),
      child: Text(
        "Explore More Designs:",
        style: TextStyle(
          fontSize: 18,
          fontFamily: "Noto",
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),),),



    const SizedBox(height: 10),

           // For Designs Explore
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // Bedroom Image
                  ContainerWidget(
                    imageUrl: 'assets/images/bedroom.jpg',
                    onTap: () {
                      // Navigate to DetailPage with multiple images
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            title: 'Bedroom Design',
                            imageUrls: [
                              'assets/images/bedroom1.jpg',
                              'assets/images/bedroom2.jpg',  // Add more images
                              'assets/images/bedroom.jpg',
                            ],
                            description: 'Unwind in this serene bedroom sanctuary, adorned with plush bedding, chic pendant lights, and minimalist wall art to create a space of ultimate relaxation and style',
                          ),
                        ),
                      );
                    },
                  ),


                  // TVhall Design
                  ContainerWidget(
                    imageUrl: 'assets/images/hall.jpg',
                    onTap: () {
                      // Navigate to DetailPage with multiple images
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            title: 'TV Hall Design',
                            imageUrls: [
                              'assets/images/hall1.jpg',
                              'assets/images/hall2.jpg',  // Add more images
                              'assets/images/hall3.jpg',
                            ],
                            description: 'Relax in style in this modern living room with a sleek TV setup, cozy seating, and a combination of contemporary shelving and soft lighting for the perfect balance of comfort and sophistication.',
                          ),
                        ),
                      );
                    },
                  ),


                  // Kitchen Deisgn
                  ContainerWidget(
                    imageUrl: 'assets/images/kitchen.jpg',
                    onTap: () {
                      // Navigate to DetailPage with multiple images
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            title: 'Kitchen Design',
                            imageUrls: [
                              'assets/images/kitchen1.jpg',
                              'assets/images/kitchen2.jpg',  // Add more images
                              'assets/images/kitchen3.jpg',
                            ],
                            description: 'Host elegant dinners in this beautifully designed dining room, featuring a luxurious long table, upholstered chairs, and ambient lighting that creates a warm and inviting atmosphere',
                          ),
                        ),
                      );
                    },
                  ),


                  // study room
                  ContainerWidget(
                    imageUrl: 'assets/images/study.jpg',
                    onTap: () {
                      // Navigate to DetailPage with multiple images
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            title: 'Study room  Design',
                            imageUrls: [
                              'assets/images/study1.jpeg','assets/images/study2.jpg','assets/images/study3.jpg',
                            ],
                            description: 'Boost productivity in this sleek study room, featuring a comfortable desk, organized shelving, and warm lighting, creating a perfect environment for focus and creativity',
                          ),
                        ),
                      );
                    },
                  ),


                    //drawing room
                  ContainerWidget(
                    imageUrl: 'assets/images/drawing.jpg',
                    onTap: () {
                      // Navigate to DetailPage with multiple images
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            title: 'Drawing Room',
                            imageUrls: [
                              'assets/images/drawing1.jpg',
                              'assets/images/drawing2.jpg',
                              'assets/images/drawing.jpg',
                            ],
                            description: 'Make lasting impressions in this stunning drawing room, complete with stylish seating, a modern coffee table, and elegant decor, designed for comfort and unforgettable gatherings',
                          ),
                        ),
                      );
                    },
                  ),
                  // Add other images in similar fashion...
                ],
              ),
            ),


            // for object txt and add icon
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Objects:",
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: "Noto",
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ItemUpload()),   // from here we call Itemupload page for create new object
                    );
                  },

                  //for decoration of button (+)
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15),
                    // padding: const EdgeInsets.only(top: 120, right: 10, left: 70,),
                    backgroundColor: Colors.blueAccent,
                    shadowColor: Colors.grey,
                    elevation: 10,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),


          const SizedBox(height: 5),



            //for objects list , this is container where objects are showing in list
            Expanded(
              child: Container(
                height: 700,
                width: 500,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade300, Colors.grey.shade400], // Gradient background
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20), // Rounded corners for container
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Soft shadow for depth effect
                      spreadRadius: 4,
                      blurRadius: 8,
                      offset: Offset(5, 3), // Shadow offset
                    ),
                  ],
                ),
                margin: EdgeInsets.all(10), // Outer margin
                padding: EdgeInsets.all(10), // Inner padding
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('objects').snapshots(), // Listening to 'objects' collection changes
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator()); // Show loading indicator if no data
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length, // Get the number of documents in the snapshot
                      itemBuilder: (context, index) {
                        var object = snapshot.data!.docs[index]; // Object from Firestore document
                        String objectId = object.id; // Object ID
                        bool isFavorited = favoritedItems[objectId] ?? false; // Check if the item is favorited

                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5), // Margin around each list item
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54, width: 1), // Border around each list item
                            borderRadius: BorderRadius.circular(20), // Rounded corners
                          ),
                          child: ListTile(
                            leading: ClipOval(
                              child: Container(
                                width: 60, // Set the size of the circular image
                                height: 60,
                                child: Image.network(
                                  object['imageUrl'], // Image URL from Firestore
                                  fit: BoxFit.cover, // Cover the area with the image
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error, color: Colors.red); // Error handling for missing images
                                  },
                                ),
                              ),
                            ),
                            title: Text(
                              object['name'], // Display the object's name
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: "Merienda",
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              object['type'], // Display the object's type
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isFavorited ? Icons.favorite : Icons.favorite_border, // Conditional favorite icon
                                color: isFavorited ? Colors.red : Colors.lightBlue[800],
                                size: 24,
                              ),
                              onPressed: () {
                                setState(() {
                                  favoritedItems[objectId] = !isFavorited; // Toggle the favorite status
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      favoritedItems[objectId]!
                                          ? '${object['name']} added to favorites'
                                          : '${object['name']} removed from favorites',
                                    ),
                                  ),
                                );
                              },
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10), // Padding inside the list item
                            onTap: () {
                              // Navigate to the detail page for the object
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ObjectDetailPage(
                                    imageUrl: object['imageUrl'] ?? '', // Default empty string if image URL is null
                                    name: object['name'] ?? 'No Name', // Default name if null
                                    type: object['type'] ?? 'Unknown Type', // Default type if null
                                    description: object['description'] ?? 'No Description Available', // Default description if null
                                    documentId: object.id, // Pass the document ID
                                  ),
                                ),
                              );
                            },
                          ),
                        );},);},),
              ),
            ),


            // here we are calling Nav bar
            BottomNavBar(
            favoritedItems: favoritedItems,
            onCameraPressed: () async {
              await _captureImageWithCamera(context);
            },
          ),
        ],
      ),
    );
  }


  // we can capture image from nav bar and move to Iteamupload screen to create new object.
  Future<void> _captureImageWithCamera(BuildContext context) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        Uint8List imageFileUint8List = await pickedImage.readAsBytes();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemUpload(
              capturedImage: imageFileUint8List,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image captured!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }



  // for signout
  void _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Welcomescreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }
}


// bottom nav bar code,
class BottomNavBar extends StatelessWidget {
  final Map<String, bool> favoritedItems;
  final VoidCallback onCameraPressed;

  BottomNavBar({
    required this.favoritedItems,
    required this.onCameraPressed,
  });

  @override
  Widget build(BuildContext context) {
    bool hasFavorites = favoritedItems.values.contains(true);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15, // More blur for a softer shadow
            offset: const Offset(0, -5), // Slight vertical offset
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Favorite Button with animation and different icon size
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                hasFavorites ? Icons.favorite : Icons.favorite_border,
                key: ValueKey<bool>(hasFavorites),
                color: hasFavorites ? Colors.red : Colors.blue,
                size: 35,
              ),
            ),
            onPressed: () {
              if (hasFavorites) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('objects').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<QueryDocumentSnapshot> objects = snapshot.data!.docs;
                          return FavoriteObjectsPage(
                            favoritedItems: favoritedItems,
                            objects: objects,
                          );
                        } else {
                          return const Scaffold(
                            body: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No favorite items to display!')),
                );
              }
            },
          ),
          const SizedBox(width: 40),

          // FloatingActionButton with animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: FloatingActionButton(
              onPressed: onCameraPressed,
              backgroundColor: Colors.lightBlue[800],
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 45,
              ),
              elevation: 10,
              shape: const CircleBorder(),
            ),
          ),
          const SizedBox(width: 40),

          // Image Button
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.image,
                key: ValueKey<bool>(hasFavorites),
                color: Colors.lightBlue,
                size: 35,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedImagesPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}





// Container Widget for displaying objects list and its designing
class ContainerWidget extends StatelessWidget {
final String imageUrl;
final VoidCallback onTap;

const ContainerWidget({
Key? key,
required this.imageUrl,
required this.onTap,
}) : super(key: key);

@override
Widget build(BuildContext context) {
return GestureDetector(
onTap: onTap,
child: Container(
width: 250,
height: 10,
margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 60, top: 4),
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(10),
boxShadow: [
BoxShadow(
color: Colors.grey.withOpacity(0.5),
spreadRadius: 10,
blurRadius: 10,
offset: const Offset(0, 18),
),
],
),
child: ClipRRect(
borderRadius: BorderRadius.circular(30),
child: Image.asset(
imageUrl,
fit: BoxFit.cover,
),
),
),
);
}
}




