import 'package:esforco_liquido/views/temporizador_view.dart';
import 'package:flutter/material.dart';

import '../models/atividade.dart';
import '../views/atividade_view.dart';
import 'botao_gradiente.dart';

class boxAtividade extends StatelessWidget {
  Atividade atividade;

  boxAtividade(Atividade this.atividade, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double box_width = MediaQuery.of(context).size.width * 0.9;

    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Material(
        color: atividade.cor,
        borderRadius: BorderRadius.circular(20),
        //InkWell para dar effeito ao clicar
        child: InkWell(
          onTap: () => _goToAtividadeView(context, atividade),
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.black54,
          child: Container(
            // height infinite estoura
            width: double.maxFinite,
            // decoration pra deixar arredondado as pontas
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: atividade.cor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            // padding em volta do texto
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 5.0, top: 18.0, bottom: 18.0),
                  //texto do objeto Materia
                  child: Container(
                    padding: EdgeInsets.all(10),
                    //width: box_width - 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white70,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          atividade.nome.toString(),
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Total: ${_formataHm(atividade.totalPratica!)}",
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                //botao_estudar(),
                GradientPraticar(atividade: atividade, listCor: [
                  const Color(0xff374ABE),
                  const Color(0xff64B6FF)
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _formataHm(int segundos) {
    Duration duration = Duration(seconds: segundos);
    String Minutes = duration.inMinutes.remainder(60).toString();
    if (duration.inHours == 0) {
      return "${Minutes}m";
    }
    return "${duration.inHours}h ${Minutes}m";
  }

  _goToAtividadeView(BuildContext context, Atividade atividade) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AtividadeView(
                  atividade: atividade,
                )));
  }
}
