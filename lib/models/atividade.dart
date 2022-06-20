// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Atividade {
  String? nome;
  Color? cor;
  int? idAtv;
  int? totalPratica;

  Atividade(this.nome, this.cor, {int? id, int? totalPratica}) {
    this.nome = nome;
    this.cor = cor;
    this.idAtv = id ?? UniqueKey().hashCode;
    this.totalPratica = totalPratica ?? 0;
  }

  void SomaPratica(int segundos) {
    totalPratica = (totalPratica! + segundos);
  }

  void SubtraiPratica(int segundos) {
    totalPratica = (totalPratica! - segundos);
  }

  @override
  String toString() {
    String idStr = idAtv.toString();
    return "Atividade: $nome\nTempo Pracita: ${totalPratica.toString()}\nCor: $cor\n ID: $idStr";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'cor': cor?.value,
      'idAtv': idAtv,
      'totalPratica': totalPratica,
    };
  }

  factory Atividade.fromMap(Map<String, dynamic> map) {
    return Atividade(
      map['nome'] != null ? map['nome'] as String : null,
      map['cor'] != null ? Color(map['cor'] as int) : null,
      id: map['idAtv'] != null ? map['idAtv'] as int : null,
      totalPratica:
          map['totalPratica'] != null ? map['totalPratica'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Atividade.fromJson(String source) =>
      Atividade.fromMap(json.decode(source) as Map<String, dynamic>);
}
