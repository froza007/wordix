import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wordix/forgot_password_page.dart';
import 'package:wordix/homepage.dart';
import 'package:wordix/user,hr/signup2.dart';
import 'hr_dashboard.dart';
import 'package:intl/intl.dart'; // For formatting login time
import 'dart:async'; // For handling session duration

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isHrAdmin = false;
  Timer? _sessionTimer;
  DateTime? _loginTime;
  Duration _sessionDuration = Duration.zero;

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        final role = await getUserRole(user.uid);

        _loginTime = DateTime.now();
        startSessionTimer();

        await addLoginDataToFirestore(user.uid);

        if (_isHrAdmin && role == 'hr') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HrDashboard()));
        } else if (!_isHrAdmin && role == 'user') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          _showErrorDialog("Invalid role for selected login type.");
        }
      }
    } catch (e) {
      _showErrorDialog("Login failed: $e");
    }
  }

  Future<void> addLoginDataToFirestore(String uid) async {
    String formattedLoginTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(_loginTime!);
    CollectionReference loginActivity =
        FirebaseFirestore.instance.collection('user_login_activity');

    await loginActivity.doc(uid).set({
      'login_time': formattedLoginTime,
      'session_duration': '0 mins',
    });
  }

  Future<String> getUserRole(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data()?['role'] ?? 'user';
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

  void startSessionTimer() {
    _sessionTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _sessionDuration = _sessionDuration + Duration(minutes: 1);
      });
    });
  }

  Future<void> stopSessionTimer(String uid) async {
    _sessionTimer?.cancel();
    CollectionReference loginActivity =
        FirebaseFirestore.instance.collection('user_login_activity');

    String sessionDurationString = '${_sessionDuration.inMinutes} mins';

    await loginActivity.doc(uid).update({
      'session_duration': sessionDurationString,
    });
  }

  @override
  void dispose() {
    if (_auth.currentUser != null) {
      stopSessionTimer(_auth.currentUser!.uid);
    }
    _sessionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App name "WORDIX"
            Text(
              "WORDIX",
              style: TextStyle(
                fontSize: 59, // Adjust the font size as needed
                fontWeight: FontWeight.bold, // Makes the text bold
                color: Colors.black, // You can change the color if needed
              ),
            ),
            SizedBox(height: 40), // Spacing between title and email field

            // Email TextField
            TextField(
              controller: _emailController,
              decoration: InputDecoration(hintText: "Email"),
            ),
            SizedBox(height: 20), // Spacing between email and password fields

            // Password TextField
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(hintText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20), // Spacing before buttons

            // Login Type buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isHrAdmin = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isHrAdmin ? Colors.grey : Colors.blue,
                  ),
                  child: Text("User Login"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isHrAdmin = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isHrAdmin ? Colors.blue : Colors.grey,
                  ),
                  child: Text("HR Admin Login"),
                ),
              ],
            ),
            SizedBox(height: 20), // Spacing before login button

            // Login Button
            ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignupPage()));
              },
              child: Text("I don't have an account"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage()));
              },
              child: Text("Forgot Password?"),
            ),
          ],
        ),
      ),
    );
  }
}
