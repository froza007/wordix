// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'login_page.dart'; // Import the LoginPage

// class SignUpPage extends StatefulWidget {
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Function to handle the Sign Up
//   Future<void> _signUp() async {
//     // Check if passwords match
//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Passwords do not match!'),
//       ));
//       return;
//     }

//     try {
//       // Try to create the user in Firebase Authentication
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );

//       // Save user details to Firestore after successful registration
//       await _firestore.collection('users').doc(userCredential.user?.uid).set({
//         'full_name': _nameController.text,
//         'email': _emailController.text,
//         'created_at': DateTime.now(),
//       });

//       // Notify the user of successful registration
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Sign Up Successful'),
//       ));

//       // Clear input fields after successful sign-up
//       _nameController.clear();
//       _emailController.clear();
//       _passwordController.clear();
//       _confirmPasswordController.clear();

//       // Redirect to login page
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginPage()),
//       );
//     } on FirebaseAuthException catch (e) {
//       // Handle specific Firebase errors
//       if (e.code == 'email-already-in-use') {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('The email address is already in use by another account.'),
//         ));
//       } else if (e.code == 'weak-password') {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('The password provided is too weak.'),
//         ));
//       } else if (e.code == 'invalid-email') {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('The email address is not valid.'),
//         ));
//       } else {
//         // General error
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Error: ${e.message}'),
//         ));
//       }
//     } catch (e) {
//       // This catch block will now only handle unknown errors
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('An unknown error occurred: ${e.toString()}'),
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: 50),
//               Text(
//                 'Sign up',
//                 style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 24),
//               TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Full Name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Create a password',
//                   border: OutlineInputBorder(),
//                   hintText: 'must be 8 characters',
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 controller: _confirmPasswordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Confirm password',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _signUp,
//                 child: Text('Sign up'),
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'Or Register with',
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 16),
//               // Add social login buttons here (Facebook, Google, etc.)
//               SizedBox(height: 24),
//               TextButton(
//                 onPressed: () {
//                   // Navigate to the login page
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginPage()), // This navigates to LoginPage
//                   );
//                 },
//                 child: Text('Already have an account? Log in'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
