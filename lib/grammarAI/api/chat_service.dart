
import 'package:flutter/material.dart';
import 'package:wordix/grammarAI/api/gemini_APi.dart';

class ChatService extends StatelessWidget {
  final String? question;

  const ChatService({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    if (question == '') {
      return const Center(
        child: Text(
          'Here the response will appear...',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        ),
      );
    } else {
      return FutureBuilder<String>(
        future: GeminiApi().getTextFromAi(q: question!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(children: [
              Text(
                snapshot.data!,
                softWrap: true,
              ),
            ]);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Text(
              'Wait...',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ));
          } else {
            return const Text('Erorr');
          }
        },
      );
    }
  }
}
