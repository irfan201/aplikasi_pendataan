import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBiwo6NgrIQmbJYdMCLorB18kU1DIHjIMU',
      appId: '1:444478563865:android:6606611fae4088ae1f2c88',
      messagingSenderId: '444478563865',
      projectId: 'data-siswa-82832',
      storageBucket: 'gs://data-siswa-82832.appspot.com',
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}
