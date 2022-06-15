import 'dart:math';

import 'package:esforco_liquido/models/atividade.dart';
import 'package:esforco_liquido/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sessao.dart';
import '../providers/AtividadeSessaoProvider.dart';
import 'temporizador_view.dart';

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
  int coluna = 2;
  bool crescente = false;

  @override
  void initState() {
    super.initState();
    _getSessoes(widget.atividade.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    var atividade;
    String idStr = widget.atividade.id.toString();
    Provider.of<SessaoAtividadeProvider>(context, listen: false).listSessao =
        sssList;
    final columns = ['Prática', 'Pausa', 'Data'];
    return Consumer<SessaoAtividadeProvider>(
        builder: (context, listaAtividades, child) => Scaffold(
              appBar: AppBar(
                backgroundColor: widget.atividade.cor,
                title: Text(widget.atividade.nome.toString()),
                centerTitle: true,
                actions: [
                  IconButton(
                      onPressed: () =>
                          {editaAtividadeDialog(context, widget.atividade)},
                      icon: const Icon(Icons.edit))
                ],
              ),
              body: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Temporizador(
                                      atividade: widget.atividade)));
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xff374ABE), Color(0xff64B6FF)],
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
                    ),
                    Consumer<SessaoAtividadeProvider>(
                      builder: (context, listaSessoes, child) => Center(
                          child: (sssList
                                      ?.where((element) =>
                                          element.id == widget.atividade.id)
                                      .isEmpty ??
                                  true)
                              ? const Center(
                                  child: Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Text('nenhuma sessao'),
                                ))
                              : DataTable(
                                  sortAscending: false,
                                  sortColumnIndex: 2,
                                  columns: getColumns(columns),
                                  rows: getRows(sssList!.reversed.toList()),
                                )),
                    ),
                  ],
                ),
              ),
            ));
  }

  // void _Cronologico(int coluna, bool crescente) {
  //   if (coluna == 2) {
  //     sssList!.sort((sss1, sss2) => sss2.inicio.compareTo(sss1.inicio));
  //   }
  //   setState(() {
  //     this.coluna = coluna;
  //     this.crescente = crescente;
  //   });
  // }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            //onSort: _Cronologico,
          ))
      .toList();

  List<DataRow> getRows(List<Sessao> sessao) => sessao.map((Sessao sessao) {
        final cells = [
          Text(_formataHHmmss(sessao.tempoAtivo)),
          Text(_formataHHmmss(sessao.tempoPausa)),
          Text(_formatarData(sessao.inicio)),
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) => cells
      .map((data) => DataCell(
            GestureDetector(
              child: data,
              onLongPress: () {
                print('Long Press');
              },
            ),
          ))
      .toList();

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

  void _getSessoes(String id) async {
    SharedPreferences storedData = await SharedPreferences.getInstance();
    List<String>? decoded = storedData.getStringList(id);
    sssList = decoded == null
        ? []
        : decoded.map((item) => Sessao.fromJson(item)).toList();
    //print('from SP $sssList');
    setState(() {});
  }

  String _formatarData(DateTime inicio) {
    String dia = inicio.day.toString();
    String mes = inicio.month.toString();
    String ano = inicio.year.toString();
    return '$dia\/$mes\/$ano';
  }

  _formataHHmmss(int segundos) {
    Duration duration = Duration(seconds: segundos);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

class EditaSessao extends StatelessWidget {
  const EditaSessao({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {}, icon: const Icon(Icons.edit));
  }
}

editaAtividadeDialog(BuildContext context, Atividade atividade) => showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      double test = MediaQuery.of(context).size.width * 0.4 - 120;
      final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
      String? nomeAtv = atividade.nome;
      List<Color> colorList = [
        Colors.red,
        Colors.purple,
        Colors.deepPurple,
        Colors.indigo,
        Colors.blue,
        Colors.teal,
        Colors.green,
        Colors.yellow,
        Colors.amber,
        Colors.deepOrange,
        Colors.grey,
        Colors.blueGrey,
      ];
      Color cor = colorList[Random().nextInt(colorList.length)];
      return Dialog(
        elevation: 10,
        insetPadding: EdgeInsets.symmetric(horizontal: test),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  autofocus: true,
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      return 'adicione um nome';
                    }
                  },
                  decoration: InputDecoration(hintText: "${atividade.nome}"),
                  onSaved: (value) {
                    nomeAtv = value;
                  },
                ),
                const SizedBox(height: 25),
                Container(
                  height: 220,
                  width: 250,
                  child: BlockPicker(
                    availableColors: colorList,
                    pickerColor: cor, //default color
                    onColorChanged: (Color color) {
                      cor = color;
                    },
                  ),
                ),
                //const SizedBox(height: 25),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text('Salvar'),
                      onPressed: () {
                        final form = _formKey.currentState;
                        if (form != null && form.validate()) {
                          form.save();
                          _editarAtividade(context, nomeAtv, cor, atividade);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      child: const Text('Cancelar'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      child: const Text('Excluir'),
                      onPressed: () =>
                          deletaAtividadeDialog(context, atividade),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
              ],
            ),
          ),
        ),
      );
    });

_editarAtividade(
    BuildContext context, String? nome, Color cor, Atividade atividade) {
  Provider.of<SessaoAtividadeProvider>(context, listen: false)
      .editaAtividade(atividade, nome, cor);
  _saveAtvs(context);
  Navigator.pop(context);
}

_Delete(BuildContext context, Atividade atividade) {
  Provider.of<SessaoAtividadeProvider>(context, listen: false)
      .excluirAtividade(atividade);
  _saveAtvs(context);
  // TODO escluir sessoes
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => const HomeView(),
    ),
    (route) => false,
  );
}

_saveAtvs(BuildContext context) async {
  List<Atividade>? atvList = [];
  SharedPreferences storedData = await SharedPreferences.getInstance();
  atvList = Provider.of<SessaoAtividadeProvider>(context, listen: false)
      .listAtividade;
  //print(atvList);
  List<String> strAtvList =
      atvList == null ? [] : atvList.map((atv) => atv.toJson()).toList();
  //print('string $strAtvList');
  await storedData.setStringList('listaAtividades', strAtvList);
}

deletaAtividadeDialog(BuildContext context, Atividade atividade) => showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
          elevation: 10,
          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Confirma exclusão?'),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: const Text('Sim'),
                    onPressed: () => _Delete(context, atividade),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: const Text('Não'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              )));
    });
