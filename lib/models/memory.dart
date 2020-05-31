class Memory {
  static const OPER = ['%', '/', 'x', '-', '+', '='];
  final _buffer = [0.0, 0.0];
  int _bufferIndex = 0;
  bool _wipeValue = false;
  bool _isPercent = false;
  String _value = '0';
  String _expandedText = '';
  String _operation;

  void applyCommand(String command) {
    if (command == 'AC') {
      _allClear();
    } else if (OPER.contains(command)) {
      _setOperation(command);
    } else {
      _addDigit(command);
    }
  }

  _addDigit(String digit) {
    final isDot = digit == '.';
    final wipeValue = (_value == '0' && !isDot) || _wipeValue;
    final emptyValue = isDot ? '0' : '';

    if (isDot && _value.contains(digit) && !wipeValue) {
      return;
    }

    _value = wipeValue ? emptyValue : _value;
    _value += digit;

    _wipeValue = false;

    _buffer[_bufferIndex] = double.tryParse(_value) ?? 0;
  }

  _setOperation(String newOperation) {
    if (newOperation == '%' && _buffer[1] != 0.0) {
      _doPercent();
      return;
    }

    if (newOperation == '=' && _isPercent) {
      _expandedText += newOperation + ' ';
    } else if (_bufferIndex == 0 || _buffer[1] != 0.0) {
      _expandedText += _value + ' ' + newOperation + ' ';
    }

    if (_operation == '=' && newOperation != '=') {
      _buffer[0] = double.tryParse(_value) ?? 0;
      _buffer[1] = 0.0;
      _expandedText = _value + ' ' + newOperation + ' ';
    }

    _bufferIndex = 1;

    _wipeValue = true;
    if (_buffer[1] != 0.0) {
      _doOperation();
    }

    _operation = newOperation;
    _isPercent = false;
  }

  _doPercent() {
    _value = (_buffer[1] / 100).toString();
    _buffer[1] = double.tryParse(_value) ?? 0;
    _expandedText += _value + ' ';
    _isPercent = true;
  }

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

  String get value {
    return _value;
  }

  String get expandedText {
    return _expandedText;
  }
}
