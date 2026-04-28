import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stackz/services/network_service.dart';

Future<List<String>> _fetchModuleContent(String id) async {
  try {
    var res = await NetworkService.getModuleDetails(id);
    List<String> list = [];
    for (var item in res.keys) {
      list.add(res[item]);
    }
    return list;
  } catch (e) {
    throw Exception("Failed to load module content \n DEBUG: $e");
  }
}

class ModulePage extends StatefulWidget {
  const ModulePage({super.key});

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  late Future<List<String>> _moduleFuture;
  int activePage = 0;
  int maxPages = 0;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _moduleFuture = _fetchModuleContent(args['module_id']!);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, args['title']!),
      body: SafeArea(
        child: FutureBuilder<List<String>>(
          future: _moduleFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            } else if (snapshot.hasError) {
              return _buildErrorState();
            } else if (snapshot.hasData) {
              maxPages = snapshot.data!.length;
              return Column(
                children: [
                  // 3. Lesson Content (Markdown)
                  Expanded(
                    child: Markdown(
                      data: snapshot.data![activePage],
                      selectable: true,
                      styleSheet: _getMarkdownStyle(context),
                      padding: const EdgeInsets.all(20),
                    ),
                  ),

                  // 2. Continue Button at Bottom Center
                  _buildContinueButton(context, args['course_id']!,args['index']!),
                ],
              );
            }
            return const Center(child: Text("No data found"));
          },
        ),
      ),
    );
  }

  // --- AppBar with Module Title ---
  PreferredSizeWidget _buildAppBar(BuildContext context, String moduleTitle) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black87,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        moduleTitle,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: Colors.grey[200], height: 1.0),
      ),
    );
  }

  // --- Styled Continue Button ---
  Widget _buildContinueButton(BuildContext context, String courseId, int Index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            if (activePage < (maxPages - 1)) {
              setState(() {
                activePage += 1;
              });
            } else {
              Navigator.pushReplacementNamed(
              context,
              '/complete',
              arguments: {
                'module_index': Index,
                'course_id': courseId
              },
            );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A11CB),
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            "Continue",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // --- Custom Markdown Styling ---
  MarkdownStyleSheet _getMarkdownStyle(BuildContext context) {
    return MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      h1: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A2E),
      ),
      h2: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A2E),
      ),
      p: TextStyle(fontSize: 16, color: Colors.grey[800], height: 1.5),

      // Inline code (e.g. `variable`)
      code: TextStyle(
        backgroundColor: Colors.black, // Light grey background
        color: Colors.white, // Contrast color
        fontFamily: 'monospace',
        fontSize: 14,
      ),

      // Code Block (The actual python block)
      codeblockPadding: const EdgeInsets.all(16),
      codeblockDecoration: BoxDecoration(
        color: Colors.black, // Dark background for code
        borderRadius: BorderRadius.circular(12),
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
                _moduleFuture = _fetchModuleContent(args['id']!);
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
