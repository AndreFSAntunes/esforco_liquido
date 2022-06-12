import 'package:esforco_liquido/models/atividade.dart';
import 'package:esforco_liquido/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sessao.dart';
import '../providers/AtividadeSessaoProvider.dart';

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
  List<Sessao>? sssList = [];

  @override
  void initState() {
    super.initState();
    _getSessoes();
  }

  @override
  Widget build(BuildContext context) {
    var atividade;
    String idStr = widget.atividade.id.toString();
    Provider.of<SessaoAtividadeProvider>(context, listen: false).listSessao =
        sssList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.atividade.cor,
        // titleSpacing: 0,
        // leading: ElevatedButton.icon(
        //     onPressed: _gotoHome(context),
        //     icon: const Icon(Icons.home),
        //     label: const Text('home')),
        title: Text(widget.atividade.nome.toString()),
        centerTitle: true,
        actions: [
          ElevatedButton.icon(
              onPressed: () => _Delete(widget.atividade),
              icon: const Icon(Icons.delete),
              label: const Text(''))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('id: $idStr'),
            ),
            Consumer<SessaoAtividadeProvider>(
              builder: (context, listaSessoes, child) => Center(
                child: (sssList?.isEmpty ?? true)
                    ? const Center(child: Text('nenhuma sessao'))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: sssList?.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(sssList![index].toString()),
                          );
                        }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //TODO mudar para o provider ListaAtividade
  _saveAtvs() async {
    SharedPreferences storedData = await SharedPreferences.getInstance();
    List<Atividade>? atvList =
        Provider.of<SessaoAtividadeProvider>(context, listen: false)
            .listAtividade;
    List<String> strAtvList =
        atvList == null ? [] : atvList.map((atv) => atv.toJson()).toList();
    await storedData.setStringList('listaAtividades', strAtvList);
  }

  _gotoHome(BuildContext context) {
    Navigator.pop(context);
  }

  _Delete(Atividade atividade) {
    Provider.of<SessaoAtividadeProvider>(context, listen: false)
        .excluirAtividade(atividade);
    _saveAtvs();
    Navigator.pop(context);
  }

  void _getSessoes() async {
    SharedPreferences storedData = await SharedPreferences.getInstance();
    List<String>? decoded = storedData.getStringList('listaSessoes');
    sssList = decoded == null
        ? []
        : decoded.map((item) => Sessao.fromJson(item)).toList();
    //print('from SP $sssList');
    setState(() {});
  }
}
