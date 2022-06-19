import 'package:esforco_liquido/models/atividade.dart';
import 'package:esforco_liquido/models/sessao.dart';
import 'package:esforco_liquido/widgets/botao_gradiente.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
        builder: (_) => Temporizador(
          atividade: atividade,
        ),
      ),
    );
  }

  @override
  _State createState() => _State();
}

class _State extends State<Temporizador> with TickerProviderStateMixin {
  final _isHours = true;
  bool _isPlaying = true;
  var tempoInicial;
  List<Sessao>? sssList = [];
  late AnimationController _animationController;

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
    _animationController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
    //_animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => _negaSaida(context),
        child: Scaffold(
          backgroundColor: widget.atividade.cor,
          body: Container(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(
                  height: 70,
                ),
                Text(
                    softWrap: true,
                    widget.atividade.nome.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 50.0,
                        fontWeight: FontWeight.w700)),
                const SizedBox(
                  height: 50,
                ),
                Stack(alignment: Alignment.topCenter, children: [
                  Lottie.asset('assets/almost_white_double_circle.json',
                      width: 300,
                      controller: _animationController, onLoaded: (comp) {
                    _animationController
                      ..duration = comp.duration * 2
                      ..repeat();
                  }),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            /// Display stop watch time
                            const SizedBox(
                              height: 125,
                            ),
                            StreamBuilder<int>(
                              stream: _stopWatchTimer.rawTime,
                              initialData: _stopWatchTimer.rawTime.value,
                              builder: (context, snap) {
                                final value = snap.data!;
                                final displayTime =
                                    StopWatchTimer.getDisplayTime(
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
                              height: 150,
                            ),

                            /// Button
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                !_isPlaying
                                    ? GradientButton(
                                        title: 'Continuar',
                                        onPressed: () async {
                                          _stopWatchTimer.onExecute
                                              .add(StopWatchExecute.start);
                                          setState(() {
                                            _isPlaying = true;
                                          });
                                          _animationController.repeat();
                                        },
                                        listCor: const [
                                            Color(0xff0b134f),
                                            Color(0xff3444ba)
                                          ])
                                    : GradientButton(
                                        title: 'Pausar',
                                        onPressed: () async {
                                          _animationController.stop();
                                          _stopWatchTimer.onExecute
                                              .add(StopWatchExecute.stop);
                                          setState(() {
                                            _isPlaying = false;
                                          });
                                        },
                                        listCor: const [
                                            Color(0xff246e1b),
                                            Color(0xff78c46e)
                                          ]),
                                SizedBox(
                                  height: 10,
                                ),
                                GradientButton(
                                    title: 'Finalizar',
                                    onPressed: () {
                                      _animationController.dispose();
                                      _criaSessao(context, false);
                                    },
                                    listCor: const [
                                      Color(0xff7a1010),
                                      Color(0xffc73a3a)
                                    ]),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _criaSessao(BuildContext context, bool exit) async {
    var tempoFinal = DateTime.now();
    int totalSeconds = tempoFinal.difference(tempoInicial).inSeconds;
    var time1 = _stopWatchTimer.rawTime.value;
    int seconds = time1 ~/ 1000;
    int tempoPausa = totalSeconds - seconds;

    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    Sessao novaSessao = Sessao(
        idAtv: widget.atividade.idAtv!,
        tempoAtivo: seconds,
        tempoPausa: tempoPausa,
        inicio: tempoInicial);
    Provider.of<SessaoAtividadeProvider>(context, listen: false)
        .adicionaSessao(novaSessao, widget.atividade);
    _saveSessoes(widget.atividade.idAtv.toString());
    if (exit) {
      return;
    }
    _goToAtividadeView(context, widget.atividade);
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

  _saveSessoes(String id) async {
    SharedPreferences storedData = await SharedPreferences.getInstance();
    sssList =
        Provider.of<SessaoAtividadeProvider>(context, listen: false).listSessao;
    // int total =
    //     Provider.of<SessaoAtividadeProvider>(context, listen: false).total;
    List<String> strAtvList =
        sssList == null ? [] : sssList!.map((atv) => atv.toJson()).toList();
    //print('string $strAtvList');
    //String intId = id + "1";
    await storedData.setStringList(id, strAtvList);
    await _saveAtvs();
    // await storedData.setInt(intId, total);
  }

  _saveAtvs() async {
    SharedPreferences storedData = await SharedPreferences.getInstance();
    List<Atividade>? atvList =
        Provider.of<SessaoAtividadeProvider>(context, listen: false)
            .listAtividade;
    //print(atvList);
    List<String> strAtvList =
        atvList == null ? [] : atvList.map((atv) => atv.toJson()).toList();
    //print('string $strAtvList');
    await storedData.setStringList('listaAtividades', strAtvList);
  }

  Future<bool> _negaSaida(BuildContext context) async {
    bool? confirma = false;
    return confirma;
  }
}
