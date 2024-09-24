// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'dart:math'; // Import for random number generation
 // Import the ResultsPage for navigation

class ListOfQuestions {
  List<List<String>> answersList = [
    ["diligent", "lazy", "careless", "disorganized"],
    ["confident", "timid", "shy", "reserved"],
    ["articulate", "mumbled", "incoherent", "quiet"],
    ["proactive", "passive", "indifferent", "reactive"],
    ["empathetic", "cold", "uncaring", "indifferent"],
    ["assertive", "passive", "timid", "defensive"],
    ["meticulous", "careless", "hasty", "sloppy"],
    ["charismatic", "boring", "dull", "uninteresting"],
    ["resilient", "fragile", "weak", "delicate"],
    ["innovative", "traditional", "stale", "conventional"],
    ["collaborative", "isolated", "independent", "detached"],
    ["adaptable", "rigid", "inflexible", "stubborn"],
    ["organized", "chaotic", "disordered", "messy"],
    ["thoughtful", "careless", "impulsive", "reckless"],
    ["enthusiastic", "apathetic", "disinterested", "indifferent"],
  ];
  
  var questions = [
    "Which word describes someone who works hard?",
    "Which word describes someone who is not shy?",
    "Which word means able to express ideas clearly?",
    "Which word describes someone who takes initiative?",
    "Which word describes someone who shows understanding and compassion?",
    "Which word describes someone who is confident and direct?",
    "Which word describes someone who pays great attention to detail?",
    "Which word describes someone with a compelling charm?",
    "Which word describes someone who can recover quickly from difficulties?",
    "Which word describes someone who introduces new ideas?",
    "Which word describes someone who works well with others?",
    "Which word describes someone who can adjust to new conditions?",
    "Which word describes someone who keeps things in order?",
    "Which word describes someone who considers the needs of others?",
    "Which word describes someone who shows excitement and interest?",
  ];
  
  var correctAnswers = [
    "diligent", "confident", "articulate", "proactive", "empathetic",
    "assertive", "meticulous", "charismatic", "resilient", "innovative",
    "collaborative", "adaptable", "organized", "thoughtful", "enthusiastic"
  ];
}

var finalScore = 0;
var questionNumber = 0;
var quiz = ListOfQuestions();
List<int> selectedQuestions = []; // Store selected question indices

class MultipleChoiceTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MultipleChoiceTestState();
  }
}

class _MultipleChoiceTestState extends State<MultipleChoiceTest> {
  @override
  void initState() {
    super.initState();
    selectRandomQuestions();
  }

  void selectRandomQuestions() {
    final Random random = Random();
    while (selectedQuestions.length < 10) {
      int index = random.nextInt(quiz.questions.length);
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
                ...List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (quiz.answersList[selectedQuestions[questionNumber]][index] ==
                            quiz.correctAnswers[selectedQuestions[questionNumber]]) {
                          finalScore++;
                        }
                        updateQuestion();
                      },
                      child: Text(
                        "${String.fromCharCode(65 + index)}. ${quiz.answersList[selectedQuestions[questionNumber]][index]}",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        fixedSize: Size(350, 50),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 40),
                Text(
                  "Score: $finalScore",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                )
              ],
            ),
          ),
        ),
      ),
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
    );
  }

  void updateQuestion() {
    setState(() {
      if (questionNumber == 4) {
        // Navigate to the ResultsPage and pass the finalScore
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPage(assessment1Results: finalScore),
          ),
        );
      } else {
        questionNumber++;
      }
    });
  }
}

class ResultsPage extends StatelessWidget {
  final int assessment1Results;

  ResultsPage({required this.assessment1Results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Results'),
      ),
      body: Center(
        child: Text('Assessment 1 Score: $assessment1Results'),
      ),
    );
  }
}