// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
//
// class FeedbackScreen extends StatefulWidget {
//   @override
//   _FeedbackScreenState createState() => _FeedbackScreenState();
// }
//
// class _FeedbackScreenState extends State<FeedbackScreen> {
//   double _rating = 4.0;
//   List<String> _selectedImprovements = [];
//   TextEditingController _feedbackController = TextEditingController();
//
//   final List<String> _improvementOptions = [
//     "AR Accuracy",
//     "3D Model Quality",
//     "Loading Speed",
//     "Furniture Variety",
//     "Room Scanning",
//   ];
//
//   Future<void> _submitFeedback() async {
//     final String feedback = _feedbackController.text;
//     final String selectedImprovements = _selectedImprovements.join(", ");
//
//     // Configure SMTP server
//     final smtpServer = gmail('shoaibaltaf1965@gmail.com', 'ouefqkleppxvlnkj');
//     final message = Message()
//       ..from = Address('shoaibaltaf1965@gmail.com', 'SketchUp App')
//       ..recipients.add('shoaibbloch48@gmail.com') // Add your email here
//       ..subject = 'User Feedback'
//       ..text = '''
// Rating: $_rating
// Improvements: $selectedImprovements
// Feedback: $feedback
// ''';
//
//     try {
//       await send(message, smtpServer);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Feedback submitted successfully!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error sending feedback: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.lightBlue[800],
//         elevation: 50,
//         title: const Text(
//           'FEED BACK',
//           style: TextStyle(
//             fontFamily: 'Kalam',
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Rate Your Experience",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             RatingBar.builder(
//               initialRating: _rating,
//               minRating: 1,
//               direction: Axis.horizontal,
//               allowHalfRating: true,
//               itemCount: 5,
//               itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//               itemBuilder: (context, _) => Icon(
//                 Icons.star,
//                 color: Colors.amber,
//               ),
//               onRatingUpdate: (rating) {
//                 setState(() {
//                   _rating = rating;
//                 });
//               },
//             ),
//             SizedBox(height: 16),
//             Text(
//               "Tell us what can be improved?",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             Wrap(
//               spacing: 7.0,
//               runSpacing: 7.0,
//               children: _improvementOptions.map((option) {
//                 final isSelected = _selectedImprovements.contains(option);
//                 return ChoiceChip(
//                   label: Text(option),
//                   selected: isSelected,
//                   onSelected: (selected) {
//                     setState(() {
//                       if (selected) {
//                         _selectedImprovements.add(option);
//                       } else {
//                         _selectedImprovements.remove(option);
//                       }
//                     });
//                   },
//                   selectedColor: Colors.lightBlue[800],
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _feedbackController,
//               decoration: InputDecoration(
//                 labelText: 'Tell us how we can improve...',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 4,
//             ),
//             SizedBox(height: 16),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () => _submitFeedback(),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.lightBlue[800], // Light-blue [800] button color
//                   padding: EdgeInsets.symmetric(vertical: 15,horizontal: 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: Text(
//                   "Submit Feedback",
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:onborading_screen/Home%20Page/homepage.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double _rating = 4.0;
  List<String> _selectedImprovements = [];
  TextEditingController _feedbackController = TextEditingController();

  final List<String> _improvementOptions = [
    "AR Accuracy",
    "3D Model Quality",
    "Loading Speed",
    "Furniture Variety",
    "Room Scanning",
  ];

  Future<void> _submitFeedback() async {
    final String feedback = _feedbackController.text;
    final String selectedImprovements = _selectedImprovements.join(", ");

    // Configure SMTP server
    final smtpServer = gmail('shoaibaltaf1965@gmail.com', 'ouefqkleppxvlnkj');
    final message = Message()
      ..from = Address('shoaibaltaf1965@gmail.com', 'SketchUp App')
      ..recipients.add('shoaibbloch48@gmail.com') // Add your email here
      ..subject = 'User Feedback'
      ..text = '''
Rating: $_rating
Improvements: $selectedImprovements
Feedback: $feedback
''' ;

    try {
      await send(message, smtpServer);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending feedback: $e')),
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
          backgroundColor: Colors.lightBlue[800],
          elevation: 50,
          title: const Text(
            'FEED BACK',
            style: TextStyle(
              fontFamily: 'Kalam',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainHomePage()),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rate Your Experience",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              SizedBox(height: 16),
              Text(
                "Tell us what can be improved?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 7.0,
                runSpacing: 7.0,
                children: _improvementOptions.map((option) {
                  final isSelected = _selectedImprovements.contains(option);
                  return ChoiceChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedImprovements.add(option);
                        } else {
                          _selectedImprovements.remove(option);
                        }
                      });
                    },
                    selectedColor: Colors.lightBlue[800],
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  labelText: 'Tell us how we can improve...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () => _submitFeedback(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue[800], // Light-blue [800] button color
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Submit Feedback",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
