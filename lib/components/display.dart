//Componente que mostra os valores digitados e calculados

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

// Classes stateless seguem a estrutura abaixo
class Display extends StatelessWidget {
  final String text; //Valor padrão digitado/calculado
  final String expandedText; //Valores concatenados conforme operações são realizadas. Ex: '10 + 5 - 3 / 2'

  // Construtor
  Display(this.text, this.expandedText);

  @override
  Widget build(BuildContext context) {
    //Expanded, expande os componentes dentro dele para se adaptar a tela
    return Expanded(
      flex: 1,
      child: Container(
        color: Color.fromRGBO(48, 48, 48, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              // AutoSizeText é um componente de texto que se redimensiona caso ultrapasse o tamanho da tela.
              // Precisa colocar o componente como dependência no arquivo pubspec.yaml, pois não é um componente padrão.            
              child: AutoSizeText( 
                expandedText,
                minFontSize: 12, //Tamanho mínimo a ser redimensionado
                maxFontSize: 20, //Tamanho máximo a ser redimensionado
                maxLines: 3, // Quantidade máxima de linhas caso tenha quebras de linha, ao passar do máximo o texto é simplemente cortado.
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                text,
                minFontSize: 20,
                maxFontSize: 80,
                maxLines: 1,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  decoration: TextDecoration.none,
                  fontSize: 80,
                  color: Colors.white,
                ),
              ),
            ),                
          ]
        ),
      ),
    );
  }
}