import 'package:esforco_liquido/views/temporizador_view.dart';
import 'package:flutter/material.dart';

import '../models/atividade.dart';
import '../views/atividade_view.dart';

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
                      left: 20.0, right: 5.0, top: 33.0, bottom: 33.0),
                  //texto do objeto Materia
                  child: Container(
                    width: box_width - 200,
                    child: Text(
                      atividade.nome.toString(),
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                //botao_estudar(),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Temporizador(nome: atividade.nome)));
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
                          // todo - adicionar view temporizador
                          'Praticar',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
