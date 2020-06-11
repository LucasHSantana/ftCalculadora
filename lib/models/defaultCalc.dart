// Classe que faz todas as operações de calculo ao ser pressionado algo no teclado
import 'dart:io';

import 'dart:math';

class Memory {
  static const OPER = ['%', '÷', 'x', '-', '+', '=', '¹/x', 'x²', '√'];
  final _buffer = [0.0, 0.0];
  int _bufferIndex = 0;
  bool _wipeValue = false;
  bool _wipeAll = false;
  bool _isSpecial = false;
  String _value = '0';
  String _expandedText = '';
  String _operation = '';
  String _lastOperation = '';

  Memory(){
    _allClear();
  }

  //Função chamada no callback dos botões, determina o que será feito
  void applyCommand(String command) {
    if (_wipeAll){
      _allClear();    
    }

    // Caso for pressionado o botão "C", todas as váriaveis serão limpas.
    if (command == 'C') { 
      _allClear();
    // Caso for pressionado o botão "CE", será limpo a váriavel de valor atual (somente a entrada atual).
    } else if (command == 'CE'){
      _cancelEntry();
    // Caso for pressionado algum botão de operador,
    // será setada a operação correspondente e realizado o calculo se necessário.
    } else if (OPER.contains(command)) {
      _setOperation(command);
    // Caso for pressionado algum outro botão, como os números, 
    // será feita a operação referente a isto
    } else {
      _addDigit(command);
    }
  }

  // Adiciona os valores digitados em uma lista para depois serem calculados
  // Também altera a variável _value para mostrar o valor selecionado na tela.
  _addDigit(String digit) {
    final isDot = digit == '.';
    // Se o valor for 0 e o botão pressionado não for '.' ou se está marcado para apagar o valor da tela
    // o valor será substituído pelo novo valor selecionado, caso contrário será mantido o valor zero
    // Ex: valor atual = '0', foi pressionado o valor '8'. Valor atual passa a ser '8'
    // Ex2: valor atual = '0', foi pressionado o valor '.'. Valor atual passa a ser '0.'
    final wipeValue = (_value == '0' && !isDot) || _wipeValue;

    // Se o digito pressionado for '.', mantém o valor 0, senão deixa vazio.
    final emptyValue = isDot ? '0' : '';

    // Se já existe o digito '.' no valor, ignora caso seja pressionado novamente.
    if (isDot && _value.contains(digit) && !wipeValue) {
      return;
    }

    // Insere no valor as validações acima.
    _value = wipeValue ? emptyValue : _value;
    _value += digit;

    _wipeValue = false;

    // Insere na lista o valor
    // Como o valor pressionado vem como string, tenta fazer um parse para double
    // se não conseguir, deixa como valor 0.
    _buffer[_bufferIndex] = double.tryParse(_value) ?? 0;
  }

  _setOperation(String newOperation) {
    // Sempre que for pressionado um operador, a próxima vez que pressionar um número,
    // O valor será limpo para mostrar o número pressionado corretamente.
    _wipeValue = true;

    if (_bufferIndex == 1 && _buffer[1] == 0.0) {
      _buffer[1] = double.tryParse(_value) ?? 0;
    }

    // Se o operador for '%', tem uma execução diferenciada
    if (newOperation == '%') {
      _doPercent();
      return;
    } else if (newOperation == '¹/x') {
      _doFrac();
      return;
    } else if (newOperation == 'x²') {
      _doExp();
      return;
    } else if (newOperation == '√') {
      _doSqrt();
      return;
    }

    // Se for pressionado um operador diferente de '=' porém o 
    // operador pressionado anteriormente for '=', terá uma tratativa diferenciada
    if (_lastOperation == '=' && (newOperation != '=')) {
      _buffer[0] = double.tryParse(_value) ?? 0;
      _buffer[1] = 0.0;
      _expandedText = _value + ' ' + newOperation + ' ';
    } else if (newOperation == '=' && _lastOperation == '='){      
      _buffer[0] = double.tryParse(_value) ?? 0;
      _expandedText = _value + ' ' + _operation + ' ' + _tryInt(_buffer[1]) + ' ' + newOperation + ' ';      
      _doOperation();
      return;
    }

    // Se o operador anterior for "especial", 
    // O valor será mostrado de forma diferenciada na tela.
    if (_isSpecial) {
      _expandedText += newOperation + ' ';    
    // Operadores normais serão mostrados normalmente na tela
    } else if (_bufferIndex == 0 || _buffer[1] != 0.0) {
      if (_expandedText == '0'){
        _expandedText = _value + ' ' + newOperation + ' ';
      } else {
        _expandedText += _value + ' ' + newOperation + ' ';
      }      
    }    

    // Caso tenha sido pressionado um operador e depois pressionado outro operador sem digitar um valor,
    // apenas troca o simbolo, para não deixar o simbolo errado na tela
    if (_operation != '' && newOperation != _operation && _buffer[1] == 0.0){
      _expandedText = _expandedText.replaceFirst(_operation, newOperation, _expandedText.length -2);
    }

    _bufferIndex = 1;
    
    if (_buffer[1] != 0.0) {
      _doOperation();
    }

    if (newOperation != '='){
      _operation = newOperation;
    }

    _lastOperation = newOperation;
    _isSpecial = false;
  }

  // Operação quando for pressionado '%'
  _doPercent() {
    if (_bufferIndex == 0){
      _value = '0';
      _buffer[0] = 0;
      _expandedText = _value;
    } else {
      _value = (_buffer[0] * (_buffer[1] / 100)).toString();
      _buffer[1] = double.tryParse(_value) ?? 0;
      _expandedText += _value + ' ';
      _isSpecial = true;
    }
  }

  _doFrac() {
    double value = _bufferIndex == 0 ? _buffer[0] : _buffer[1];

    if (value == 0.0) {
      _value = 'Não é possível dividir por zero‬';
      _wipeAll = true;
      return;
    }

    try {      
      _expandedText += '1/(' + value.toString() + ') ';
      value = (1 / value);
      _value = value.toString();
      if (_bufferIndex == 0) {
        _buffer[0] = value;
      } else {
        _buffer[1] = value;
      }

      _isSpecial = true;
    } catch(e) {      
      _value = e.errMsg();
    }
  }

  _doExp() {
    double value = _bufferIndex == 0 ? _buffer[0] : _buffer[1];

    _expandedText += 'sqr(' + _value + ') ';
    value = pow(value, 2);
    _value = value.toString();
    if (_bufferIndex == 0) {
      _buffer[0] = value;
    } else {
      _buffer[1] = value;
    }

    _isSpecial = true;
  }

  _doSqrt() {
    double value = _bufferIndex == 0 ? _buffer[0] : _buffer[1];

    _expandedText += '√(' + _value + ') ';
    value = sqrt(value);
    _value = value.toString();

    if (_bufferIndex == 0) {
      _buffer[0] = value;
    } else {
      _buffer[1] = value;
    }

    _isSpecial = true;
  }

  // Operações realizadas
  _doOperation() {
    switch (_operation) {
      case '÷':
        _buffer[0] = _buffer[0] / _buffer[1];
        break;
      case 'x':
        _buffer[0] = _buffer[0] * _buffer[1];
        break;
      case '-':
        _buffer[0] = _buffer[0] - _buffer[1];
        break;
      case '+':
        _buffer[0] = _buffer[0] + _buffer[1];
        break;
      default:
        break;
    }

    // _buffer[1] = 0.0;

    _value = _tryInt(_buffer[0]);
  }

  // Tenta converter valor para inteiro, senão retorna valor original
  _tryInt(double value){
    if (value % 1 == 0) {
      return value.toInt().toString();
    } else {
      return value.toString();
    }
  }

  // Limpa todas as variáveis
  _allClear() {
    _value = '0';
    _expandedText = '';
    _buffer[0] = 0.0;
    _buffer[1] = 0.0;
    _bufferIndex = 0;
    _operation = '';
    _lastOperation = '';
    _isSpecial = false;
    _wipeValue = false;
    _wipeAll = false;
  }

  _cancelEntry(){
    _value = '0';
    _buffer[1] = 0.0;
  }

  // getter do _value
  String get value {
    return _value;
  }

  // getter do _expandedText
  String get expandedText {
    return _expandedText;
  }
}
