// this page is triggered from home page when user pressed on image of designs then this page will open,
// this page will show images in index and having description calling from home page and  botton to move object list page

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../objects detail page/objectlistpage.dart';


class DetailPage extends StatefulWidget {
  final String title; // Title of the page (object name)
  final List<String> imageUrls; // List of image URLs to be displayed in carousel
  final String description; // Description of the object

  const DetailPage({
    Key? key,
    required this.title, // Constructor requires a title, image URLs, and description
    required this.imageUrls,
    required this.description,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _currentIndex = 0; // Tracks the current image in the PageView carousel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[800], // Set the AppBar background color
        title: Text(
          widget.title, // Display the title passed from the constructor
          style: const TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontFamily: "poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back button to navigate to the previous screen
          onPressed: () {
            Navigator.pop(context); // Pop the current screen off the stack (go back)
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left
            children: [
              SizedBox(
                height: 10, // Adjust spacing between AppBar and image carousel
              ),
              // Image carousel with PageView to swipe through images
              Container(
                height: 280, // Set fixed height for the image carousel
                child: PageView.builder(
                  itemCount: widget.imageUrls.length, // Number of images to display
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index; // Update the current image index
                    });
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30), // Rounded corners for each image container
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26, // Subtle shadow effect
                            offset: Offset(0, 6), // Shadow offset
                            blurRadius: 15, // Shadow blur radius
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30), // Clip the image to match the rounded container
                        child: Image.asset(
                          widget.imageUrls[index], // Get the image URL from the list
                          fit: BoxFit.cover, // Ensure the image covers the container
                          width: double.infinity, // Make the image width fill the container
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              // Dots indicator for the image carousel, showing the current image number
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imageUrls.length, // Generate dots for each image
                      (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.lightBlue[800] // Highlight the current image with a blue dot
                          : Colors.grey[300], // Use grey for non-selected dots
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Description section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.description, // Display the description passed from the constructor
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontFamily: "Merienda",
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Design Now button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 37.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 100), // Adjust padding for the button
                    backgroundColor: Colors.lightBlue[800], // Set button color
                    elevation: 10, // Add elevation for a 3D effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Rounded corners for button
                    ),
                  ),
                  onPressed: () {
                    // Navigate to ObjectsListPage when the button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ObjectsListPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Design Now', // Button label
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: "poppins",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

