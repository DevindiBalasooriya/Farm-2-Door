import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 10),
        () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SigninScreen(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 92, 198, 224),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: RadialGradient(center: Alignment.center, colors: [
          Color.fromARGB(255, 233, 235, 118),
          Color(0xFFDFD36C),
          Color.fromARGB(255, 248, 181, 105),
        ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            ClipOval(
              child: Image.asset(
                'assets/b.png',
                height: 120,
                width: 120,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Farm2Door",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            if (defaultTargetPlatform == TargetPlatform.android)
              const CupertinoActivityIndicator(
                color: Colors.black,
                radius: 20,
              )
            else
              const CircularProgressIndicator(
                color: Colors.black,
              )
          ],
        ),
      ),
    );
  }
}
