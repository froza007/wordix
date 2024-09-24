
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Vocabulary Lessons Page
class VocabularyLessonsPage extends StatefulWidget {
  @override
  _VocabularyLessonsPageState createState() => _VocabularyLessonsPageState();
}

class _VocabularyLessonsPageState extends State<VocabularyLessonsPage> {
  // Sample data for lessons
  List<Map<String, String>> lessons = [
    {'title': 'Basic Vocabulary', 'difficulty': 'Beginner', 'videoUrl': 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'},
    {'title': 'Intermediate Vocabulary', 'difficulty': 'Intermediate', 'videoUrl': 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'},
    {'title': 'Advanced Vocabulary', 'difficulty': 'Advanced', 'videoUrl': 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'},
    {'title': 'Travel Vocabulary', 'difficulty': 'Beginner', 'videoUrl': 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'},
    {'title': 'Business Vocabulary', 'difficulty': 'Intermediate', 'videoUrl': 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'},
  ];

  String selectedDifficulty = 'All';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vocabulary Lessons'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Lessons',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: selectedDifficulty,
              onChanged: (String? newValue) {
                setState(() {
                  selectedDifficulty = newValue!;
                });
              },
              items: <String>['All', 'Beginner', 'Intermediate', 'Advanced']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          // Lesson List
          Expanded(
            child: ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                if ((selectedDifficulty == 'All' || lesson['difficulty'] == selectedDifficulty) &&
                    (searchQuery.isEmpty || lesson['title']!.toLowerCase().contains(searchQuery.toLowerCase()))) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(lesson['title']!),
                      subtitle: Text('Difficulty: ${lesson['difficulty']}'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Navigate to Video Player Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                videoUrl: lesson['videoUrl']!,
                                videoName: lesson['title']!,
                              ),
                            ),
                          );
                        },
                        child: Text('Start Lesson'),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Video Player Screen
class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String videoName;

  VideoPlayerScreen({required this.videoUrl, required this.videoName});

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
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
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
        title: Text(widget.videoName), // Use the exact file name
        backgroundColor: Colors.blueAccent, // Optional color update
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
                      // Play/Pause button over the video
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
                  // Minimize icon, Settings icon, Video Progress, Current Position, and Total Duration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Minimize icon at the bottom-left below the video
                      IconButton(
                        icon: Icon(Icons.minimize, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      // Settings icon at the bottom-right below the video
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
                        // Current position of the video
                        Text(
                          _currentPosition,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        // Total video duration
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
      isScrollControlled: true, // Allows the bottom sheet to adjust height
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Fit content
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
