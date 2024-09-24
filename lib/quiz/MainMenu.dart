import 'package:flutter/material.dart';
import 'package:wordix/quiz/fillups.dart';
import 'multiple_choice.dart'; // Import your other pages
import 'word_match.dart';
import 'speech.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      routes: {
        '/': (context) => Scaffold(
          appBar: AppBar(
            title: Text("Main Menu"),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "LANGUAGE TRAINING TEST",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/multiple_choice');
                    },
                    child: Text(
                      "MULTIPLE CHOICE",
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, fixedSize: const Size(350, 50), // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/fillups');
                    },
                    child: Text(
                      "FILL IN THE BLANKS",
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, fixedSize: const Size(350, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/guess_pic');
                    },
                    child: Text(
                      "SPEECH TRANSFORM",
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, fixedSize: const Size(350, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        '/multiple_choice': (context) => MultipleChoiceTest(),
        '/fillups': (context) => fillups(),
        '/guess_pic': (context) => SpeechTransformationQuiz(),
      },
    );
  }
}
