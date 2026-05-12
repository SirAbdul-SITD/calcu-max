import 'package:flutter/material.dart';
import '../models/conversion_category.dart';
import '../utils/conversion_logic.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  ConversionCategory _selectedCategory = ConversionCategory.length;
  String _fromUnit = 'Meter';
  String _toUnit = 'Kilometer';
  final TextEditingController _inputController = TextEditingController();
  String _result = '0';

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_convert);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _convert() {
    final input = _inputController.text;
    if (input.isEmpty || double.tryParse(input) == null) {
      setState(() => _result = '0');
      return;
    }

    final value = double.parse(input);
    final converted = ConversionLogic.convert(
      value,
      _fromUnit,
      _toUnit,
      _selectedCategory,
    );

    setState(() {
      _result = _formatResult(converted);
    });
  }

  String _formatResult(double value) {
    if (value.abs() < 0.0001 && value != 0) {
      return value.toStringAsExponential(4);
    }
    final str = value.toStringAsFixed(6);
    final trimmed = str.replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
    return trimmed.isEmpty ? '0' : trimmed;
  }

  void _onCategoryChanged(ConversionCategory? category) {
    if (category == null) return;
    
    setState(() {
      _selectedCategory = category;
      final units = ConversionLogic.getUnitsForCategory(category);
      _fromUnit = units.first;
      _toUnit = units.length > 1 ? units[1] : units.first;
    });
    _convert();
  }

  void _swapUnits() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
    });
    _convert();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final units = ConversionLogic.getUnitsForCategory(_selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Converter'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category selector
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DropdownButton<ConversionCategory>(
                  value: _selectedCategory,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ConversionCategory.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          Icon(category.icon, size: 20),
                          const SizedBox(width: 12),
                          Text(category.displayName),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: _onCategoryChanged,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // From unit
            Text(
              'From',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _inputController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                      ),
                    ),
                    const Divider(),
                    DropdownButton<String>(
                      value: _fromUnit,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: units.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _fromUnit = value);
                          _convert();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Swap button
            Center(
              child: IconButton.filled(
                onPressed: _swapUnits,
                icon: const Icon(Icons.swap_vert),
                iconSize: 32,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // To unit
            Text(
              'To',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Card(
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        _result,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const Divider(),
                    DropdownButton<String>(
                      value: _toUnit,
                      isExpanded: true,
                      underline: const SizedBox(),
                      dropdownColor: colorScheme.primaryContainer,
                      items: units.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(
                            unit,
                            style: TextStyle(color: colorScheme.onPrimaryContainer),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _toUnit = value);
                          _convert();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
