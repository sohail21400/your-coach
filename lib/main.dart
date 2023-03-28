import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:your_coach/screens/chat_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
      builder: (context) {
        return MaterialApp(
          title: 'Your Coach',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            secondaryHeaderColor: Colors.white,
          ),
          home: const ChatScreen(),
        );
      },
      // TODO: set the width as 60% of the screen width
      // maximumSize: Size(500, 900),
      maximumSize: const Size(double.infinity, double.infinity),
      // TODO: only enable if the device is desktop
      // enabled: true,
      backgroundColor: Colors.white,
    );
  }
}
