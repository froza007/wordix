import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HrDashboard extends StatelessWidget {
  // Function to fetch user login data from Firestore
  Future<Map<String, dynamic>> fetchUserLoginData() async {
    CollectionReference loginActivity =
        FirebaseFirestore.instance.collection('user_login_activity');

    // Fetch data from Firestore
    QuerySnapshot querySnapshot = await loginActivity.get();

    // Convert documents into a map for easier use
    Map<String, dynamic> loginData = {};
    querySnapshot.docs.forEach((doc) {
      loginData[doc.id] = doc.data();
    });

    return loginData;
  }

  // Function to delete a user from Firestore and Firebase Authentication
  Future<void> removeUser(String uid) async {
    // Remove the user data from Firestore
    await FirebaseFirestore.instance.collection('user_login_activity').doc(uid).delete();

    // Remove the user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HR Dashboard"),
        backgroundColor: Colors.blue[900], // Dark blue theme for the AppBar
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserLoginData(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show a loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); // Show error if something goes wrong
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No login activity data available")); // No data found
          } else {
            Map<String, dynamic> loginData = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0), // Padding around the content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "User Activity Analysis",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: loginData.length,
                      itemBuilder: (context, index) {
                        String uid = loginData.keys.elementAt(index);
                        Map<String, dynamic> userData = loginData[uid];

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10), // Add spacing between cards
                          color: Colors.blue[50], // Light blue background for the card
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Rounded corners for cards
                          ),
                          child: ListTile(
                            title: Text(
                              "User ID: $uid",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Login Time: ${userData['login_time']}\nSession Duration: ${userData['session_duration']}",
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red), // Red delete icon
                              onPressed: () async {
                                bool confirmDelete = await _confirmDeletionDialog(context);

                                if (confirmDelete) {
                                  // Remove user if confirmed
                                  await removeUser(uid);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("User $uid removed successfully"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Dialog to confirm deletion of the user
  Future<bool> _confirmDeletionDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete User"),
          content: Text("Are you sure you want to remove this user?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false on cancel
              },
            ),
            ElevatedButton(
              child: Text("Delete"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red button for deletion
              ),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true on confirmation
              },
            ),
          ],
        );
      },
    );
  }
}
