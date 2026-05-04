import 'package:flutter/material.dart';
import 'package:stackz/services/network_service.dart';
import 'package:stackz/services/storage_service.dart';

class Profile {
  final String username;
  final String name;
  final String email;

  Profile({
    required this.username,
    required this.name,
    required this.email,
  });
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Profile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchUserDetails();
  }

  Future<Profile> _fetchUserDetails() async{
    var res = await NetworkService.getUserDetails();
    Profile profile = Profile(username: res['username'], name: res['full_name'], email: res['email']);
    return profile;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: FutureBuilder<Profile>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            } else if (snapshot.hasError) {
              return _buildErrorState();
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              
              // 1. Profile Icon (Google style) and Username
              _buildProfileHeader(snapshot.data!.name, snapshot.data!.email),
              
              const SizedBox(height: 40),
              
              const Text(
                "Preferences",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              
              const SizedBox(height: 15),

              // 2. Vertical Settings List
              _buildVerticalSetting(Icons.workspace_premium, "My Certificates", Colors.orange),
              _buildVerticalSetting(Icons.payment, "Subscription Plan", Colors.blue),
              _buildVerticalSetting(Icons.dark_mode, "Appearance", Colors.purple),
              _buildVerticalSetting(Icons.security, "Privacy & Safety", Colors.green),
              _buildVerticalSetting(Icons.help_outline, "Help Center", Colors.teal),
              
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 20),
              
              // Logout Button
              _buildVerticalSetting(Icons.logout_rounded, "Log Out", Colors.red, isLogout: true,onClick: () {
                StorageService.removeKeys();
                Navigator.pushReplacementNamed(context, '/login');
              },),
              
              const SizedBox(height: 40),
            ],
          ),
        );
            }
            return const Center(child: Text("No data found"));
          },
        ),
      ),
    );
  }

  // --- Profile Header ---
  Widget _buildProfileHeader(String name, String email) {
    return Center(
      child: Column(
        children: [
          // Google-style Initial Avatar
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade400, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  // --- Vertical Setting Tile ---
  Widget _buildVerticalSetting(IconData icon, String title, Color color, {bool isLogout = false, Function? onClick }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isLogout ? Colors.red.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLogout ? Colors.red.withOpacity(0.1) : Colors.transparent,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: isLogout ? Colors.red.withOpacity(0.5) : Colors.grey[400],
        ),
        onTap: () {
          onClick!();
        },
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
            "Fetching user profile...",
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
                _profileFuture = _fetchUserDetails();
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