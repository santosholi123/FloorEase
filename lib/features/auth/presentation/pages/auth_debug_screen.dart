import 'package:flutter/material.dart';
import 'package:batch35_floorease/services/auth_service.dart';
import 'package:batch35_floorease/models/user.dart';

class AuthDebugScreen extends StatefulWidget {
  const AuthDebugScreen({super.key});

  @override
  State<AuthDebugScreen> createState() => _AuthDebugScreenState();
}

class _AuthDebugScreenState extends State<AuthDebugScreen> {
  late Future<List<User>> _usersFuture;
 
  @override
  void initState() {
    super.initState();
    _usersFuture = AuthService.instance.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth Debug')),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return Center(child: Text('Error: \\${snapshot.error}'));
          final users = snapshot.data ?? [];
          if (users.isEmpty) return const Center(child: Text('No users')); 
          return ListView.separated(
            itemCount: users.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, i) {
              final u = users[i];
              return ListTile(
                title: Text(u.name),
                subtitle: Text(u.email),
                trailing: Text(u.createdAt.toIso8601String()),
              );
            },
          );
        },
      ),
    );
  }
}
