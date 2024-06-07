import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? _timer;
  var  workTime = (
    hour: 0,
    minute: 55,
    second: 0
  );
  var chillTime = (
    hour: 0,
    minute: 5,
    second: 0
  );
  bool _timeToWork = true;
  var nowTime = (
    hour: 0,
    minute: 0,
    second: 0
  );
  bool _timerStarted = false;
  String timerNowString = "00:00:00";
    // return nowTimeString;
  @override
  void initState() {
    super.initState();
    nowTime = _timeToWork ? workTime : chillTime;
    timerNowString = getTimerNow();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        decrementTime();
      });
    });
    setState(() {
      _timerStarted = true;
    });
    print("timer started");
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _timerStarted = false;
    });
    print("timer stopped");
  }

  void setTimer() {
    _timeToWork ? setState(() {
      nowTime = workTime;
    }) : setState(() {
      nowTime = chillTime;
    });
  }

  String getTimerNow() => [
      ((nowTime.hour < 10) ? ("0${nowTime.hour}") : nowTime.hour.toString()),
      ((nowTime.minute < 10) ? ("0${nowTime.minute}") : nowTime.minute.toString()),
      ((nowTime.second < 10) ? ("0${nowTime.second}") : nowTime.second.toString())
    ].join(":");

  void decrementTime() {
    if ((nowTime.second-1) == 0 && nowTime.minute == 0 && nowTime.hour == 0) {
      setState(() {
        _timeToWork = !_timeToWork;
        setTimer();
        timerNowString = getTimerNow();
        _timerStarted = false;
      });
      _timer?.cancel();
      return;
    }
    bool secondDown = (nowTime.second-1) == -1;
    bool minuteDown = (nowTime.minute-1) == -1;

    if (secondDown && minuteDown) {
      setState(() {
        nowTime = (
          hour: nowTime.hour-1,
          minute: 59,
          second: 59
        );
        timerNowString = getTimerNow();
      });
      print(nowTime);
      return;
    }
    if (secondDown) {
      setState(() {
        nowTime = (
          hour: nowTime.hour,
          minute: nowTime.minute-1,
          second: 59
        );
        timerNowString = getTimerNow();
      });
      print(nowTime);
      return;
    } 
    setState(() {
      nowTime = (
        hour: nowTime.hour,
        minute: nowTime.minute,
        second: nowTime.second-1
      );
      timerNowString = getTimerNow();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300.0,
              height: 300.0,
              child: TextButton(
                onPressed: _timerStarted ? _stopTimer : _startTimer,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      timerNowString,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
            ) 
          ],
        ),
      ),
    );
  }
}