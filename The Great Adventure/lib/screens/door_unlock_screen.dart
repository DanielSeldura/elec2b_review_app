import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../safe_cracker_widgets/safe_dial.dart';

class DoorLockScreen extends StatefulWidget {
  const DoorLockScreen({Key? key}) : super(key: key);

  @override
  State<DoorLockScreen> createState() => _DoorLockScreenState();
}

class _DoorLockScreenState extends State<DoorLockScreen> {
  List<int> values = [0, 0, 0];
  String combination = "420";
  String feedback = '';
  bool isUnlocked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isUnlocked
                  ? CupertinoIcons.lock_open_fill
                  : CupertinoIcons.lock_fill,
              size: 128,
              color: Colors.redAccent,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 32),
              height: 120,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (int i = 0; i < values.length; i++)
                  SafeDial(
                    startingValue: values[i],
                    onIncrement: () {
                      setState(() {
                        if (!isUnlocked) feedback = '';
                        values[i]++;
                      });
                    },
                    onDecrement: () {
                      setState(() {
                        if (!isUnlocked) feedback = '';
                        values[i]--;
                      });
                    },
                  ),
              ]),
            ),
            if (feedback.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(feedback),
              ),
            if (!isUnlocked)
              OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: unlockSafe,
                child: const Text("Try the code"),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop(isUnlocked);
                },
                child: const Text("BACK"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  unlockSafe() {
    if (checkCombination()) {
      setState(() {
        isUnlocked = true;
        feedback = "The lock opens";
      });
    } else {
      setState(() {
        isUnlocked = false;
        feedback = "Wrong combination, try again!";
      });
    }
  }

  bool checkCombination() {
    String theCurrentValue = convertValuesToComparableString(values);
    bool isUnlocked = (theCurrentValue == combination);
    return isUnlocked;
  }

  String convertValuesToComparableString(List<int> val) {
    String temp = "";
    for (int v in val) {
      temp += "$v";
    }
    return temp;
  }

  int sumOfAllValues(List<int> list) {
    int temp = 0;
    for (int i = 0; i < list.length; i++) {
      temp += list[i];
    }
    // for (int number in list) {
    //   temp += number;
    // }
    return temp;
  }
}

class NumberHolder extends StatelessWidget {
  final dynamic content;
  const NumberHolder({Key? key, this.content}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(minHeight: 60),
        width: double.infinity,
        color: Colors.orangeAccent,
        child: Center(
          child: Text(
            "$content",
            textAlign: TextAlign.center,
          ),
        ));
  }
}

class IncrementalNumberHolder extends StatefulWidget {
  final Function(int) onUpdate;
  final int startingValue;
  const IncrementalNumberHolder(
      {Key? key, this.startingValue = 0, required this.onUpdate})
      : super(key: key);

  @override
  State<IncrementalNumberHolder> createState() =>
      _IncrementalNumberHolderState();
}

class _IncrementalNumberHolderState extends State<IncrementalNumberHolder> {
  @override
  void initState() {
    currentValue = widget.startingValue;
    super.initState();
  }

  late int currentValue;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(4),
        width: double.infinity,
        color: Colors.orangeAccent,
        constraints: const BoxConstraints(minHeight: 60),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  currentValue--;
                });
                widget.onUpdate(currentValue);
              },
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Text(
                "$currentValue",
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  currentValue++;
                });
                widget.onUpdate(currentValue);
              },
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ));
  }
}
