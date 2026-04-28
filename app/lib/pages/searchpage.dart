import 'package:flutter/material.dart';

// Course Model
class Course {
  final String title;
  final String category;
  final String icon;
  final Color color;
  Course({required this.title, required this.category, required this.icon, required this.color});
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Course>? _results;
  bool _isLoading = false;
  String? _errorMessage;

  // Mock API Search Function
  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _results = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 1)); // Network lag simulation

      if (query.toLowerCase() == "error") throw Exception();

      if (query.toLowerCase() == "empty") {
        setState(() { _results = []; _isLoading = false; });
        return;
      }

      setState(() {
        _results = [
          Course(title: "Advanced Dart Concepts", category: "Programming", icon: "🎯", color: Colors.blue),
          Course(title: "Flutter State Management", category: "Development", icon: "🏗️", color: Colors.indigo),
          Course(title: "Mastering UI Design", category: "Design", icon: "✨", color: Colors.pink),
          Course(title: "Python for Data Science", category: "Data", icon: "🐍", color: Colors.orange),
          Course(title: "Firebase Auth Deep Dive", category: "Backend", icon: "🔐", color: Colors.amber),
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "We couldn't reach the server. Check your connection.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: _buildSearchAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Container(
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          onSubmitted: _performSearch,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: "Search courses, topics...",
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: Colors.deepPurple),
              onPressed: () => _performSearch(_searchController.text),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
    }

    if (_errorMessage != null) {
      return _buildStatusState(Icons.wifi_off_rounded, "Connection Error", _errorMessage!, isError: true);
    }

    if (_results != null && _results!.isEmpty) {
      return _buildStatusState(Icons.sentiment_dissatisfied, "No Results", "Try searching for something else like 'Flutter'.");
    }

    if (_results != null) {
      return _buildVerticalResults();
    }

    // Initial State
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_rounded, size: 100, color: Colors.grey[200]),
          const Text("Search for your next skill", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // --- The Vertical Results List ---
  Widget _buildVerticalResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _results!.length,
      itemBuilder: (context, index) {
        final course = _results![index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: course.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(course.icon, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 15),
              // Text Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.category,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }

  // --- Reusable Status/Error State ---
  Widget _buildStatusState(IconData icon, String title, String desc, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: isError ? Colors.red[200] : Colors.grey[300]),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(desc, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          if (isError) ...[
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () => _performSearch(_searchController.text),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, shape: StadiumBorder()),
              child: const Text("Retry", style: TextStyle(color: Colors.white)),
            )
          ]
        ],
      ),
    );
  }
}