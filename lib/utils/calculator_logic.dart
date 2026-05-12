class CalculatorLogic {
  String _display = '0';
  String _expression = '';
  double? _firstOperand;
  String? _operator;
  bool _shouldResetDisplay = false;

  Map<String, String> handleInput(String input) {
    switch (input) {
      case 'C':
        _clear();
        break;
      case '⌫':
        _backspace();
        break;
      case '±':
        _toggleSign();
        break;
      case '+':
      case '-':
      case '×':
      case '÷':
      case '%':
        _handleOperator(input);
        break;
      case '=':
        _calculate();
        break;
      case '.':
        _handleDecimal();
        break;
      default:
        _handleNumber(input);
    }

    return {
      'display': _display,
      'expression': _expression,
    };
  }

  void _clear() {
    _display = '0';
    _expression = '';
    _firstOperand = null;
    _operator = null;
    _shouldResetDisplay = false;
  }

  void _backspace() {
    if (_shouldResetDisplay) return;
    
    if (_display.length > 1) {
      _display = _display.substring(0, _display.length - 1);
    } else {
      _display = '0';
    }
  }

  void _toggleSign() {
    if (_display == '0') return;
    
    if (_display.startsWith('-')) {
      _display = _display.substring(1);
    } else {
      _display = '-$_display';
    }
  }

  void _handleNumber(String number) {
    if (_shouldResetDisplay) {
      _display = number;
      _shouldResetDisplay = false;
    } else {
      _display = _display == '0' ? number : _display + number;
    }
  }

  void _handleDecimal() {
    if (_shouldResetDisplay) {
      _display = '0.';
      _shouldResetDisplay = false;
      return;
    }
    
    if (!_display.contains('.')) {
      _display += '.';
    }
  }

  void _handleOperator(String operator) {
    final currentValue = double.tryParse(_display);
    if (currentValue == null) return;

    if (_firstOperand == null) {
      _firstOperand = currentValue;
      _expression = '$_display $operator';
    } else if (_operator != null) {
      _calculate();
      _expression = '$_display $operator';
    }

    _operator = operator;
    _shouldResetDisplay = true;
  }

  void _calculate() {
    if (_firstOperand == null || _operator == null) return;

    final secondOperand = double.tryParse(_display);
    if (secondOperand == null) return;

    double result;
    
    switch (_operator) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '-':
        result = _firstOperand! - secondOperand;
        break;
      case '×':
        result = _firstOperand! * secondOperand;
        break;
      case '÷':
        if (secondOperand == 0) {
          _display = 'Error';
          _expression = '';
          _firstOperand = null;
          _operator = null;
          _shouldResetDisplay = true;
          return;
        }
        result = _firstOperand! / secondOperand;
        break;
      case '%':
        result = _firstOperand! % secondOperand;
        break;
      default:
        return;
    }

    _expression = '$_firstOperand $_operator $secondOperand =';
    _display = _formatResult(result);
    _firstOperand = result;
    _operator = null;
    _shouldResetDisplay = true;
  }

  String _formatResult(double value) {
    if (value.isInfinite || value.isNaN) {
      return 'Error';
    }

    // Remove unnecessary decimal places
    if (value == value.toInt()) {
      return value.toInt().toString();
    }

    // Limit to 10 decimal places
    String result = value.toStringAsFixed(10);
    result = result.replaceAll(RegExp(r'0*$'), '');
    result = result.replaceAll(RegExp(r'\.$'), '');
    
    return result;
  }
}
