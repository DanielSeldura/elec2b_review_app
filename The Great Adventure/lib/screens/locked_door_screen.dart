import 'package:elec2b_review/screens/door_unlock_screen.dart';
import 'package:elec2b_review/screens/unlocked_door_screen.dart';
import 'package:elec2b_review/widgets/doors/locked_door.dart';
import 'package:flutter/material.dart';

class LockedDoorScreen extends StatefulWidget {
  const LockedDoorScreen({Key? key}) : super(key: key);

  @override
  State<LockedDoorScreen> createState() => _LockedDoorScreenState();
}

class _LockedDoorScreenState extends State<LockedDoorScreen> {
  bool isUnlocked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("You see a ${isUnlocked ? 'unlocked' : 'locked'} door"),
        centerTitle: true,
      ),
      body: SafeArea(
        //a stack widget shows the first child in children as the bottom layer and adds layers on top of it
        child: Stack(
          children: [
            const Center(child: LockedDoor()),
            Center(
              child: OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () async {
                  if (isUnlocked) {
                    bool? reLockDoor = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const UnlockedDoorScreen()));
                    if (reLockDoor ?? false) {
                      if (mounted) {
                        setState(() {
                          isUnlocked = false;
                        });
                      }
                    }
                  } else {
                    bool? result = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const DoorLockScreen()));

                    // result!=null? result: false
                    if (result ?? false) {
                      if (mounted) {
                        setState(() {
                          isUnlocked = true;
                        });
                      } else {
                        if (mounted) {
                          setState(() {
                            isUnlocked = false;
                          });
                        }
                      }
                    }
                  }
                },
                child: Text(isUnlocked ? "Open Door" : "Examine Door"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
