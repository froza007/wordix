import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(PasswordResetApp());
}

class PasswordResetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Reset',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PasswordResetPage(),
    );
  }
}

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  String token = 'your-reset-token'; // Replace with actual token
  bool isLoading = false;

  // Validate the password: at least 8 chars, 1 uppercase, 1 special char
  bool validatePassword(String password) {
    bool hasUpperCase = password.contains(new RegExp(r'[A-Z]'));
    bool hasSpecialCharacter = password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length >= 8;

    return hasUpperCase && hasSpecialCharacter && hasMinLength;
  }

  // Send request to reset password
  Future<void> resetPassword(String token, String newPassword) async {
    setState(() {
      isLoading = true;
    });

    final String url = 'https://yourapi.com/reset-password'; // Replace with your API endpoint

    Map<String, String> body = {
      'token': token,
      'newPassword': newPassword
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset successful.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset password. Please try again.')),
      );
    }
  }

  void attemptPasswordReset() {
    if (_formKey.currentState!.validate()) {
      String newPassword = _passwordController.text;
      resetPassword(token, newPassword);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password does not meet the criteria.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
                validator: (value) {
                  if (value == null || !validatePassword(value)) {
                    return 'Password must be 8 chars long, contain 1 uppercase, and 1 special char.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : attemptPasswordReset,
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}