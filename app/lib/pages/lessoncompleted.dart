import 'package:flutter/material.dart';
import 'package:stackz/services/network_service.dart';

class LessonCompletedPage extends StatefulWidget {
  const LessonCompletedPage({super.key});

  @override
  State<LessonCompletedPage> createState() => _LessonCompletedPageState();
}

enum SyncState { loading, success, error }

class _LessonCompletedPageState extends State<LessonCompletedPage> {
  SyncState _state = SyncState.loading;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();

    // Use addPostFrameCallback to safely access ModalRoute arguments
    // and trigger the request once after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _updateProgress(args['course_id'], args['module_index']);
    });
  }

  // Mock API Call
  Future<void> _updateProgress(String courseId, int moduleIndex) async {
    try {
      int res = await NetworkService.updateProgress(courseId, moduleIndex);
      if (res == 204) {
        setState(() {
          _state = SyncState.success;
        });
      } else {
        setState(() {
          _state = SyncState.error;
        });
      }
    } catch (e) {
      setState(() {
        _state = SyncState.error;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Center(child: _buildBody())),
              _buildFooterButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case SyncState.loading:
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Saving your progress...", style: TextStyle(fontSize: 16)),
          ],
        );
      case SyncState.success:
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
            SizedBox(height: 16),
            Text(
              "Lesson Complete!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text("Your progress has been synced.", textAlign: TextAlign.center),
          ],
        );
      case SyncState.error:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 80),
            const SizedBox(height: 16),
            const Text(
              "Sync Failed",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        );
    }
  }

  Widget _buildFooterButton() {
    if (_state == SyncState.loading) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: _state == SyncState.success
              ? Colors.blue
              : Colors.orange,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "CONTINUE",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
