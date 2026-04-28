import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controllers for the new fields
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Locked Color Pattern: Deep Navy Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
              ),
            ),
          ),
          // Animated Design Element (Bottom Glow)
          Positioned(
            bottom: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00B4D8).withOpacity(0.05),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  IconButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Start your learning journey today.",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 40),

                  // Fields
                  _buildSignupField(
                    controller: _nameController,
                    hint: "Full Name",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 15),
                  _buildSignupField(
                    controller: _usernameController,
                    hint: "Username",
                    icon: Icons.alternate_email,
                  ),
                  const SizedBox(height: 15),
                  _buildSignupField(
                    controller: _emailController,
                    hint: "Email Address",
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 15),
                  _buildSignupField(
                    controller: _passwordController,
                    hint: "Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  const SizedBox(height: 15),
                  _buildSignupField(
                    controller: _confirmPasswordController,
                    hint: "Confirm Password",
                    icon: Icons.lock_reset_outlined,
                    isPassword: true,
                  ),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white30),
                        child: Checkbox(
                          value: _isAgreed,
                          activeColor: const Color(0xFF00B4D8),
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (bool? value) {
                            setState(() {
                              _isAgreed = value ?? false;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "I agree to the ",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: "Terms & Conditions",
                                style: const TextStyle(
                                  color: Color(0xFF00B4D8),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                // Use a TapGestureRecognizer here later to navigate
                                // recognizer: TapGestureRecognizer()..onTap = () => print('Open Terms'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Create Account Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B4D8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        shadowColor: const Color(0xFF00B4D8).withOpacity(0.4),
                      ),
                      onPressed: () {
                        if (_passwordController.text !=
                            _confirmPasswordController.text){
                          toastification.show(
                            context: context,
                            title: Text('Passwords do not Match !'),
                            type: ToastificationType.error,
                            style: ToastificationStyle.fillColored,
                            autoCloseDuration: const Duration(seconds: 3),
                          );
                        }else if(_nameController.text.isEmpty || _usernameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty){
                          toastification.show(
                            context: context,
                            title: Text('All Fields are required !'),
                            type: ToastificationType.error,
                            style: ToastificationStyle.fillColored,
                            autoCloseDuration: const Duration(seconds: 3),
                          );
                        } else {
                          Navigator.pushNamed(
                            context,
                            '/progress',
                            arguments: {
                              'username': _usernameController.text,
                              'password': _passwordController.text,
                              'email': _emailController.text,
                              'name': _nameController.text,
                              'signup': 'y'
                            },
                          );
                        }
                      },
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Already have an account?
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Color(0xFF00B4D8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to keep code clean and maintain the same design pattern
  Widget _buildSignupField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70, size: 20),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF00B4D8), width: 1.5),
        ),
      ),
    );
  }
}
