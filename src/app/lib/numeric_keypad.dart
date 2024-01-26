import 'package:flutter/material.dart';

class NumericKeyPad extends StatelessWidget {
  /// Create a widget that builds the numeric keypad
  const NumericKeyPad({
    super.key,
    required this.onInputNumber,
    required this.onClearLastInput,
    required this.onClearAll,
    required this.onInputPlusSymbol,
    required this.onInputEqual,
    required this.onInputSemiColumn,
  });
  final ValueSetter<int> onInputNumber;
  final VoidCallback onClearLastInput;
  final VoidCallback onClearAll;
  final ValueSetter<String> onInputPlusSymbol;
  final VoidCallback onInputEqual;
  final ValueSetter<String> onInputSemiColumn;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 1; i < 4; i++)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int j = 1; j < 4; j++)
                  Expanded(
                    child: Numeral(
                      number: (i - 1) * 3 + j,
                      onKeyPress: () => onInputNumber((i - 1) * 3 + j),
                    ),
                  ),
              ],
            ),
          ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Expanded(
                  child: Numeral(
                number: 0,
                onKeyPress: () => onInputNumber(0),
              )),
              Expanded(
                  child: Symbol(
                symbol: ';',
                onKeyPress: () => onInputSemiColumn(";"),
              )),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClearButton(
                  onClearLastInput: onClearLastInput,
                  onClearAll: onClearAll,
                ),
              ),
              Expanded(
                  child: Symbol(
                symbol: '+',
                onKeyPress: () => onInputPlusSymbol("+"),
              )),
              Expanded(
                  child: (EqualButton(
                onInputEqual: onInputEqual,
              ))),
            ],
          ),
        ),
      ],
    );
  }
}

/// Represents a button on the numeric keypad that contains a number.
class Numeral extends StatelessWidget {
  /// Creates a button on the numeric keypad that contains a number.
  const Numeral({
    super.key,
    required this.number,
    required this.onKeyPress,
  });

  final int number;
  final VoidCallback onKeyPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFF1F4FE),
          shape: const CircleBorder(),
        ),
        onPressed: onKeyPress,
        child: Text('$number'),
      ),
    );
  }
}

class ClearButton extends StatelessWidget {
  const ClearButton({
    super.key,
    required this.onClearLastInput,
    required this.onClearAll,
  });

  final VoidCallback onClearLastInput;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onClearAll,
      child: IconButton(
        onPressed: onClearLastInput,
        icon: const Icon(
          Icons.backspace,
          color: Color(0xFFF1F4FE),
        ),
      ),
    );
  }
}

class Symbol extends StatelessWidget {
  /// Creates a button on the numeric keypad that contains a number.
  const Symbol({
    super.key,
    required this.symbol,
    required this.onKeyPress,
  });

  final String symbol;
  final VoidCallback onKeyPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFF1F4FE),
          shape: const CircleBorder(),
        ),
        onPressed: onKeyPress,
        child: Text(symbol),
      ),
    );
  }
}

class EqualButton extends StatelessWidget {
  const EqualButton({
    super.key,
    required this.onInputEqual,
  });

  final VoidCallback onInputEqual;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: IconButton(
        onPressed: onInputEqual,
        icon: const Icon(
          Icons.chevron_right,
          color: Color(0xFFF1F4FE),
        ),
      ),
    );
  }
}
