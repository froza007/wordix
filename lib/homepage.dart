import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordix/WORDS/views/home.dart';
import 'package:wordix/chatbot.dart';
import 'package:wordix/grammarAI/screens/home_page.dart';
import 'package:wordix/profile.dart';
import 'package:wordix/quiz/MainMenu.dart';
import 'package:wordix/voca_page.dart'; // Adjust this import if necessary
// Add import for HomePagess

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? recentVideoName;
  double? recentVideoProgress;

  @override
  void initState() {
    super.initState();
    _loadRecentVideo();
  }

  Future<void> _loadRecentVideo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    recentVideoName = prefs.getString('recent_video_name');
    recentVideoProgress = prefs.getDouble('progress_$recentVideoName') ?? 0.0;
    setState(() {}); // Refresh the UI to display the recent video
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Dashboard"),
        backgroundColor: Colors.blue.shade800,
        actions: [
          IconButton(
            icon: Icon(Icons.chat_bubble),
            onPressed: () {
              // Redirect to HomePagess
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePagess()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade800,
              ),
              child: Text(
                "Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text("Lessons"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VocaPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text("Tests"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainMenu()), // Redirect to MainMenu
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text("Reports"),
              onTap: () {
                // Navigate to reports
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () {
                // Redirect to ProfilePage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personalized Welcome Message
                Text(
                  "Hi, Jerel!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Welcome back! Here’s what’s happening today:",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(height: 20),

                // Quick Access Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickAccessButton(
                      context,
                      icon: Icons.book,
                      label: "Recent Lessons",
                      onTap: () {
                        // Navigate to recently accessed lessons
                      },
                    ),
                    _buildQuickAccessButton(
                      context,
                      icon: Icons.assignment,
                      label: "Recent Tests",
                      onTap: () {
                        // Navigate to recently accessed tests
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Recently Played Video Section
                if (recentVideoName != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recently Played Video: $recentVideoName',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: recentVideoProgress,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${(recentVideoProgress! * 100).toStringAsFixed(1)}% completed',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),

                // Popular Lessons Section
                Text(
                  "Popular lessons",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildLessonCard(
                        context,
                        title: "Vocabulary Master Class",
                        lessons: "28 lessons",
                        duration: "6h 30min",
                        rating: "4.9",
                        imagePath: 'assets/lesson1.png',
                      ),
                      SizedBox(width: 20),
                      _buildLessonCard(
                        context,
                        title: "Spoken English",
                        lessons: "30 lessons",
                        duration: "8h 30min",
                        rating: "4.7",
                        imagePath: 'assets/lesson2.png',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                // Redirect to InterviewBot
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InterviewBot()),
                );
              },
              child: Icon(Icons.chat),
              backgroundColor: Colors.green,
              tooltip: "Interview Bot",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, left: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                // Redirect to HomePages
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePages()),
                );
              },
              child: Icon(Icons.text_fields),
              backgroundColor: Colors.orange,
              tooltip: "Grammar Bot",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
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
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.blue.shade700),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: Colors.blue.shade800, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(
    BuildContext context, {
    required String title,
    required String lessons,
    required String duration,
    required String rating,
    required String imagePath,
  }) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 10,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue.shade800),
                ),
                SizedBox(height: 6),
                Text(lessons, style: TextStyle(color: Colors.grey.shade600)),
                SizedBox(height: 6),
                Text(duration, style: TextStyle(color: Colors.grey.shade600)),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    SizedBox(width: 6),
                    Text(rating, style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 30),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book, size: 30),
          label: "Lessons",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment, size: 30),
          label: "Tests",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.report, size: 30),
          label: "Reports",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 30),
          label: "Profile",
        ),
      ],
      selectedItemColor: Colors.blue.shade700,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      elevation: 10,
    );
  }
}
