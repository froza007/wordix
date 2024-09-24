// ignore_for_file: prefer_const_constructors, unnecessary_new, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'MainMenu.dart';

var finalScore = 0;
var questionNumber = 0;
var quiz = CocokKata();
String userAnswer = " ";

class CocokKata {
  var question = [
    "The dog barks",
    "I ate a sandwich",
    "The baby cried",
    "Tomy rides his bike",
    "I hear the rain"
  ];

  var corrAnswer = [
    "The dog barks ",
    "I ate a sandwich ",
    "The baby cried ",
    "Tomy rides his bike ",
    "I hear the rain "
  ];
}

class MalingCocok extends StatefulWidget {
  const MalingCocok({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MalingCocokState();
  }
}

class _MalingCocokState extends State<MalingCocok> {
  String nAnswer = "";
  
  @override
  Widget build(BuildContext context) {
    var txt = TextEditingController();
    String question = quiz.question[questionNumber];
    List<String> l = question.split(' ');
    l.shuffle();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("WORD MATCH"),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Arrange the words below according to correct grammar!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  width: 350,
                  child: TextFormField(
                    controller: txt,
                    enabled: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Your answer will be displayed here',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ...l.map((word) => Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    minWidth: 200,
                    height: 50,
                    color: Colors.blue,
                    onPressed: () {
                      txt.text += word + " ";
                    },
                    child: Text(
                      word,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    txt.clear();
                  },
                  child: Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    backgroundColor: Colors.green,
                    fixedSize: Size(200, 50),
                  ),
                  onPressed: () {
                    setState(() {
                      nAnswer = txt.text;
                    });
                    if (txt.text.trim() == quiz.corrAnswer[questionNumber].trim()) {
                      print("Correct");
                      finalScore++;
                    } else {
                      print("Wrong");
                    }
                    txt.clear();
                    updateQuestion();
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "Score: $finalScore",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  void updateQuestion() {
    setState(() {
      if (questionNumber == quiz.question.length - 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Summary(score: finalScore),
          ),
        );
      } else {
        questionNumber++;
      }
    });
  }
}

class Summary extends StatelessWidget {
  final int score;

  Summary({Key? key, required this.score}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Cocok Kata"),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  score >= 3 ? 'assets/good.png' : 'assets/sad.png',
                  height: score >= 3 ? 145 : 250,
                ),
                SizedBox(height: 20),
                Text(
                  score >= 3 ? "Good Job" : "Nice try",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0,
                    color: score >= 3 ? Colors.green : Colors.red,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Final Score: $score",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
                SizedBox(height: 30),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minWidth: 300,
                  height: 50,
                  color: Colors.blue,
                  onPressed: () {
                    questionNumber = 0;
                    finalScore = 0;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainMenu()),
                    );
                  },
                  child: Text(
                    "Back to Main Menu",
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
