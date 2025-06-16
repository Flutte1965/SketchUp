// this page excute when user pressed on diesng now botton from designs from home page.
// this page will show list of all objects just.


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../create new object page/upload_items_screen.dart';
import 'objectpage.dart';

class ObjectsListPage extends StatefulWidget {
  @override
  _ObjectsListPageState createState() => _ObjectsListPageState();
}

class _ObjectsListPageState extends State<ObjectsListPage> {
  Map<String, bool> favoritedItems = {}; // To track favorite objects
  List<String> notifications = []; // List to hold notifications

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // App bar
      appBar: AppBar(
        title: const Text(
          'Objects',
          style: TextStyle(
            fontFamily: 'Merienda',
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightBlue[800],
      ),
      body: Stack(
        children: [
          // Main Object List
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(10), // Outer margin for container
              padding: const EdgeInsets.symmetric(vertical: 10), // Padding inside the container
              decoration: BoxDecoration(
                color: Colors.white, // White background color
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Light shadow effect
                    spreadRadius: 4, // How much the shadow spreads
                    blurRadius: 10, // Blur strength of the shadow
                    offset: const Offset(0, 5), // Shadow offset
                  ),
                ],
                borderRadius: BorderRadius.circular(20), // Rounded corners for the container
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('objects').snapshots(), // Listening to Firestore data changes
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(), // Show loading indicator if no data is available
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length, // Get the number of documents from snapshot
                    itemBuilder: (context, index) {
                      var object = snapshot.data!.docs[index]; // Object from Firestore document
                      String objectId = object.id; // Get object ID
                      bool isFavorited = favoritedItems[objectId] ?? false; // Check if the object is favorited

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15), // Inner margin for each list item
                        padding: const EdgeInsets.all(10), // Padding inside each list item
                        decoration: BoxDecoration(
                          color: Colors.white, // White background for the item
                          borderRadius: BorderRadius.circular(20), // Rounded corners for each item
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3), // Slight shadow for items
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // Shadow offset for each item
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(15), // Rounded corners for the image
                            child: Image.network(
                              object['imageUrl'] ?? 'default_image_url_here', // Fallback URL if image URL is missing
                              fit: BoxFit.cover, // Cover the image area
                              width: 60, // Set image width
                              height: 60, // Set image height
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, color: Colors.red); // Show error icon if image fails to load
                              },
                            ),
                          ),
                          title: Text(
                            object['name'] ?? 'No Name', // Fallback for name if missing
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: "Merienda",
                            ),
                          ),
                          subtitle: Text(
                            object['type'] ?? 'Unknown Type', // Fallback for type if missing
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isFavorited ? Icons.favorite : Icons.favorite_border, // Toggle between filled and empty heart
                              color: isFavorited ? Colors.red : Colors.lightBlue[800],
                              size: 24,
                            ),
                            onPressed: () {
                              setState(() {
                                favoritedItems[objectId] = !isFavorited; // Toggle the favorite status
                              });

                              // Create a message indicating whether the object was added or removed from favorites
                              String message = favoritedItems[objectId]!
                                  ? '${object['name'] ?? 'No Name'} added to favorites'
                                  : '${object['name'] ?? 'No Name'} removed from favorites';

                              setState(() {
                                notifications.add(message); // Add the message to notifications
                              });

                              // Automatically remove the notification message after 3 seconds
                              Future.delayed(const Duration(seconds: 3), () {
                                setState(() {
                                  notifications.remove(message); // Remove notification after delay
                                });
                              });
                            },
                          ),
                          onTap: () {
                            // Navigate to the ObjectDetailPage with object details
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ObjectDetailPage(
                                  imageUrl: object['imageUrl'] ?? 'default_image_url_here', // Fallback for image URL
                                  name: object['name'] ?? 'No Name', // Fallback for name
                                  type: object['type'] ?? 'Unknown Type', // Fallback for type
                                  description: object['description'] ?? 'No Description Available', // Fallback for description
                                  documentId: object.id, // Pass the document ID
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),


          // Positioned Notifications in the upper right corner
          Positioned(
            top: 50,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: notifications.map((notification) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    notification,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ),

          // Add New Item Button
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemUpload()),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.lightBlue[800],
            ),
          ),
        ],

      ),
    );
  }
}


