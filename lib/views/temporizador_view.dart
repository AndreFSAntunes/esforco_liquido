import 'package:esforco_liquido/models/atividade.dart';
import 'package:esforco_liquido/models/sessao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../providers/AtividadeSessaoProvider.dart';
import 'atividade_view.dart';

class Temporizador extends StatefulWidget {
  Atividade atividade;

  Temporizador({required this.atividade, Key? key}) : super(key: key);

  static Future<void> navigatorPush(
      BuildContext context, Atividade atividade) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => Temporizador(atividade: atividade),
      ),
    );
  }

  @override
  _State createState() => _State();
}

class _State extends State<Temporizador> {
  final _isHours = true;
  bool _isPlaying = true;
  var tempoInicial;
  List<Sessao>? sssList = [];

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onChange: (value) => {}, //print('onChange $value'),
    //onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    //onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
    onStop: () {
      //print('onStop');
    },
    onEnded: () {
      //print('onEnded');
    },
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _autoStart();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Center(
            widthFactor: 8, child: Text(widget.atividade.nome.toString())),
      ),
      body: Center(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /// Display stop watch time
                StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snap) {
                    final value = snap.data!;
                    final displayTime = StopWatchTimer.getDisplayTime(
                      value,
                      hours: _isHours,
                      milliSecond: false,
                    );
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            displayTime,
                            style: const TextStyle(
                                fontSize: 40,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),

                /// Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    !_isPlaying
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ElevatedButton(
                              onPressed: () async {
                                _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.start);
                                setState(() {
                                  _isPlaying = true;
                                });
                              },
                              child: const Text(
                                'Continuar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ElevatedButton(
                              onPressed: () async {
                                _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.stop);
                                setState(() {
                                  _isPlaying = false;
                                });
                              },
                              child: const Text(
                                'Pausar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () async {
                          var tempoFinal = DateTime.now();
                          int totalSeconds =
                              tempoFinal.difference(tempoInicial).inSeconds;
                          var time1 = _stopWatchTimer.rawTime.value;
                          int seconds = time1 ~/ 1000;
                          int tempoPausa = totalSeconds - seconds;

                          _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                          Sessao novaSessao = Sessao(
                              id: widget.atividade.id!,
                              tempoAtivo: seconds,
                              tempoPausa: tempoPausa,
                              inicio: tempoInicial);
                          print(novaSessao);
                          Provider.of<SessaoAtividadeProvider>(context,
                                  listen: false)
                              .adicionaSessao(novaSessao);
                          _saveSessoes();
                          _goToAtividadeView(context, widget.atividade);
                        },
                        child: const Text(
                          'Finalizar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _autoStart() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    tempoInicial = DateTime.now();
  }

  _goToAtividadeView(BuildContext context, Atividade atividade) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => AtividadeView(
                atividade: atividade,
              )),
    );
  }

  _saveSessoes() async {
    SharedPreferences storedData = await SharedPreferences.getInstance();
    sssList =
        Provider.of<SessaoAtividadeProvider>(context, listen: false).listSessao;
    //print(sssList);
    List<String> strAtvList =
        sssList == null ? [] : sssList!.map((atv) => atv.toJson()).toList();
    //print('string $strAtvList');
    await storedData.setStringList('listaSessoes', strAtvList);
  }
}
