import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Display extends StatelessWidget {
  final String text;
  final String expandedText;

  Display(this.text, this.expandedText);

  @override
  Widget build(BuildContext context) {
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
                  child: AutoSizeText(
                    expandedText,
                    minFontSize: 12,
                    maxFontSize: 20,
                    maxLines: 3,
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