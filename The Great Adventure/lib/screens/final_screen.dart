import 'package:flutter/material.dart';

class FinalScreen extends StatelessWidget {
  final String player;
  const FinalScreen({this.player = '', Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
          ),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: const Text("Reset"),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/outdoors.jpg'),
              fit: BoxFit.cover),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.10),
            child: Text(
              "You made it outside $player, congratulations!",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 32),
            ),
          ),
        ),
      ),
    );
  }
}
