import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// TODO

class Sessao {
  int idAtv;
  int tempoAtivo;
  int tempoPausa;
  DateTime inicio;

  Sessao({
    required this.idAtv,
    required this.tempoAtivo,
    required this.tempoPausa,
    required this.inicio,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idAtv': idAtv,
      'tempoAtivo': tempoAtivo,
      'tempoPausa': tempoPausa,
      'inicio': inicio.millisecondsSinceEpoch,
    };
  }

  factory Sessao.fromMap(Map<String, dynamic> map) {
    return Sessao(
      idAtv: map['idAtv'] as int,
      tempoAtivo: map['tempoAtivo'] as int,
      tempoPausa: map['tempoPausa'] as int,
      inicio: DateTime.fromMillisecondsSinceEpoch(map['inicio'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Sessao.fromJson(String source) =>
      Sessao.fromMap(json.decode(source) as Map<String, dynamic>);
}
