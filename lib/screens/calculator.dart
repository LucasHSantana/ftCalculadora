// Componente principal

import 'package:Calculadora/models/memory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/display.dart';
import '../components/keyboard.dart';

// Classes stateful seguem a estrutura abaixo
class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final Memory memory = Memory();

  //Callback function para controlar a calculadora
  _onPressed(String command) {
    setState(() {
      memory.applyCommand(command);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    //App sempre começa com MaterialApp
    return MaterialApp(
      title: 'Calculadora', //Título do aplicativo
      debugShowCheckedModeBanner: false, //Esconde o banner de debug (faixa vermelha no canto superior direito)
      home: Scaffold(
        backgroundColor: Colors.grey, //Cor de fundo do aplicativo        
        body: Column( 
          children: <Widget>[
            Display(memory.value, memory.expandedText), //componente que mostra os valores digitados/calculados
            Keyboard(_onPressed), //componente que compõe os botões de valores e operações
          ],
        ),
      ),
    );
  }
}
