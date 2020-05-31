// Classe que faz todas as operações de calculo ao ser pressionado algo no teclado
class Memory {
  static const OPER = ['%', '/', 'x', '-', '+', '='];
  final _buffer = [0.0, 0.0];
  int _bufferIndex = 0;
  bool _wipeValue = false;
  bool _isPercent = false;
  String _value = '0';
  String _expandedText = '';
  String _operation;

  //Função chamada no callback dos botões, determina o que será feito
  void applyCommand(String command) {
    // Caso for pressionado o botão "AC", todas as váriaveis serão limpas.
    if (command == 'AC') { 
      _allClear();
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
    // Se o operador for '%', tem uma execução diferenciada
    if (newOperation == '%' && _buffer[1] != 0.0) {
      _doPercent();
      return;
    }

    // Se for pressionado um operador diferente de '=' porém o 
    // operador pressionado anteriormente for '=', terá uma tratativa diferenciada
    if (_operation == '=' && (newOperation != '=' || newOperation == '=')) {
      _buffer[0] = double.tryParse(_value) ?? 0;
      _buffer[1] = 0.0;
      _expandedText = _value + ' ' + newOperation + ' ';
    }

    // Se o operador for '=', e o operador anterior for '%', 
    // O valor será mostrado de forma diferenciada na tela.
    if (newOperation == '=' && _isPercent) {
      _expandedText += newOperation + ' ';    
    // Operadores normais serão mostrados normalmente na tela
    } else if (_bufferIndex == 0 || _buffer[1] != 0.0) {
      _expandedText += _value + ' ' + newOperation + ' ';
    }    

    _bufferIndex = 1;

    // Sempre que for pressionado um operador, a próxima vez que pressionar um número,
    // O valor será limpo para mostrar o número pressionado corretamente.
    _wipeValue = true;
    if (_buffer[1] != 0.0) {
      _doOperation();
    }

    _operation = newOperation;
    _isPercent = false;
  }

  // Operação quando for pressionado '%'
  _doPercent() {
    _value = (_buffer[1] / 100).toString();
    _buffer[1] = double.tryParse(_value) ?? 0;
    _expandedText += _value + ' ';
    _isPercent = true;
  }

  // Operações realizadas
  _doOperation() {
    switch (_operation) {
      case '/':
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

    _buffer[1] = 0.0;

    if (_buffer[0] % 1 == 0) {
      _value = _buffer[0].toInt().toString();
    } else {
      _value = _buffer[0].toString();
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
    _isPercent = false;
    _wipeValue = false;
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
