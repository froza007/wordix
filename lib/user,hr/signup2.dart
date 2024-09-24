import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordix/user,hr/login1.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _selectedRole = 'user'; // Default role selection

  Future<void> _signup() async {
    if (_passwordController.text != _repeatPasswordController.text) {
      _showErrorDialog("Passwords do not match");
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Save user info and role to Firestore
      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'role': _selectedRole, // Use selected role ('user' or 'hr')
        });

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    } catch (e) {
      _showErrorDialog("Signup failed: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(hintText: "First Name"),
              ),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(hintText: "Last Name"),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(hintText: "Email"),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(hintText: "Password (8 characters)"),
                obscureText: true,
              ),
              TextField(
                controller: _repeatPasswordController,
                decoration: InputDecoration(hintText: "Repeat Password"),
                obscureText: true,
              ),
              SizedBox(height: 20),

              // Role Selection Dropdown
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: [
                  DropdownMenuItem(value: 'user', child: Text("User")),
                  DropdownMenuItem(value: 'hr', child: Text("HR Admin")),
                ],
                decoration: InputDecoration(labelText: "Select Role"),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signup,
                child: Text("Signup"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text("I already have an account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
