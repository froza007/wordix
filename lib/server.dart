import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

class AudioData {
  final String audio;

  AudioData(this.audio);

  static AudioData fromJson(Map<String, dynamic> json) {
    return AudioData(json['audio']);
  }
}

Map<String, dynamic> analyzeAudio(String audioData) {
  // Dummy analysis (replace with actual model inference)
  return {
    "response": "Your answer is concise and covers the main points.",
    "feedback": "Consider adding more examples for clarity."
  };
}

void main() async {
  final router = Router();

  // Define the POST route for analyzing responses
  router.post('/analyze_response', (Request request) async {
    try {
      String content = await request.readAsString();
      Map<String, dynamic> jsonData = jsonDecode(content);
      if (!jsonData.containsKey('audio')) {
        return Response(
          HttpStatus.badRequest,
          body: jsonEncode({"error": "No audio data provided"}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      // Analyze audio data (replace with actual analysis)
      var analysisResult = analyzeAudio(jsonData['audio']);
      return Response.ok(
        jsonEncode(analysisResult),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response(
        HttpStatus.internalServerError,
        body: jsonEncode({"error": "Server error: $e"}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // Create a server that listens on all interfaces
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  final server = await shelf_io.serve(handler, '0.0.0.0', 8080);
  print('Server running on http://${server.address.host}:${server.port}');
}
