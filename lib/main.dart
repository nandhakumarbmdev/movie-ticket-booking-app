import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '/providers/theatre_provider.dart';
import 'package:provider/provider.dart';

import 'auth/auth_wrapper.dart';
import 'providers/user_provider.dart';
import 'providers/movie_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => TheatreProvider()),
      ],
      child: const MaterialApp(
        title: "Box Office",
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
      ),
    );
  }
}
