import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

class PronunciationLessonsPage extends StatefulWidget {
  @override
  _PronunciationLessonsPageState createState() => _PronunciationLessonsPageState();
}

class _PronunciationLessonsPageState extends State<PronunciationLessonsPage> {
  List<Reference> lessons = [];
  List<Reference> filteredLessons = [];
  Set<String> completedLessons = {}; // Track completed lessons
  String searchQuery = "";
  String selectedDifficulty = "All";

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
        title: Text('Pronunciation Lessons'),
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
                                    onComplete: () => markLessonAsComplete(lesson.name), // Callback on completion
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
  final Function onComplete; // Callback function to notify when the video is complete

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

        // Listen for when the video has completed playing
        if (_controller.value.position == _controller.value.duration) {
          // Call the onComplete callback
          widget.onComplete();
          Navigator.pop(context); // Navigate back to the previous screen
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inHours > 0 ? twoDigits(duration.inHours) + ':' : ''}$minutes:$seconds';
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _setPlaybackSpeed(double speed) {
    _controller.setPlaybackSpeed(speed);
    Fluttertoast.showToast(msg: "Speed set to ${speed}x");
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
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 50,
                          color: Colors.white,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.minimize, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.settings, color: Colors.black),
                        onPressed: () {
                          _showPlaybackSettings(context);
                        },
                      ),
                    ],
                  ),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _currentPosition,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        Text(
                          _videoDuration,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  _isBuffering ? CircularProgressIndicator() : Container(),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  void _showPlaybackSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("0.5x"),
                onTap: () {
                  _setPlaybackSpeed(0.5);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("1.0x (Normal)"),
                onTap: () {
                  _setPlaybackSpeed(1.0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("1.5x"),
                onTap: () {
                  _setPlaybackSpeed(1.5);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("2.0x"),
                onTap: () {
                  _setPlaybackSpeed(2.0);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}