import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

import '../models/atividade.dart';

class Temporizador extends StatefulWidget {
  const Temporizador({Key? key, required Atividade this.atividade})
      : super(key: key);
  final Atividade atividade;
  @override
  State<Temporizador> createState() => _TemporizadorState();
}

class _TemporizadorState extends State<Temporizador> {
  final int _duration = 65;
  final CountDownController _controller = CountDownController();

  @override
  Widget build(BuildContext context) {
    Atividade atividade = widget.atividade;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(atividade.nome.toString()),
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: CircularCountDownTimer(
        // Countdown duration in Seconds.
        duration: _duration,

        // Countdown initial elapsed Duration in Seconds.
        initialDuration: 0,

        // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
        controller: _controller,

        // Width of the Countdown Widget.
        width: MediaQuery.of(context).size.width / 2,

        // Height of the Countdown Widget.
        height: MediaQuery.of(context).size.height / 2,

        // Ring Color for Countdown Widget.
        ringColor: Colors.grey[300]!,

        // Ring Gradient for Countdown Widget.
        ringGradient: null,

        // Filling Color for Countdown Widget.
        fillColor: Color.fromARGB(255, 77, 103, 147),

        // Filling Gradient for Countdown Widget.
        fillGradient: null,

        // Background Color for Countdown Widget.
        backgroundColor: Colors.blue,

        // Background Gradient for Countdown Widget.
        backgroundGradient: null,

        // Border Thickness of the Countdown Ring.
        strokeWidth: 20.0,

        // Begin and end contours with a flat edge and no extension.
        strokeCap: StrokeCap.round,

        // Text Style for Countdown Text.
        textStyle: const TextStyle(
          fontSize: 33.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        // Format for the Countdown Text.
        textFormat: CountdownTextFormat.HH_MM_SS,

        // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
        isReverse: false,

        // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
        isReverseAnimation: false,

        // Handles visibility of the Countdown Text.
        isTimerTextShown: true,

        // Handles the timer start.
        autoStart: false,

        // This Callback will execute when the Countdown Starts.
        onStart: () {
          // Here, do whatever you want
          debugPrint('Countdown Started');
        },

        // This Callback will execute when the Countdown Ends.
        onComplete: () {
          // Here, do whatever you want
          debugPrint('Countdown Ended');
        },
      )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 30,
          ),
          _button(title: "Start", onPressed: () => _controller.start()),
          const SizedBox(
            width: 10,
          ),
          _button(title: "Pause", onPressed: () => _controller.pause()),
          const SizedBox(
            width: 10,
          ),
          _button(title: "Resume", onPressed: () => _controller.resume()),
          const SizedBox(
            width: 10,
          ),
          _button(
              title: "Restart",
              onPressed: () => _controller.restart(duration: _duration))
        ],
      ),
    );
  }
}

Widget _button({required String title, VoidCallback? onPressed}) {
  return Expanded(
      child: ElevatedButton(
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all(Color.fromARGB(255, 41, 74, 132)),
    ),
    onPressed: onPressed,
    child: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
  ));
}
