// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:esforco_liquido/views/info_view.dart';

import '../models/atividade.dart';
import '../providers/AtividadeSessaoProvider.dart';
import '../widgets/box_atividade.dart';

class HomeView extends StatefulWidget {
  bool reload;

  HomeView({
    Key? key,
    required this.reload,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Atividade> atvList = [];
  late SharedPreferences storedData;

  @override
  void initState() {
    super.initState();
    _getAtvs(widget.reload);
  }

  @override
  Widget build(BuildContext context) {
    Atividade newAtv;
    if (widget.reload) {
      Provider.of<SessaoAtividadeProvider>(context, listen: false)
          .listAtividade = atvList;
    }
    atvList = Provider.of<SessaoAtividadeProvider>(context, listen: false)
        .listAtividade!;
    return WillPopScope(
      onWillPop: () => _confirmaSaida(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Projeto Integrador'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InfoView()),
                  )
                },
                icon: const Icon(Icons.info),
                //padding: EdgeInsets.only(right: 20),
              ),
            )
          ],
        ),
        body: Consumer<SessaoAtividadeProvider>(
          builder: (context, listaAtividades, child) => Center(
            child: (atvList.isEmpty)
                ? const Center(child: Text('Adicione uma atividade'))
                : ListView.builder(
                    itemCount: atvList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: boxAtividade(atvList[index]),
                      );
                    }),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        floatingActionButton: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.red.shade200,
          onPressed: () => criarAtividadeDialog(context),
          tooltip: 'Adicionar Atividade',
          child: const Icon(Icons.add, size: 35),
        ),
      ),
    );
  }

  criarAtividadeDialog(BuildContext context) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        double test = MediaQuery.of(context).size.width * 0.4 - 120;
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
        String? nomeAtv = '';
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
                    decoration: const InputDecoration(
                        hintText: "adicione o nome da atividade "),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: const Text('Criar'),
                        onPressed: () {
                          final form = _formKey.currentState;
                          if (form != null && form.validate()) {
                            form.save();
                            _criarAtividade(context, nomeAtv, cor);
                          }
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(),
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

  _criarAtividade(BuildContext context, String? nome, Color cor) {
    Atividade newAtv = Atividade(nome, cor);
    //debugPrint(newAtv.toString());
    Provider.of<SessaoAtividadeProvider>(context, listen: false)
        .adicionaAtividade(newAtv);
    _saveAtvs();
    Navigator.pop(context);
  }

  //TODO mudar para o provider ListaAtividade
  _saveAtvs() async {
    storedData = await SharedPreferences.getInstance();
    atvList = Provider.of<SessaoAtividadeProvider>(context, listen: false)
        .listAtividade!;
    //print(atvList);
    List<String> strAtvList =
        atvList == null ? [] : atvList.map((atv) => atv.toJson()).toList();
    //print('string $strAtvList');
    await storedData.setStringList('listaAtividades', strAtvList);
  }

  void _getAtvs(reload) async {
    if (reload) {
      SharedPreferences storedData = await SharedPreferences.getInstance();
      List<String>? decoded = storedData.getStringList('listaAtividades');
      atvList = decoded == null
          ? []
          : decoded.map((item) => Atividade.fromJson(item)).toList();
      //print('from SP $atvList');
      setState(() {});
    }
  }

  Future<bool> _confirmaSaida(BuildContext context) async {
    bool? confirma = await showDialog(
        context: context, builder: (context) => _janelaConfirmacao(context));
    return confirma ?? false;
  }

  // Future<bool?> _showExitDialog(BuildContext context) async {
  //   return await showDialog(
  //     context: context,
  //     builder: (context) => _janelaConfirmacao(context),
  //   );
  // }

  AlertDialog _janelaConfirmacao(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmação'),
      content: const Text('Deseja fechar o aplicativo?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Não'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Sim'),
        ),
      ],
    );
  }
}
