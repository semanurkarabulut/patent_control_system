import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:patent_control_system/src/views/sign_up.dart';
import 'package:progress_indicators/progress_indicators.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            title: "Patent Control System",
            home: SignUp(),
            debugShowCheckedModeBanner: false,
          );
        }
        else{
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SafeArea( 
              child: Scaffold(
                backgroundColor: HexColor("141d26"),
                body: Center(
                    child: JumpingDotsProgressIndicator(
                  color: Colors.white,
                  fontSize: 80,
                )),
              ),
            ),
          );
        }
      },
    );
  }
}
