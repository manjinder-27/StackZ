import 'package:flutter/material.dart';
import 'package:stackz/services/network_service.dart';
import 'dart:math';

class Course {
  final String id;
  final String title;
  final String author;
  final String icon;
  final Color color;

  Course({
    required this.id,
    required this.title,
    required this.author,
    required this.color,
    required this.icon,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Course>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _fetchCourses();
  }

  Future<List<Course>> _fetchCourses() async {
    try {
      var res = await NetworkService.fetchCourses();
      final List<Color> colors = [
        Colors.blue,
        Colors.red,
        Colors.cyan,
        Colors.green,
      ];
      final List<String> icons = ["📕", "📘", "📗", "📙"];
      List<Course> courses = [];
      for (var item in res) {
        Course course = Course(
          id: item['id'],
          title: item['name'],
          author: item['author'],
          color: colors[Random().nextInt(colors.length)],
          icon: icons[Random().nextInt(icons.length)],
        );
        courses.add(course);
      }
      return courses;
    } catch (e) {
      throw Exception("Failed to load courses");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: FutureBuilder<List<Course>>(
          future: _coursesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            } else if (snapshot.hasError) {
              return _buildErrorState();
            } else if (snapshot.hasData) {
              return _buildMainContent(snapshot.data!);
            }
            return const Center(child: Text("No data found"));
          },
        ),
      ),
    );
  }

  Widget _buildMainContent(List<Course> courses) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          _sectionHeader("Top Courses"),
          const SizedBox(height: 15),
          _buildVerticalList(courses),
        ],
      ),
    );
  }

  Widget _buildVerticalList(List<Course> courses) {
    return ListView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // Important for nested scrolling
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: course.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(course.icon, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    course.author,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/course',
                    arguments: {
                      'id': course.id,
                      'title': course.title,
                    },
                  );
                },
                icon: const Icon(Icons.chevron_right),
                color: Colors.grey,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.deepPurple[400],
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          const Text(
            "Fetching amazing courses...",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 80, color: Colors.red[200]),
          const SizedBox(height: 20),
          const Text(
            "Oops! Connection Lost",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "We couldn't load the courses. Please check your internet and try again.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _coursesFuture = _fetchCourses();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text("Retry", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
