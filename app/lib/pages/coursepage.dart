import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stackz/services/network_service.dart';

// Mock Model for Course Modules
class Module {
  final String parent; //Course ID this module belongs to
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final int index;
  bool isCompleted;

  Module({
    required this.parent,
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.index,
    this.isCompleted = false,
  });
}

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late Future<List<Module>> _modulesFuture;

  Future<List<Module>> _fetchModulesList(String id) async {
    try {
      var res = await NetworkService.getCourseDetails(id);
      var prog = await NetworkService.getCourseProgress(id);
      int completedTill = 0;
      if (prog == null){
        completedTill = -1;
      }else{
        completedTill = prog['module_index'];
      }
      final List<Color> colors = [
        Colors.blue,
        Colors.red,
        Colors.cyan,
        Colors.green,
      ];
      List<Module> modules = [];
      for (var item in res) {
        Module module = Module(
          parent: id,
          id: item['id'],
          title: item['title'],
          index: item['index'] as int,
          color: colors[Random().nextInt(colors.length)],
          icon: Icons.book,
        );
        if (module.index <= completedTill){
          module.isCompleted = true;
        }
        modules.add(module);
      }
      return modules;
    } catch (e) {
      throw Exception("Failed to load modules \n DEBUG: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String courseName = args['title']!;
    _modulesFuture = _fetchModulesList(args['id']!);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        // Left Arrow (Back Button)
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          courseName,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Module>>(
          future: _modulesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            } else if (snapshot.hasError) {
              return _buildErrorState();
            } else if (snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final module = snapshot.data![index];
                  return _buildModuleCard(module);
                },
              );
            }
            return const Center(child: Text("No data found"));
          },
        ),
      ),
    );
  }

  Widget _buildModuleCard(Module module) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: module.isCompleted
            ? const Color.fromARGB(255, 34, 107, 37)
            : Colors.white,
        borderRadius: BorderRadius.circular(
          16,
        ), // Rectangular with slightly rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/module',
              arguments: {
                'module_id': module.id,
                'title':module.title,
                'course_id': module.parent,
                'index':module.index
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                // Left Icon Container
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: module.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(module.icon, color: module.color, size: 26),
                ),
                const SizedBox(width: 20),
                // Module Text Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: module.isCompleted
                              ? Colors.white
                              : Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                // Trailing play icon or progress check
                Icon(
                  module.isCompleted
                      ? Icons.replay_circle_filled
                      : Icons.play_circle_fill_rounded,
                  color: module.isCompleted
                      ? Colors.white
                      : Colors.deepPurple.withOpacity(0.8),
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ),
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
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
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
            "We couldn't load the course. Please check your internet and try again.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _modulesFuture = _fetchModulesList(args['id']!);
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
}
