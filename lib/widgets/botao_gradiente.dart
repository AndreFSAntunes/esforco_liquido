// TODO

import 'package:flutter/material.dart';

import '../models/atividade.dart';

Widget GradientPraticar(
    {required Atividade atividade, required List<Color> listCor}) {
  return Text('');
}

Widget GradientButton(
    {required List<Color> listCor,
    required String title,
    required VoidCallback onPressed}) {
  return ElevatedButton(onPressed: onPressed, child: Text(title));
}
