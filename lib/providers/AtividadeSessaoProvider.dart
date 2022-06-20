import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/atividade.dart';
import '../models/sessao.dart';

class SessaoAtividadeProvider with ChangeNotifier {
  List<Atividade>? listAtividade = [];
  List<Sessao>? listSessao = [];

  void adicionaAtividade(nova) {
    listAtividade?.add(nova);
    notifyListeners();
  }

  Future<void> excluirAtividade(atv) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    data.remove(atv.idAtv.toString());
    listAtividade?.remove(atv);
    notifyListeners();
  }

  void adicionaSessao(Sessao nova, Atividade atividade) {
    atividade.SomaPratica(nova.tempoAtivo);
    listSessao?.add(nova);
    notifyListeners();
  }

  void excluirSessao(sessao, Atividade atividade) {
    // total = total == null
    //     ? (sessao.tempoAtivo as int)
    //     : total - (sessao.tempoAtivo as int);
    atividade.SubtraiPratica(sessao.tempoAtivo);
    listSessao?.remove(sessao);
    notifyListeners();
  }

  void editaAtividade(Atividade atividade, String? nome, Color cor) {
    atividade.nome = nome;
    atividade.cor = cor;
    notifyListeners();
  }
}
