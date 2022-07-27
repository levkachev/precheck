import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimerWidget extends StatefulWidget {
  int startTimestamp;
  TimerWidget(this.startTimestamp);

  @override
  _TimerWidgetState createState() => _TimerWidgetState(startTimestamp);
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer? timer;

  final stopwatch = Stopwatch();

  // int initialMilliseconds = DateTime.now().millisecondsSinceEpoch - widget.startTimestamp;
  late int minutes;
  late int seconds;

  late int milliseconds;

  _TimerWidgetState(int startTimestamp) {
    int millisecondsSinceNow = DateTime.now().millisecondsSinceEpoch - startTimestamp;
    int secondsSinceNow = millisecondsSinceNow ~/ 1000;

    print(DateTime.now().millisecondsSinceEpoch);

    minutes = (secondsSinceNow / 60).toInt();
    seconds = secondsSinceNow - minutes * 60;
    milliseconds = millisecondsSinceNow;
  }

  void callback(Timer timer) {
      milliseconds += 30;
      setState(() {
        final int sec = (milliseconds / 1000).truncate();
        minutes = (sec / 60).toInt();
        seconds = sec - minutes * 60;
      });
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(milliseconds: 30), callback);
    stopwatch.start();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    stopwatch.stop();
    stopwatch.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return Row(
      children: [
        Text("$minutesStr : $secondsStr",
            style: GoogleFonts.raleway(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white70
                )
            )
        )
      ],
    );
  }
}