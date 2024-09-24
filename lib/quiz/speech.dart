// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'dart:math'; // Import for random number generation
import 'package:wordix/quiz/MainMenu.dart';

class ListOfQuestions {
  List<String> questions = [
    "He said, 'I am going to the market.'",
    "She said, 'I will call you later.'",
    "They said, 'We are playing football.'",
    "John said, 'I have finished my homework.'",
    "Mary said, 'I can swim well.'",
    "He asked, 'Are you coming with us?'",
    "She said, 'I was watching a movie.'",
    "They said, 'We have been waiting for an hour.'",
    "Tom said, 'I like ice cream.'",
    "She said, 'I am reading a book.'",
    "He said, 'I will help you tomorrow.'",
    "They said, 'We went to the park yesterday.'",
    "He said, 'She is my best friend.'",
    "She said, 'I am feeling sick.'",
    "They said, 'We have finished the project.'",
    "He said, 'I might visit you next week.'",
    "She asked, 'Where is the nearest station?'",
    "He said, 'I would like to go home.'",
    "They said, 'We are having a great time.'",
    "She said, 'I wish I could fly.'",
    "He said, 'It is raining outside.'",
    "They said, 'We will finish this by tomorrow.'",
    "He said, 'I am learning Flutter.'",
    "She said, 'I need your help.'",
    "They said, 'We will be there soon.'",
    "He said, 'I enjoy listening to music.'",
    "She said, 'I have a great idea.'",
    "He said, 'We are working hard.'",
    "They said, 'I want to go home.'",
    "She said, 'I love this song.'",
    "He asked, 'Will you join us for dinner?'",
    "They said, 'I had a wonderful time.'",
    "She said, 'I can solve this problem.'",
    "He said, 'We are excited about the trip.'",
    "They asked, 'When will the meeting start?'",
  ];

  List<String> correctAnswers = [
    "He said that he was going to the market.",
    "She said that she would call me later.",
    "They said that they were playing football.",
    "John said that he had finished his homework.",
    "Mary said that she could swim well.",
    "He asked if I was coming with them.",
    "She said that she had been watching a movie.",
    "They said that they had been waiting for an hour.",
    "Tom said that he liked ice cream.",
    "She said that she was reading a book.",
    "He said that he would help me the next day.",
    "They said that they had gone to the park the day before.",
    "He said that she was his best friend.",
    "She said that she was feeling sick.",
    "They said that they had finished the project.",
    "He said that he might visit me the following week.",
    "She asked where the nearest station was.",
    "He said that he would like to go home.",
    "They said that they were having a great time.",
    "She said that she wished she could fly.",
    "He said that it was raining outside.",
    "They said that they would finish this by the next day.",
    "He said that he was learning Flutter.",
    "She said that she needed my help.",
    "They said that they would be there soon.",
    "He said that he enjoyed listening to music.",
    "She said that she had a great idea.",
    "He said that they were working hard.",
    "They said that he wanted to go home.",
    "She said that she loved that song.",
    "He asked if I would join them for dinner.",
    "They said that they had a wonderful time.",
    "She said that she could solve that problem.",
    "He said that they were excited about the trip.",
    "They asked when the meeting would start.",
  ];
}

var finalScore = 0;
var questionNumber = 0;
var quiz = ListOfQuestions();
List<int> selectedQuestions = [];

class SpeechTransformationQuiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SpeechTransformationQuizState();
  }
}

class _SpeechTransformationQuizState extends State<SpeechTransformationQuiz> {
  final TextEditingController _answerController = TextEditingController();
  String? correctAnswer;
  bool answerSubmitted = false;

  @override
  void initState() {
    super.initState();
    selectRandomQuestions();
  }

  void selectRandomQuestions() {
    final Random random = Random();
    while (selectedQuestions.length < 5) {
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
          title: Text("Speech Transformation Quiz"),
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
                if (answerSubmitted)
                  Text(
                    "Correct answer: $correctAnswer",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                SizedBox(height: 20),
                Text(
                  "Score: $finalScore",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    updateQuestion();
                  },
                  child: Text("Next"),
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
    setState(() {
      correctAnswer = quiz.correctAnswers[selectedQuestions[questionNumber]];
      if (value.trim().toLowerCase() == correctAnswer!.toLowerCase()) {
        finalScore++;
      }
      answerSubmitted = true; 
    });
  }

  void updateQuestion() {
    setState(() {
      if (questionNumber < selectedQuestions.length - 1) {
        questionNumber++; 
        _answerController.clear();
        answerSubmitted = false;
        correctAnswer = null; 
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Summary(score: finalScore)),
        );
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
                  score >= 3 ? 'assets/good.png' : 'assets/sad.png',
                  height: score >= 3 ? 145 : 250,
                ),
                SizedBox(height: 20),
                Text(
                  score >= 3 ? "Good Job" : "Nice try",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.0, color: score >= 3 ? Colors.green : Colors.red),
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
                    selectedQuestions.clear(); 
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
