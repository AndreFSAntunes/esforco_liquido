import 'package:flutter/material.dart';

import '../models/atividade.dart';

class ListaAtividade with ChangeNotifier {
  List<Atividade>? listAtividade = [];

  void addNew(nova) {
    listAtividade?.add(nova);
    notifyListeners();
  }

  void excluir(atv) {
    listAtividade?.remove(atv);
    notifyListeners();
  }
}
