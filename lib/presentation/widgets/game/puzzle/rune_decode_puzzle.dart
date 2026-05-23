import 'package:flutter/material.dart';
import 'dart:math';

import '../../../../core/constants/app_constants.dart';

class RuneDecodePuzzle extends StatefulWidget {
  final String answer;
  final ValueChanged<String> onAnswerChanged;
  final Color themeColor;

  const RuneDecodePuzzle({
    super.key,
    required this.answer,
    required this.onAnswerChanged,
    required this.themeColor,
  });

  @override
  State<RuneDecodePuzzle> createState() => _RuneDecodePuzzleState();
}

class _RuneDecodePuzzleState extends State<RuneDecodePuzzle> {
  // Runic symbols for each letter
  static const Map<String, String> _runeMap = {
    'A': 'ᚠ', // ᚠ
    'B': 'ᚢ', // ᚢ
    'C': 'ᚦ', // ᚦ
    'D': 'ᚨ', // ᚨ
    'E': 'ᚪ', // ᚱ
    'F': 'ᚫ', // ᚲ
    'G': 'ᚭ', // ᚷ
    'H': 'ᚮ', // ᚹ
    'I': 'ᚰ', // ᚺ
    'J': 'ᚱ', // ᚾ
    'K': 'ᚲ', // ᛁ
    'L': 'ᚳ', // ᛃ
    'M': 'ᚴ', // ᛈ
    'N': 'ᚷ', // ᛉ
    'O': 'ᚸ', // ᛊ
    'P': 'ᚹ', // ᛋ
    'Q': 'ᚻ', // ᛏ
    'R': 'ᚼ', // ᛐ
    'S': 'ᚾ', // ᛒ
    'T': 'ᚿ', // ᛓ
    'U': 'ᛁ', // ᛡ
    'V': 'ᛂ', // ᛢ
    'W': 'ᛃ', // ᛣ
    'X': 'ᛄ', // ᛤ
    'Y': 'ᛅ', // ᛥ
    'Z': 'ᛆ', // ᛦ
  };

  final Map<int, String> _userInput = {};
  final List<String> _availableRunes = [];

  @override
  void initState() {
    super.initState();
    _generateAvailableRunes();
  }

  void _generateAvailableRunes() {
    final runes = widget.answer.toUpperCase().split('').map((letter) {
      return _runeMap[letter] ?? letter;
    }).toList();

    // Add extra random runes
    final allRunes = _runeMap.values.toList();
    final random = Random();
    while (runes.length < widget.answer.length * 2) {
      final randomRune = allRunes[random.nextInt(allRunes.length)];
      if (!runes.contains(randomRune)) {
        runes.add(randomRune);
      }
    }

    runes.shuffle();
    _availableRunes.addAll(runes);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Instructions
        Text(
          'Decode the ancient runes',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white70,
              ),
        ),

        const SizedBox(height: 24),

        // Answer slots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.answer.length, (index) {
            final rune = _userInput[index];
            final originalLetter = widget.answer[index].toUpperCase();
            final correctRune = _runeMap[originalLetter];
            final isCorrect = rune == correctRune;

            return GestureDetector(
              onTap: () {
                if (_userInput.containsKey(index)) {
                  setState(() {
                    final removed = _userInput.remove(index);
                    if (removed != null) {
                      _availableRunes.add(removed);
                    }
                  });
                  _updateAnswer();
                }
              },
              child: Container(
                width: 48,
                height: 56,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: rune != null
                      ? (isCorrect
                          ? AppColors.success.withOpacity(0.3)
                          : widget.themeColor.withOpacity(0.3))
                      : AppColors.glassWhite,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: rune != null
                        ? (isCorrect ? AppColors.success : widget.themeColor)
                        : Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    rune ?? '?',
                    style: TextStyle(
                      color: rune != null ? Colors.white : Colors.white30,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 32),

        // Available runes
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: _availableRunes.asMap().entries.map((entry) {
            final index = entry.key;
            final rune = entry.value;

            return GestureDetector(
              onTap: () {
                // Find first empty slot
                int? emptySlot;
                for (int i = 0; i < widget.answer.length; i++) {
                  if (!_userInput.containsKey(i)) {
                    emptySlot = i;
                    break;
                  }
                }

                if (emptySlot != null) {
                  setState(() {
                    _userInput[emptySlot!] = rune;
                    _availableRunes.removeAt(index);
                  });
                  _updateAnswer();
                }
              },
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.nebulaPink.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.nebulaPink.withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    rune,
                    style: const TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        // Letter hints
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.help_outline, size: 16, color: Colors.white54),
              const SizedBox(width: 8),
              Text(
                'Letter hint: ${widget.answer[0]}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String? _getLetterFromRune(String rune) {
    for (final entry in _runeMap.entries) {
      if (entry.value == rune) {
        return entry.key;
      }
    }
    return null;
  }

  void _updateAnswer() {
    final answer = StringBuffer();
    for (int i = 0; i < widget.answer.length; i++) {
      final rune = _userInput[i];
      if (rune != null) {
        final letter = _getLetterFromRune(rune);
        if (letter != null) {
          answer.write(letter);
        }
      }
    }
    widget.onAnswerChanged(answer.toString());
  }
}