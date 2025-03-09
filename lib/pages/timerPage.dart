import 'dart:async';

import 'package:flutter/material.dart';
import 'Scaffold.dart';
import '../logic/activity.dart';

class TimerPage extends StatefulWidget {
  final Activity activity;

  TimerPage({required this.activity});

  @override
  _TimerPageState createState() => _TimerPageState();
}


double totalCaloriesBurned = 0.0;

class _TimerPageState extends State<TimerPage> {
  bool isTimerRunning = false;
  late DateTime startTime = DateTime.now();
  late DateTime endTime = DateTime.now();
  late Timer timer;


  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (isTimerRunning) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeMode currentThemeMode = ThemeManager().themeMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Timer Page - ${widget.activity.name}',
          style: TextStyle(color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,),),
        backgroundColor: currentThemeMode == ThemeMode.dark ? Colors.black! : Colors.white,
        iconTheme: IconThemeData(
          color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Timer: ${isTimerRunning ? calculateElapsedTime() : '0:00'}',
              style: TextStyle(fontSize: 20,
                color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isTimerRunning) {
                  stopTimer();
                } else {
                  startTimer();
                }
              },
              child: Text(isTimerRunning ? 'Stop Timer' : 'Start Timer'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  currentThemeMode == ThemeMode.dark ? Colors.grey[800]! : Colors.greenAccent,

                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.all(16.0),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                elevation: MaterialStateProperty.all<double>(8.0),
              ),
            ),
            SizedBox(height: 20),
            if (!isTimerRunning && endTime != null)
              Text('Calories Burned: ${calculateCaloriesBurned()}',
                style: TextStyle(
                  color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                ),),
          ],
        ),
      ),
      backgroundColor: currentThemeMode == ThemeMode.dark ? Colors.grey[900] : null,
    );
  }


  void addToTotalCaloriesBurned(){
    totalCaloriesBurned += calculateCaloriesBurned();
    totalCaloriesBurned = double.parse(totalCaloriesBurned.toStringAsFixed(2));
  }

  void startTimer() {
    setState(() {
      isTimerRunning = true;
      startTime = DateTime.now();
    });
  }

  void stopTimer() {
    setState(() {
      isTimerRunning = false;
      endTime = DateTime.now();
      addToTotalCaloriesBurned();
    });
  }

  String calculateElapsedTime() {
    Duration elapsed = DateTime.now().difference(startTime);
    return '${elapsed.inMinutes}:${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double calculateCaloriesBurned() {
    int elapsedSeconds = endTime.difference(startTime).inSeconds;
    return (widget.activity.caloriesPerMinute / 60) * elapsedSeconds;
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
}
