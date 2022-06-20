//TODO

import 'package:esforco_liquido/models/atividade.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/sessao.dart';

class SessaoAtividadeProvider with ChangeNotifier {
  List<Sessao> listSessao = [];
  List<Atividade> listAtividade = [];

  void editaAtividade(Atividade atividade, String? nome, Color cor) {}

  void excluirAtividade(Atividade atividade) {}

  void adicionaAtividade(Atividade atividade) {}

  void adicionaSessao(Sessao novaSessao, Atividade atividade) {}
}
