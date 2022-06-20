import 'dart:async';

import 'package:flutter/material.dart';

class InfoView extends StatefulWidget {
  const InfoView({Key? key}) : super(key: key);

  @override
  State<InfoView> createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Projeto Integrador'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            fadeItem(
                Image.asset(
                  'assets/logo_univesp_positivo.png',
                ),
                0,
                10),
            fadeItem(textItem('Projeto Integrador II ', 20), 1, 10),
            fadeItem(
                Row(
                  children: [
                    Expanded(child: textItem('Desenvolvimento em Flutter', 20)),
                    const FlutterLogo(
                      size: 50,
                    )
                  ],
                ),
                2,
                10),
            fadeItem(textItem('Alunos:', 20), 3, 10),
            nomesAlunos('Ana Priscilla de Proença Oliveira', ' RA 2015383'),
            nomesAlunos('André Felipe da Silva Antunes', 'RA 1903543'),
            nomesAlunos('Carla Aparecida Cravo', 'RA 2009547'),
            nomesAlunos('Danilo Pires Dos Santos', 'RA 2012153'),
            nomesAlunos('Dhione Rodrigues de Souza', 'RA 2011707'),
            nomesAlunos('Edevaldo dos Santos Pereira', 'RA 2011802'),
            nomesAlunos('Paulo Roberto de Sousa de Castro', 'RA 2005448'),
            nomesAlunos('Roberto Gomes de Godoy Junior', 'RA 2011706'),
            fadeItem(textItem('Orientador:', 20), 4, 10),
            fadeItem(textItem('Alex Ramos da Silva', 17), 3, 2),
          ],
        ),
      ),
    );
  }
}

Widget nomesAlunos(String nome, String RA) {
  return fadeItem(
      Row(
        children: [
          Expanded(child: textItem(nome, 15)),
          SizedBox(
            width: 2,
          ),
          textItem(RA, 13),
        ],
      ),
      3,
      2);
}

Widget textItem(String texto, double fontSize) {
  return Text(
    texto,
    softWrap: true,
    style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
  );
}

Widget fadeItem(Widget widget, int milis, double vertical) {
  return Center(
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: vertical),
          child: SlideFadeTransition(
            delayStart: Duration(milliseconds: milis * 150),
            child: widget,
          )));
}

///Wrapper class to implement slide and fade animations at the same time to
///a given element. Wrap the widget that you wish to appear with slide-fade
///transition in this class.

enum Direction { vertical, horizontal }

class SlideFadeTransition extends StatefulWidget {
  ///The child on which to apply the given [SlideFadeTransition]
  final Widget child;

  ///The offset by which to slide and [child] into view from [Direction].
  ///Defaults to 1.0
  final double offset;

  ///The curve used to animate the [child] into view.
  ///Defaults to [Curves.easeIn]
  final Curve curve;

  ///The direction from which to animate the [child] into view. [Direction.horizontal]
  ///will make the child slide on x-axis by [offset] and [Direction.vertical] on y-axis.
  ///Defaults to [Direction.vertical]
  final Direction direction;

  ///The delay with which to animate the [child]. Takes in a [Duration] and
  /// defaults to 0.0 seconds
  final Duration delayStart;

  ///The total duration in which the animation completes. Defaults to 800 milliseconds
  final Duration animationDuration;

  SlideFadeTransition({
    required this.child,
    this.offset = 1.0,
    this.curve = Curves.easeIn,
    this.direction = Direction.vertical,
    this.delayStart = const Duration(seconds: 0),
    this.animationDuration = const Duration(milliseconds: 800),
  });
  @override
  _SlideFadeTransitionState createState() => _SlideFadeTransitionState();
}

class _SlideFadeTransitionState extends State<SlideFadeTransition>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _animationSlide;

  late AnimationController _animationController;

  late Animation<double> _animationFade;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    //configure the animation controller as per the direction
    if (widget.direction == Direction.vertical) {
      _animationSlide = Tween<Offset>(
              begin: Offset(0, widget.offset), end: const Offset(0, 0))
          .animate(CurvedAnimation(
        curve: widget.curve,
        parent: _animationController,
      ));
    } else {
      _animationSlide = Tween<Offset>(
              begin: Offset(widget.offset, 0), end: const Offset(0, 0))
          .animate(CurvedAnimation(
        curve: widget.curve,
        parent: _animationController,
      ));
    }

    _animationFade =
        Tween<double>(begin: -1.0, end: 1.0).animate(CurvedAnimation(
      curve: widget.curve,
      parent: _animationController,
    ));

    Timer(widget.delayStart, () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationFade,
      child: SlideTransition(
        position: _animationSlide,
        child: widget.child,
      ),
    );
  }
}
