// Componente que compõe os botões do teclado (números e operadores)

import 'package:flutter/material.dart';
import 'button_row.dart';
import 'button.dart';

// Classes stateless seguem a estrutura abaixo
class Keyboard extends StatelessWidget {
  final void Function(String) cb; //Funcão de callback

  //Construtor
  Keyboard(this.cb);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Column(
        children: <Widget>[
          ButtonRow([
            Button.big(text: 'C', cb: cb, color: Button.DARK),
            Button(text: 'CE', cb: cb, color: Button.DARK),
            Button.operation(text: '%', cb: cb),
          ]),

          SizedBox(height: 1),

          ButtonRow([
            Button.operation(text: '¹/x', cb: cb),
            Button.operation(text: 'x²', cb: cb),
            Button.operation(text: '√', cb: cb),
            Button.operation(text: '÷', cb: cb),
          ]),

          SizedBox(height: 1),

          ButtonRow([
            Button(text: '7', cb: cb),
            Button(text: '8', cb: cb),
            Button(text: '9', cb: cb),
            Button.operation(text: 'x', cb: cb),
          ]),

          SizedBox(height: 1),

          ButtonRow([
            Button(text: '4', cb: cb),
            Button(text: '5', cb: cb),
            Button(text: '6', cb: cb),
            Button.operation(text: '-', cb: cb),
          ]),

          SizedBox(height: 1),

          ButtonRow([
            Button(text: '1', cb: cb),
            Button(text: '2', cb: cb),
            Button(text: '3', cb: cb),
            Button.operation(text: '+', cb: cb),
          ]),        

          SizedBox(height: 1),

          ButtonRow([
            Button(text: '+/-', cb: cb),
            Button(text: '0', cb: cb),
            Button(text: '.', cb: cb),
            Button.operation(text: '=', cb: cb),
          ]),
        ],
      ),
      
    );
  }
}