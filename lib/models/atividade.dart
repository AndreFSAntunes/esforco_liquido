// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Atividade {
  String? nome;
  Color? cor;
  int? id;
  // Todo - ID da atividade

  Atividade(this.nome, this.cor, {int? id}) {
    this.nome = nome;
    this.cor = cor;
    this.id = id == null ? UniqueKey().hashCode : id;
  }

  @override
  String toString() {
    String idStr = id.toString();
    return "Atividade: $nome\nCor: $cor\n ID: $idStr";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'cor': cor?.value,
      'id': id,
    };
  }

  factory Atividade.fromMap(Map<String, dynamic> map) {
    return Atividade(
      map['nome'] != null ? map['nome'] as String : null,
      map['cor'] != null ? Color(map['cor'] as int) : null,
      id: map['id'] != null ? map['id'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Atividade.fromJson(String source) =>
      Atividade.fromMap(json.decode(source) as Map<String, dynamic>);
}
