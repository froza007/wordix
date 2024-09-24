import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InterviewPracticePage2 extends StatefulWidget {
  @override
  _InterviewPracticePageState createState() => _InterviewPracticePageState();
}

class _InterviewPracticePageState extends State<InterviewPracticePage2> {
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String _response = '';
  String _feedback = '';
  String? _audioFilePath;

  @override
  void initState() {
    super.initState();
    _initRecorder();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
  }

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
  }

  Future<void> _startRecording() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      _audioFilePath = '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';

      await _recorder.startRecorder(
        toFile: _audioFilePath,
        codec: Codec.pcm16WAV,
      );

      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
      });

      if (_audioFilePath != null) {
        String downloadUrl = await _uploadToFirebase(File(_audioFilePath!));
        String transcribedText = await transcribeAudio(downloadUrl);  // Transcribe audio
        await _analyzeResponse(transcribedText);  // Analyze transcribed text
      } else {
        print('No audio file path recorded.');
        setState(() {
          _feedback = 'Error: No audio file path recorded.';
        });
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  Future<String> _uploadToFirebase(File audioFile) async {
    try {
      String fileName = 'audio/${DateTime.now().millisecondsSinceEpoch}.wav';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(audioFile);
      await uploadTask;

      String downloadUrl = await ref.getDownloadURL();
      print('Upload complete: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading to Firebase: $e');
      setState(() {
        _feedback = 'Error uploading to Firebase.';
      });
      return '';
    }
  }

  Future<String> transcribeAudio(String audioUrl) async {
    final String apiUrl = 'https://speech.googleapis.com/v1/speech:recognize?key=YOUR_GOOGLE_CLOUD_API_KEY';

    var body = {
      "audio": {
        "uri": audioUrl,
      },
      "config": {
        "encoding": "LINEAR16",
        "sampleRateHertz": 16000,
        "languageCode": "en-US",
      }
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String transcription = data['results'][0]['alternatives'][0]['transcript'];
      return transcription;
    } else {
      throw Exception('Error transcribing audio: ${response.body}');
    }
  }

  Future<void> _analyzeResponse(String transcribedText) async {
    final String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1_5-turbo:generateMessage?key=YOUR_GEMINI_API_KEY';

    var body = {
      "prompt": {
        "text": transcribedText
      }
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _response = data['generated_text'];
        _feedback = 'Analysis complete';
      });
    } else {
      setState(() {
        _feedback = 'Error analyzing response.';
      });
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI-Based Interview Preparation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Interview Question: "Tell me about yourself."'),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _isRecording ? _stopRecording : _startRecording,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: _isRecording ? Colors.red : Colors.green,
                child: Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Your Response: $_response'),
            SizedBox(height: 10),
            Text('Feedback: $_feedback', style: TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
