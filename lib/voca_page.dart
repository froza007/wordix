import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordix/pronoun_lesson.dart';

class VocaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lessons"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose a category:",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
            ),
            SizedBox(height: 20),

            // Vocabulary Lessons Button
            _buildLessonCard(
              context,
              title: "Vocabulary Lessons",
              description: "Improve your vocabulary with these essential lessons.",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VocabularyLessonsPage()),
                );
              },
            ),
            
            SizedBox(height: 20),
            
            // Pronunciation Lessons Button
            _buildLessonCard(
              context,
              title: "Pronunciation Lessons",
              description: "Master pronunciation with targeted lessons.",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PronunciationLessonsPage()),
                );
              },
            ),
            
            SizedBox(height: 20),
            
            // Speech Lessons Button
            _buildLessonCard(
              context,
              title: "Speech Lessons",
              description: "Develop your speech skills with these curated lessons.",
              onTap: () {
                // Placeholder for now
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(BuildContext context, {required String title, required String description, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100,
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.book, size: 40, color: Colors.blue.shade700),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VocabularyLessonsPage extends StatefulWidget {
  @override
  _VocabularyLessonsPageState createState() => _VocabularyLessonsPageState();
}

class _VocabularyLessonsPageState extends State<VocabularyLessonsPage> {
  List<Reference> lessons = [];
  List<Reference> filteredLessons = [];
  String searchQuery = "";
  String selectedDifficulty = "All";
  Set<String> completedLessons = {};

  @override
  void initState() {
    super.initState();
    fetchLessons();
  }

  Future<void> fetchLessons() async {
    try {
      List<Reference> fetchedLessons = [];

      if (selectedDifficulty == "All") {
        fetchedLessons.addAll(await fetchLessonsFromFolder('Beginner'));
        fetchedLessons.addAll(await fetchLessonsFromFolder('Intermediate'));
        fetchedLessons.addAll(await fetchLessonsFromFolder('Advanced'));
      } else {
        fetchedLessons = await fetchLessonsFromFolder(selectedDifficulty);
      }

      setState(() {
        lessons = fetchedLessons;
        filteredLessons = lessons;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching lessons: $e");
    }
  }

  Future<List<Reference>> fetchLessonsFromFolder(String folderName) async {
    try {
      final ListResult result = await FirebaseStorage.instance.ref('videos/$folderName').listAll();
      return result.items;
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching $folderName lessons: $e");
      return [];
    }
  }

  void filterLessons() {
    setState(() {
      filteredLessons = lessons.where((lesson) {
        final lessonName = lesson.name.toLowerCase();
        final matchesSearch = searchQuery.isEmpty || lessonName.contains(searchQuery.toLowerCase());
        return matchesSearch;
      }).toList();
    });
  }

  void markLessonAsComplete(String lessonName) {
    setState(() {
      completedLessons.add(lessonName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vocabulary Lessons'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search Lessons",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                filterLessons();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedDifficulty,
              decoration: InputDecoration(
                labelText: "Filter by Difficulty",
                border: OutlineInputBorder(),
              ),
              items: ['All', 'Beginner', 'Intermediate', 'Advanced'].map((String level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDifficulty = value!;
                  fetchLessons();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLessons.length,
              itemBuilder: (context, index) {
                final lesson = filteredLessons[index];
                final isCompleted = completedLessons.contains(lesson.name);

                return ListTile(
                  title: Text(lesson.name),
                  trailing: isCompleted
                      ? Icon(Icons.check, color: Colors.green)
                      : ElevatedButton(
                          onPressed: () async {
                            try {
                              final videoUrl = await lesson.getDownloadURL();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoPlayerScreen(
                                    videoUrl: videoUrl,
                                    videoName: lesson.name,
                                    onComplete: () => markLessonAsComplete(lesson.name),
                                  ),
                                ),
                              );
                            } catch (e) {
                              Fluttertoast.showToast(msg: "Error loading video: $e");
                            }
                          },
                          child: Text('Start Lesson'),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String videoName;
  final Function onComplete;

  VideoPlayerScreen({required this.videoUrl, required this.videoName, required this.onComplete});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isBuffering = false;
  String _videoDuration = '';
  String _currentPosition = '';

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _isPlaying = true;
          _videoDuration = _formatDuration(_controller.value.duration);
        });
      })
      ..addListener(() {
        setState(() {
          _isBuffering = _controller.value.isBuffering;
          _currentPosition = _formatDuration(_controller.value.position);
        });

        // Calculate playback progress and save it
        final double progress = _controller.value.position.inSeconds / _controller.value.duration.inSeconds;
        _savePlaybackProgress(widget.videoName, progress);

        if (_controller.value.position == _controller.value.duration) {
          widget.onComplete();
          Navigator.pop(context);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _savePlaybackProgress(String videoName, double progress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('progress_$videoName', progress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoName),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                            _isPlaying = !_isPlaying;
                          });
                        },
                      ),
                    ],
                  ),
                  Text('$_currentPosition / $_videoDuration'),
                  if (_isBuffering) CircularProgressIndicator(),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}