import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  var bigChillTime = (
    hour: 0,
    minute: 30,
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
  bool bigChillTimeNow = false;
  int defaultBubbles = 4;
  int endedBubbles = 0;
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
    // print("timer started");
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _timerStarted = false;
    });
    // print("timer stopped");
  }

  void setTimer() {
    if (_timeToWork) {
      setState(() {
      nowTime = workTime;
    });
    }
    if (!_timeToWork) {
      setState(() {
      nowTime = chillTime;
    });
    }
    if (bigChillTimeNow) {
      setState(() {
      nowTime = bigChillTime;
    });
    }
  }

  String getTimerNow() => [
      ((nowTime.hour < 10) ? ("0${nowTime.hour}") : nowTime.hour.toString()),
      ((nowTime.minute < 10) ? ("0${nowTime.minute}") : nowTime.minute.toString()),
      ((nowTime.second < 10) ? ("0${nowTime.second}") : nowTime.second.toString())
    ].join(":");

  void decrementTime() {
    if ((nowTime.second-1) == 0 && nowTime.minute == 0 && nowTime.hour == 0) {
      setState(() {
        if (endedBubbles+1 > defaultBubbles && !bigChillTimeNow) {
          bigChillTimeNow = true;
          setTimer();
          timerNowString = getTimerNow();
          _timerStarted = false;
          return;
        }
        if (endedBubbles+1 > defaultBubbles && bigChillTimeNow) {
          bigChillTimeNow = false;
          _timeToWork = true;
          setTimer();
          timerNowString = getTimerNow();
          _timerStarted = false;
          endedBubbles = 0;
          return;
        }
        if (!_timeToWork) endedBubbles++;
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
      // print(nowTime);
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
      // print(nowTime);
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

  void restartBubble() {
    setState(() {
      endedBubbles = 0;
      _timeToWork = true;
      nowTime = workTime;
      timerNowString = getTimerNow();
      _stopTimer();
    });
  }

  void skipBubble() {
    setState(() {
      endedBubbles++;
      _timeToWork = true;
      nowTime = workTime;
      timerNowString = getTimerNow();
      _stopTimer();
      if (endedBubbles == defaultBubbles) {
        bigChillTimeNow = true;
        nowTime = bigChillTime;
        timerNowString = getTimerNow();
      }
      if (endedBubbles > defaultBubbles) endedBubbles = 0;
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(4, (pos) { 
                        return Container(
                          margin: EdgeInsets.all(5),
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: const Border(
                                  top: BorderSide(
                                    width: 2,
                                    color: Colors.white
                                  ),
                                  bottom: BorderSide(
                                    width: 2,
                                    color: Colors.white
                                  ),
                                  left: BorderSide(
                                    width: 2,
                                    color: Colors.white
                                  ),
                                  right: BorderSide(
                                    width: 2,
                                    color: Colors.white
                                  ),
                                ),
                                color: (endedBubbles > pos) ? Colors.white : Colors.transparent
                          ),
                        );
                      })
                    ),
                    Text(
                      timerNowString,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: restartBubble, 
                  child: Icon(CupertinoIcons.refresh),
                ),
                TextButton(
                  onPressed: skipBubble,
                  child: Icon(CupertinoIcons.forward),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}