import 'package:app/screen/homescreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDtY6wYiEJzipJMsKrJks-8_OszQcPYFk4",
  authDomain: "manage-students-7c3ad.firebaseapp.com",
  projectId: "manage-students-7c3ad",
  storageBucket: "manage-students-7c3ad.appspot.com",
  messagingSenderId: "207220004672",
  appId: "1:207220004672:web:e5e0661b1d1b8940f94ca5"
  ));
  }
  print('initialized firebase');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomeScreeen(),
    );
  }
}
