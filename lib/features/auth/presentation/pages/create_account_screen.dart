import 'package:batch35_floorease/features/auth/presentation/pages/login_screen.dart';
import 'package:batch35_floorease/services/auth_service.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0ACBF2), Color(0xFF7EECC7)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            final horizontalPadding = isWide ? 48.0 : 24.0;
            final headingSize = isWide ? 36.0 : 32.0;
            final subtitleSize = isWide ? 18.0 : 16.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWide ? 700 : double.infinity),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: isWide ? 48 : 24),
                      Text('Create Account', style: TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold, color: Colors.black)),
                      const SizedBox(height: 8),
                      Text('Smart Floors. Smart Choice. FloorEase.', style: TextStyle(fontSize: subtitleSize, color: Colors.black87)),
                      SizedBox(height: isWide ? 36 : 24),

                      _buildInputField(label: 'Full Name', hintText: 'Enter Your Full Name', controller: _fullNameController),
                      SizedBox(height: isWide ? 20 : 16),

                      _buildInputField(label: 'Mobile Number', hintText: 'Enter mobile number', controller: _mobileNumberController, keyboardType: TextInputType.phone),
                      SizedBox(height: isWide ? 20 : 16),

                      _buildInputField(label: 'Email', hintText: 'Enter your email address', controller: _emailController, keyboardType: TextInputType.emailAddress),
                      SizedBox(height: isWide ? 20 : 16),

                      _buildPasswordField(),
                      SizedBox(height: isWide ? 20 : 16),

                      const Divider(color: Colors.black38),
                      SizedBox(height: isWide ? 20 : 16),

                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: isWide ? 420 : double.infinity),
                          child: ElevatedButton(
                            onPressed: () async {
                              final name = _fullNameController.text.trim();
                              final email = _emailController.text.trim();
                              final password = _passwordController.text;
                              if (name.isEmpty || email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
                                return;
                              }
                              final messenger = ScaffoldMessenger.of(context);
                              final navigator = Navigator.of(context);
                              final ok = await AuthService.instance.signUp(name: name, email: email, password: password);
                              if (!mounted) return;
                              if (ok) {
                                messenger.showSnackBar(const SnackBar(content: Text('Account created — please log in')));
                                navigator.pushReplacement(MaterialPageRoute(builder: (c) => const LoginScreen()));
                              } else {
                                messenger.showSnackBar(const SnackBar(content: Text('Account already exists')));
                              }
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D7D74), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Text('Get Started', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
//
                      SizedBox(height: isWide ? 20 : 16),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?', style: TextStyle(color: Colors.black87)),
                            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const LoginScreen())), child: const Text('Log in', style: TextStyle(color: Color(0xFF1D7D74), fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),

                      SizedBox(height: isWide ? 20 : 16),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'Create a secure password',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
