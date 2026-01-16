import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/auth_provider.dart';

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
		final authProvider = Provider.of<AuthProvider>(context);
		return Scaffold(
			body: Container(
				// ...existing decoration and layout code...
				child: SafeArea(
					child: LayoutBuilder(
						builder: (context, constraints) {
							// ...existing layout code...
							return SingleChildScrollView(
								// ...existing padding and center code...
								child: Column(
									// ...existing children...
									children: [
										// ...existing widgets...
										if (authProvider.errorMessage != null)
											Padding(
												padding: const EdgeInsets.symmetric(vertical: 8.0),
												child: Text(
													authProvider.errorMessage!,
													style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
												),
											),
										ElevatedButton(
											onPressed: authProvider.isLoading
													? null
													: () async {
															final email = _emailController.text.trim();
															final password = _passwordController.text;
															await authProvider.login(email, password);
														},
											style: ElevatedButton.styleFrom(
												backgroundColor: const Color(0xFF0D7A6A),
												foregroundColor: Colors.white,
												padding: const EdgeInsets.symmetric(vertical: 16),
												shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
											),
											child: authProvider.isLoading
													? const SizedBox(
															width: 24,
															height: 24,
															child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
														)
													: const Text('Log In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
										),
										// ...rest of existing widgets...
									],
								),
							);
						},
					),
				),
			),
		);
	}
}
