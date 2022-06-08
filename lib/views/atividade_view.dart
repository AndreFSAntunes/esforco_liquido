import 'package:esforco_liquido/models/atividade.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/list_atividade.dart';

class AtividadeView extends StatefulWidget {
  final Atividade atividade;

  const AtividadeView({
    required this.atividade,
    Key? key,
  }) : super(key: key);

  @override
  State<AtividadeView> createState() => _AtividadeViewState(atividade);
}

class _AtividadeViewState extends State<AtividadeView> {
  _AtividadeViewState(atividade);

  @override
  Widget build(BuildContext context) {
    var atividade;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: widget.atividade.cor,
          title: Text(widget.atividade.nome.toString()),
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                Provider.of<ListaAtividade>(context, listen: false)
                    .excluir(widget.atividade);
                _saveAtvs();
                Navigator.pop(context);
              },
              child: Text('delete')),
        ));
  }

  //TODO mudar para o provider ListaAtividade
  _saveAtvs() async {
    SharedPreferences storedData = await SharedPreferences.getInstance();
    List<Atividade>? atvList =
        Provider.of<ListaAtividade>(context, listen: false).listAtividade;
    List<String> strAtvList =
        atvList == null ? [] : atvList.map((atv) => atv.toJson()).toList();
    await storedData.setStringList('listaAtividades', strAtvList);
  }
}
