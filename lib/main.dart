import 'package:flutter/material.dart';
import 'package:batch35_floorease/app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:batch35_floorease/models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());

  runApp(App());
}
