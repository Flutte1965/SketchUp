import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../objects detail page/objectpage.dart';

class FavoriteObjectsPage extends StatefulWidget {
  final Map<String, bool> favoritedItems;
  final List<QueryDocumentSnapshot> objects;

  FavoriteObjectsPage({required this.favoritedItems, required this.objects});

  @override
  _FavoriteObjectsPageState createState() => _FavoriteObjectsPageState();
}

class _FavoriteObjectsPageState extends State<FavoriteObjectsPage> {
  late Map<String, bool> favoritedItems;
  late List<QueryDocumentSnapshot> favoriteObjects;

  @override
  void initState() {
    super.initState();
    // Initialize with the data passed from the parent widget
    favoritedItems = Map.from(widget.favoritedItems);
    favoriteObjects = widget.objects.where((object) {
      return favoritedItems[object.id] == true;
    }).toList();
  }

  void _toggleFavorite(String objectId) {
    setState(() {
      // Update the favoritedItems map
      favoritedItems[objectId] = !(favoritedItems[objectId] ?? false);

      // Refresh the favoriteObjects list
      favoriteObjects = widget.objects.where((object) {
        return favoritedItems[object.id] == true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Objects List', style: TextStyle(fontFamily: "Merienda")),
        backgroundColor: Colors.lightBlue[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the home page
          },
        ),
      ),
      body: favoriteObjects.isEmpty
          ? Center(
        child: Text(
          "No favorite items",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: favoriteObjects.length,
        itemBuilder: (context, index) {
          var object = favoriteObjects[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ObjectDetailPage(
                    imageUrl: object['imageUrl'],
                    name: object['name'],
                    type: object['type'],
                    description: object['description'],
                    documentId: object.id, // Pass the Firestore document ID
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  // Top-left shadow
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(-4, -4),
                  ),
                  // Bottom-right shadow
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: ListTile(
                leading: ClipOval(
                  child: Image.network(
                    object['imageUrl'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  object['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(object['type']),
                trailing: IconButton(
                  icon: Icon(
                    favoritedItems[object.id] == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: favoritedItems[object.id] == true
                        ? Colors.red
                        : Colors.grey,
                  ),
                  onPressed: () => _toggleFavorite(object.id),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
