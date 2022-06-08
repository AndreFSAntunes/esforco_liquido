import 'dart:convert';
import 'package:flutter/material.dart';

class Atividade {
  String? nome;
  Color? cor;

  Atividade({this.nome, this.cor});

  @override
  String toString() {
    return "Atividade: $nome\nCor: $cor";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'cor': cor?.value,
    };
  }

  factory Atividade.fromMap(Map<String, dynamic> map) {
    return Atividade(
      nome: map['nome'] != null ? map['nome'] as String : null,
      cor: map['cor'] != null ? Color(map['cor'] as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Atividade.fromJson(String source) =>
      Atividade.fromMap(json.decode(source) as Map<String, dynamic>);
}
