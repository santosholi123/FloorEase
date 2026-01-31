import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:batch35_floorease/core/errors/failures.dart';
import 'package:batch35_floorease/features/dashboard/presentation/pages/home_screen.dart';
import 'package:batch35_floorease/features/auth/presentation/pages/create_account_screen.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isMediumScreen = size.width >= 600 && size.width < 900;

    // Responsive values
    final horizontalPadding = isSmallScreen
        ? 24.0
        : (isMediumScreen ? 48.0 : 80.0);
    final verticalPadding = isSmallScreen ? 16.0 : 24.0;
    final maxCardWidth = isSmallScreen
        ? double.infinity
        : (isMediumScreen ? 500.0 : 600.0);

    // Typography
    final headingSize = isSmallScreen ? 28.0 : (isMediumScreen ? 32.0 : 36.0);
    final subtitleSize = isSmallScreen ? 15.0 : 16.0;
    final inputFontSize = isSmallScreen ? 15.0 : 16.0;
    final buttonTextSize = isSmallScreen ? 16.0 : 18.0;

    // Spacing
    final spacingSmall = isSmallScreen ? 12.0 : 16.0;
    final spacingMedium = isSmallScreen ? 20.0 : 24.0;
    final spacingLarge = isSmallScreen ? 32.0 : 40.0;
    final inputHeight = isSmallScreen ? 52.0 : 56.0;
    final buttonHeight = isSmallScreen ? 48.0 : 54.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF33CCFF), Color(0xFF33FFCC)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    size.height -
                    (verticalPadding * 2) -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxCardWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header
                          Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: headingSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: spacingSmall),
                          Text(
                            'Login to your FloorEase account',
                            style: TextStyle(
                              fontSize: subtitleSize,
                              color: Colors.black.withOpacity(0.7),
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: spacingLarge),

                          // Email Field
                          Container(
                            height: inputHeight,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: inputFontSize,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(fontSize: inputFontSize),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          SizedBox(height: spacingSmall),

                          // Password Field
                          Container(
                            height: inputHeight,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: inputFontSize,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                              style: TextStyle(fontSize: inputFontSize),
                            ),
                          ),

                          // Reset Password Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 8,
                                ),
                              ),
                              child: Text(
                                'Reset Password?',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: subtitleSize - 1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: spacingSmall),

                          // Login Button
                          SizedBox(
                            height: buttonHeight,
                            child: ElevatedButton(
                              onPressed: () async {
                                final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false,
                                );
                                if (authProvider.isLoading) return;

                                final email = _emailController.text.trim();
                                final password = _passwordController.text;

                                try {
                                  await authProvider.login(email, password);

                                  if (!mounted) return;

                                  if (authProvider.errorMessage == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Login successful ✅'),
                                      ),
                                    );

                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (c) => const HomeScreen(),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          authProvider.errorMessage!,
                                        ),
                                      ),
                                    );
                                  }
                                } on ApiFailure catch (failure) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(failure.message)),
                                  );
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D7A6A),
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shadowColor: Colors.black.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Consumer<AuthProvider>(
                                builder: (context, authProvider, child) {
                                  if (authProvider.isLoading) {
                                    return SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    );
                                  }
                                  return Text(
                                    'Log In',
                                    style: TextStyle(
                                      fontSize: buttonTextSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: spacingMedium),

                          // Divider
                          Divider(
                            color: Colors.black.withOpacity(0.3),
                            thickness: 1,
                            height: 1,
                          ),
                          SizedBox(height: spacingMedium),

                          // Sign Up Link
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => const CreateAccountScreen(),
                                ),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: subtitleSize,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                  children: const [
                                    TextSpan(text: 'Not a member? '),
                                    TextSpan(
                                      text: 'Create now',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: spacingSmall),

                          // Help and Support
                          Center(
                            child: Text(
                              'Help and Support',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: subtitleSize - 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
