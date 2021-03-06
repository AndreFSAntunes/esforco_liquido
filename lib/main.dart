import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/AtividadeSessaoProvider.dart';
import 'views/home_view.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => SessaoAtividadeProvider(),
      child: const EsforcoLiquidoApp()));
}

class EsforcoLiquidoApp extends StatelessWidget {
  const EsforcoLiquidoApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeView(reload: true),
    );
  }
}
