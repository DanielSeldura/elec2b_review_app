import 'package:elec2b_review/screens/locked_door_screen.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //a Scaffold serves as a screen skeleton, allowing you to add drawers, appbars and more
    return Scaffold(
      //a SafeArea widget automatically compensates for device statusbars, controls, etc on both ios/android
      backgroundColor: Colors.blueGrey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 32),
                  child: const Text(
                    "Welcome to Nav 1.0 Activity!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  )),
              OutlinedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.amberAccent)),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LockedDoorScreen(),
                      ),
                    );
                  },
                  child: const Text("Let's go!"))
            ],
          ),
        ),
      ),
    );
  }
}
