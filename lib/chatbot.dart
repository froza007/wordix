import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InterviewBot extends StatefulWidget {
  const InterviewBot({super.key});
  @override
  State<InterviewBot> createState() => _InterviewBotState();
}

class _InterviewBotState extends State<InterviewBot> {
  ChatUser myself = ChatUser(id: "1", firstName: "Candidate");
  ChatUser bot = ChatUser(id: "2", firstName: "InterviewBot");
  List<ChatMessage> allMessages = [];
  List<ChatUser> typing = [];

  final apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyAUArXoX540xziXvq5z4AlhIaeNGB9og6o";
  final headers = {'Content-Type': 'application/json'};

  // Method to generate dynamic interview questions from the bot
  generateInterviewQuestion() async {
    typing.add(bot);
    setState(() {});

    var questionRequest = {
      "contents": [
        {
          "parts": [
            {"text": "Generate an interview question."}
          ]
        }
      ]
    };

    await http
        .post(Uri.parse(apiUrl), headers: headers, body: jsonEncode(questionRequest))
        .then((response) {
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        String interviewQuestion = result["candidates"][0]["content"]["parts"][0]["text"];

        ChatMessage botQuestion = ChatMessage(
          user: bot,
          createdAt: DateTime.now(),
          text: interviewQuestion,
        );

        allMessages.insert(0, botQuestion);
      } else {
        print("Error occurred while generating the interview question.");
      }
    }).catchError((e) {
      print("Error: $e");
    });

    typing.remove(bot);
    setState(() {});
  }

  // Method to send user message and receive feedback
  getFeedback(ChatMessage userMessage) async {
    typing.add(bot);
    allMessages.insert(0, userMessage);
    setState(() {});

    var feedbackRequest = {
      "contents": [
        {
          "parts": [
            {"text": "Analyze this answer: ${userMessage.text}"}
          ]
        }
      ]
    };

    await http
        .post(Uri.parse(apiUrl), headers: headers, body: jsonEncode(feedbackRequest))
        .then((response) {
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        String feedback = result["candidates"][0]["content"]["parts"][0]["text"];

        ChatMessage botFeedback = ChatMessage(
          user: bot,
          createdAt: DateTime.now(),
          text: feedback,
        );

        allMessages.insert(0, botFeedback);

        // Generate a sample answer for the question
        generateSampleAnswer(userMessage.text);
      } else {
        print("Error occurred while getting feedback.");
      }
    }).catchError((e) {
      print("Error: $e");
    });

    typing.remove(bot);
    setState(() {});
  }

  // Method to generate a sample answer based on the user's question
  generateSampleAnswer(String userQuestion) async {
    var sampleRequest = {
      "contents": [
        {
          "parts": [
            {"text": "Provide a sample answer for the question: $userQuestion"}
          ]
        }
      ]
    };

    await http
        .post(Uri.parse(apiUrl), headers: headers, body: jsonEncode(sampleRequest))
        .then((response) {
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        String sampleAnswer = result["candidates"][0]["content"]["parts"][0]["text"];

        ChatMessage sampleMessage = ChatMessage(
          user: bot,
          createdAt: DateTime.now(),
          text: "Sample Answer: $sampleAnswer",
        );

        allMessages.insert(0, sampleMessage);
      } else {
        print("Error occurred while generating sample answer.");
      }
    }).catchError((e) {
      print("Error: $e");
    });

    // After providing feedback and sample answer, generate a new interview question
    generateInterviewQuestion();
  }

  @override
  void initState() {
    super.initState();
    // Start the conversation by asking the first interview question
    generateInterviewQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 35,
        centerTitle: true,
        title: const Text(
          'InterviewBot 🤖',
          style: TextStyle(color: Color.fromARGB(255, 94, 228, 243)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/chatclr.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: DashChat(
          messageOptions: MessageOptions(
            showTime: true,
            textColor: Colors.blue,
            containerColor: Colors.black,
          ),
          typingUsers: typing,
          currentUser: myself,
          onSend: (ChatMessage message) {
            getFeedback(message);
          },
          messages: allMessages,
        ),
      ),
    );
  }
}
