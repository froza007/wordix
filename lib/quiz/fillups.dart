// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'dart:math'; // Import for random number generation
import 'package:wordix/quiz/MainMenu.dart';

class ListOfQuestions {
  List<String> questions = [
    "She __________ her homework before dinner.",
    "They __________ to the concert last night.",
    "He always __________ a book before bed.",
    "We __________ the project on time.",
    "I usually __________ breakfast at 7 AM.",
    "__________ is my favorite movie?",
    "This gift is for __________.",
    "__________ took the last cookie?",
    "The dog wagged its tail because __________ was happy.",
    "The teacher gave the students __________ assignments.",
    "She __________ to the gym every morning.",
    "They __________ a picnic last weekend.",
    "He __________ his presentation right now.",
    "I __________ my keys yesterday.",
    "We __________ to the beach tomorrow.",
    "The cake was very __________.",
    "She wore a __________ dress to the party.",
    "The weather is quite __________ today.",
    "He is a __________ student who studies hard.",
    "This puzzle is very __________.",
    "She sings __________ at the concert.",
    "He runs __________ than anyone else.",
    "They completed the task __________.",
    "She speaks __________ in public.",
    "The children played __________ in the park.",
    "I will __________ a letter to my friend.",
    "He __________ his lunch at home today.",
    "They __________ to finish the work early.",
    "She __________ a great job on her report.",
    "We __________ a movie last night.",
    "__________ are you going to invite to the party?",
    "This is the house __________ we grew up.",
    "__________ car is parked outside?",
    "The students finished __________ project early.",
    "Everyone should bring __________ own lunch.",
    "He __________ finished his homework.",
    "She __________ on the phone right now.",
    "They __________ excited about the trip.",
    "I __________ my favorite song yesterday.",
    "We __________ dinner when the phone rang.",
  ];

  List<String> correctAnswers = [
    "finished", "went", "reads", "completed", "eat",
    "What", "you", "Who", "it", "their",
    "goes", "had", "is preparing", "lost", "are going",
    "delicious", "beautiful", "nice", "diligent", "challenging",
    "beautifully", "faster", "quickly", "confidently", "happily",
    "write", "forgot", "decided", "did", "watched",
    "Who", "where", "Whose", "their", "their",
    "has", "is talking", "are", "heard", "were having",
  ];

  List<List<String>> choices = [
    ["finished", "completed"],
    ["went", "went to"],
    ["reads", "wrote"],
    ["completed", "did"],
    ["eat", "eat breakfast"],
    ["What", "Which"],
    ["you", "me"],
    ["Who", "What"],
    ["it", "they"],
    ["their", "my"],
    ["goes", "walks"],
    ["had", "did"],
    ["is preparing", "is presenting"],
    ["lost", "found"],
    ["are going", "will go"],
    ["delicious", "sweet"],
    ["beautiful", "pretty"],
    ["nice", "good"],
    ["diligent", "smart"],
    ["challenging", "difficult"],
    ["beautifully", "well"],
    ["faster", "more quickly"],
    ["quickly", "slowly"],
    ["confidently", "happily"],
    ["happily", "sadly"],
    ["write", "send"],
    ["forgot", "left"],
    ["decided", "chose"],
    ["did", "completed"],
    ["watched", "saw"],
    ["Who", "What"],
    ["where", "when"],
    ["Whose", "Who's"],
    ["their", "your"],
    ["their", "your"],
    ["has", "is"],
    ["is talking", "is speaking"],
    ["are", "were"],
    ["heard", "listened"],
    ["were having", "were eating"],
  ];
}

var finalScore = 0;
var questionNumber = 0;
var quiz = ListOfQuestions();
List<int> selectedQuestions = []; // Store selected question indices

class fillups extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FillUpsState();
  }
}

class _FillUpsState extends State<fillups> {
  final TextEditingController _answerController = TextEditingController();
  String? feedback;

  @override
  void initState() {
    super.initState();
    selectRandomQuestions();
  }

  void selectRandomQuestions() {
    final Random random = Random();
    while (selectedQuestions.length < 10) {
      int index = random.nextInt(40); // Total number of questions
      if (!selectedQuestions.contains(index)) {
        selectedQuestions.add(index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Vocabulary Practice Test"),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  quiz.questions[selectedQuestions[questionNumber]],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                TextField(
                  controller: _answerController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Your answer',
                  ),
                  onSubmitted: (value) {
                    checkAnswer(value);
                  },
                ),
                SizedBox(height: 20),
                if (feedback != null) 
                  Text(
                    feedback!,
                    style: TextStyle(
                      fontSize: 20,
                      color: feedback == "Correct!" ? Colors.green : Colors.red,
                    ),
                  ),
                SizedBox(height: 20),
                Text(
                  "Choices: ${quiz.choices[selectedQuestions[questionNumber]].join(' or ')}",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 40),
                Text(
                  "Score: $finalScore",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
    );
  }

  void checkAnswer(String value) {
    String correctAnswer = quiz.correctAnswers[selectedQuestions[questionNumber]];
    if (value.toLowerCase() == correctAnswer) {
      finalScore++;
      feedback = "Correct!";
    } else {
      feedback = "Incorrect! The correct answer is: $correctAnswer";
    }
    updateQuestion();
  }

  void updateQuestion() {
    setState(() {
      _answerController.clear(); // Clear the input field
      if (questionNumber == 9) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Summary(score: finalScore)),
        );
      } else {
        questionNumber++;
        feedback = null; // Reset feedback for the next question
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
          title: Text("Summary"),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  score >= 7 ? 'assets/good.png' : 'assets/sad.png',
                  height: score >= 7 ? 145 : 250,
                ),
                SizedBox(height: 20),
                Text(
                  score >= 7 ? "Good Job" : "Nice try",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.0, color: score >= 7 ? Colors.green : Colors.red),
                ),
                SizedBox(height: 30),
                Text(
                  "Final Score: $score",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(300, 50),
                  ),
                  onPressed: () {
                    questionNumber = 0;
                    finalScore = 0;
                    selectedQuestions.clear(); // Clear selected questions
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainMenu()),
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
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
    );
  }
}
