import 'package:flutter/material.dart';

import '../models/atividade.dart';
import '../views/atividade_view.dart';
import '../views/temporizador_view.dart';

class GradientPraticar extends StatelessWidget {
  List<Color> listCor;
  Atividade atividade;
  GradientPraticar({
    Key? key,
    required this.atividade,
    required this.listCor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Temporizador(atividade: atividade)));
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: listCor,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30)),
          child: Container(
            width: 120,
            height: 50,
            alignment: Alignment.center,
            child: const Text(
              'Praticar',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  List<Color> listCor;
  VoidCallback onPressed;
  String title;
  GradientButton(
      {Key? key,
      required this.title,
      required this.onPressed,
      required this.listCor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: listCor,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30)),
          child: Container(
            width: 120,
            height: 50,
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
