// // import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
// import 'forgot_password_page.dart';
// import 'signup_page.dart';
// import 'homepage.dart'; // Import HomePage

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

//   Future<void> _signInWithEmailPassword() async {
//     try {
//       final String email = _emailController.text.trim();
//       final String password = _passwordController.text.trim();

//       // Sign in the user using Firebase Authentication
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Fetch the signed-in user
//       User? user = userCredential.user;

//       // Check if the user is null (which should not happen unless login fails)
//       if (user != null) {
//         // Check if user data exists in Firestore
//         DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        
//         if (userDoc.exists) {
//           print("User data found in Firestore: ${userDoc.data()}");
//         } else {
//           // If user doesn't exist in Firestore, create new user data
//           await _firestore.collection('users').doc(user.uid).set({
//             'email': user.email,
//             'createdAt': DateTime.now(),
//           });
//           print("New user created in Firestore");
//         }

//         // Redirect to HomePage after successful login
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       // Handle specific FirebaseAuth error codes
//       if (e.code == 'user-not-found') {
//         _showErrorSnackBar('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         _showErrorSnackBar('Wrong password provided.');
//       } else {
//         _showErrorSnackBar('Login failed: ${e.message}');
//       }
//     } catch (e) {
//       _showErrorSnackBar('An error occurred: ${e.toString()}');
//     }
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Log in',
//               style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 24),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email address',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//                 suffixIcon: Icon(Icons.visibility_off),
//               ),
//             ),
//             SizedBox(height: 16),
//             Align(
//               alignment: Alignment.centerRight,
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
//                   );
//                 },
//                 child: Text('Forgot password?'),
//               ),
//             ),
//             SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _signInWithEmailPassword,
//               child: Text('Log in'),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
//               ),
//             ),
//             SizedBox(height: 16),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SignUpPage()), // Navigate to SignUpPage
//                 );
//               },
//               child: Text(
//                 "Don't have an account? Sign up",
//                 style: TextStyle(
//                     color: Colors.blue, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }