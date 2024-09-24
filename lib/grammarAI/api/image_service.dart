import 'package:flutter/material.dart';
import 'package:wordix/grammarAI/api/image_api.dart';

class ImageService extends StatelessWidget {
  final String? question;

  const ImageService({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    if (question == '') {
      return const Center(
        child: Text(
          'The image will appear here...',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        ),
      );
    } else {
      return FutureBuilder(
        future: ImageApi().generateImage(imageName: question!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Text('Erorr');
          }
        },
      );
    }
  }
}
