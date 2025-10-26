import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/my_back_button.dart';

class UserPage extends StatelessWidget {

  final DocumentSnapshot userSnapshot;


  UserPage({super.key, required this.userSnapshot});
  final TextEditingController questionController = TextEditingController();

  String _getField(String field) {
    return (userSnapshot.data() as Map<String, dynamic>?)?[field] ?? 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

    final String username = userData?['username'] ?? 'N/A';
    final String greeting = userData?['greeting'] ?? 'N/A';
    final String upto = userData?['upto'] ?? 'N/A';
    final String question = userData?['question'] ?? 'N/A';
    final String pfpImage = userData?['pfpimage'] ?? '';
    final String uptoImage = userData?['uptoimage'] ?? '';

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, left: 0),
                  child: Row(children: [MyBackButton()]),
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.center,
                  child: Text(
                    username,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Stack(
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(pfpImage),
                    ),
                  ],
                ),
                const SizedBox(height: 24),



                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Greeting",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 400,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFFc6b3ef),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // Add the alignment property to center the child (the Text widget)
                      alignment: Alignment.center,
                      child: Text(
                        greeting,
                        textAlign: TextAlign.center, // Ensure multi-line text is centered horizontally too
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "What I've Been Up To",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    uptoImage,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Column(
                  children: [
                    const SizedBox(height: 4),
                    Container(
                      width: 400,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFFc6b3ef),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // Add the alignment property to center the child (the Text widget)
                      alignment: Alignment.center,
                      child: Text(
                        upto,
                        textAlign: TextAlign.center, // Ensure multi-line text is centered horizontally too
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.center,
                  child: Text(
                    question,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: questionController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'What do you want to ask everyone?',
                          contentPadding: EdgeInsets.all(10)),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}