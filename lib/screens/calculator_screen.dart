import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/calculator_logic.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorLogic _calculator = CalculatorLogic();
  String _display = '0';
  String _expression = '';

  void _onButtonPressed(String value) {
    setState(() {
      final result = _calculator.handleInput(value);
      _display = result['display'] ?? '0';
      _expression = result['expression'] ?? '';
    });
    
    if (value == '=' || value == 'C' || value == '⌫') {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Display area
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_expression.isNotEmpty)
                    Text(
                      _expression,
                      style: TextStyle(
                        fontSize: 20,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _display,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Button grid
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  _buildButtonRow(['C', '⌫', '%', '÷']),
                  _buildButtonRow(['7', '8', '9', '×']),
                  _buildButtonRow(['4', '5', '6', '-']),
                  _buildButtonRow(['1', '2', '3', '+']),
                  _buildButtonRow(['±', '0', '.', '=']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((button) => _buildButton(button)).toList(),
      ),
    );
  }

  Widget _buildButton(String text) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Color getButtonColor() {
      if (text == '=') {
        return colorScheme.primary;
      } else if (['÷', '×', '-', '+', '%'].contains(text)) {
        return colorScheme.secondaryContainer;
      } else if (['C', '⌫'].contains(text)) {
        return colorScheme.errorContainer;
      }
      return colorScheme.surfaceContainerHighest;
    }

    Color getTextColor() {
      if (text == '=') {
        return colorScheme.onPrimary;
      } else if (['÷', '×', '-', '+', '%'].contains(text)) {
        return colorScheme.onSecondaryContainer;
      } else if (['C', '⌫'].contains(text)) {
        return colorScheme.onErrorContainer;
      }
      return colorScheme.onSurface;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: getButtonColor(),
            foregroundColor: getTextColor(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            elevation: 0,
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
