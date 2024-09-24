import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'dart:io'; // For file system
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart'; // For audio recording
import 'package:path_provider/path_provider.dart'; // For getting file paths

class SentencePracticePage extends StatefulWidget {
  @override
  _SentencePracticePageState createState() => _SentencePracticePageState();
}

class _SentencePracticePageState extends State<SentencePracticePage> {
  String displayedSentence = '';
  String result = '';
  String transcribedText = '';
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String audioFilePath = '';

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _generateNewSentence(); // Generate the first sentence
  }

  // Initialize the audio recorder
  Future<void> _initializeRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await _recorder.openRecorder();
  }

  // Fetch a new sentence from GPT-3 API
  Future<void> _generateNewSentence() async {
    var url = Uri.parse('https://api.openai.com/v1/completions');
    var headers = {
      'Authorization': 'Bearer sk-AjiD7cVHeiru814ZZwsQ-vtRS9Eus8_7WPB_9RdazDT3BlbkFJjgzOgbstj306vAyysXW9m-ki9IyCq10KAM0RcJ5cEA', // Replace with your OpenAI API key
      'Content-Type': 'application/json',
    };

    var body = jsonEncode({
      'model': 'text-davinci-003', // Use the Davinci model for generating text
      'prompt': 'Generate a simple sentence for a speech practice test.',
      'max_tokens': 50 // Limit the number of tokens (word count)
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      setState(() {
        displayedSentence = jsonResponse['choices'][0]['text'].trim();
      });
    } else {
      print('Failed to generate sentence');
    }
  }

  // Start recording audio
  Future<void> _startRecording() async {
    if (_isRecording) return;

    final directory = await getTemporaryDirectory();
    audioFilePath = '${directory.path}/recorded_audio.aac';
    await _recorder.startRecorder(
      toFile: audioFilePath,
      codec: Codec.aacADTS,
    );

    setState(() {
      _isRecording = true;
    });
  }

  // Stop recording and transcribe the speech using Whisper API
  Future<void> _stopRecordingAndTranscribe() async {
    if (!_isRecording) return;

    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });

    await _transcribeSpeech(); // Transcribe recorded speech
  }

  // Transcribe speech using Whisper API
  Future<void> _transcribeSpeech() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.openai.com/v1/audio/transcriptions'),
    );
    request.headers['Authorization'] = 'Bearer sk-AjiD7cVHeiru814ZZwsQ-vtRS9Eus8_7WPB_9RdazDT3BlbkFJjgzOgbstj306vAyysXW9m-ki9IyCq10KAM0RcJ5cEA'; // Replace with your OpenAI API key
    request.files.add(await http.MultipartFile.fromPath('file', audioFilePath));
    request.fields['model'] = 'whisper-1';

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await http.Response.fromStream(response);
      var jsonResponse = json.decode(responseData.body);
      setState(() {
        transcribedText = jsonResponse['text'].trim(); // Get the transcribed text
      });
      _evaluateSentence(); // Evaluate the transcribed sentence
    } else {
      var responseData = await http.Response.fromStream(response);
      print('Transcription failed: ${responseData.body}');
    }
  }

  // Evaluate the transcribed sentence against the displayed sentence
  void _evaluateSentence() {
    if (transcribedText.toLowerCase() == displayedSentence.toLowerCase()) {
      result = 'Correct';
      _storeResult(true); // Store the result in Firebase
    } else {
      result = 'Wrong Answer';
      _storeResult(false); // Store the result in Firebase
    }
  }

  // Store the result in Firebase
  Future<void> _storeResult(bool isCorrect) async {
    await FirebaseFirestore.instance.collection('sentence-test-results').add({
      'displayed_sentence': displayedSentence,
      'spoken_sentence': transcribedText,
      'status': isCorrect ? 'Correct' : 'Wrong',
      'timestamp': FieldValue.serverTimestamp(),
    });

    _generateNewSentence(); // Generate a new sentence after storing the result
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sentence Test Practice')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sentence: $displayedSentence',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Transcribed: $transcribedText',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isRecording ? _stopRecordingAndTranscribe : _startRecording,
              child: Text(_isRecording ? 'Stop & Transcribe' : 'Start Recording'),
            ),
            SizedBox(height: 20),
            Text(
              result,
              style: TextStyle(fontSize: 18, color: result == 'Correct' ? Colors.green : Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }
}