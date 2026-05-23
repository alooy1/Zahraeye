import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class SwipeConnectPuzzle extends StatefulWidget {
  final String answer;
  final ValueChanged<String> onAnswerChanged;
  final Color themeColor;

  const SwipeConnectPuzzle({
    super.key,
    required this.answer,
    required this.onAnswerChanged,
    required this.themeColor,
  });

  @override
  State<SwipeConnectPuzzle> createState() => _SwipeConnectPuzzleState();
}

class _SwipeConnectPuzzleState extends State<SwipeConnectPuzzle> {
  final List<String> _availableLetters = [];
  final List<String> _selectedLetters = [];
  final String _draggingLetter = '';

  @override
  void initState() {
    super.initState();
    _shuffleLetters();
  }

  void _shuffleLetters() {
    final letters = widget.answer.split('');
    final shuffled = List<String>.from(letters);

    // Add extra random letters
    final extraLetters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
    while (shuffled.length < 20) {
      shuffled.add(extraLetters[(shuffled.length) % extraLetters.length]);
    }

    // Shuffle the list
    shuffled.shuffle();

    setState(() {
      _availableLetters.clear();
      _availableLetters.addAll(shuffled);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Answer slots
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.answer.length, (index) {
              final letter = index < _selectedLetters.length
                  ? _selectedLetters[index]
                  : '';
              return _buildLetterSlot(letter, index);
            }),
          ),
        ),

        const SizedBox(height: 40),

        // Available letters
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: _availableLetters.asMap().entries.map((entry) {
            final letter = entry.value;
            if (_selectedLetters.contains(letter) &&
                _availableLetters.where((l) => l == letter).length <=
                    _selectedLetters.where((l) => l == letter).length) {
              return const SizedBox.shrink();
            }
            return _buildDraggableLetter(letter);
          }).toList(),
        ),

        const SizedBox(height: 20),

        // Drag indicator
        if (_draggingLetter.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.themeColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.themeColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.touch_app,
                  color: widget.themeColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Connect letters in order',
                  style: TextStyle(
                    color: widget.themeColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 20),

        // Instructions
        Text(
          'Tap letters in order to form the answer',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white54,
              ),
        ),
      ],
    );
  }

  Widget _buildLetterSlot(String letter, int index) {
    return GestureDetector(
      onTap: () {
        if (letter.isNotEmpty && index < _selectedLetters.length) {
          // Remove letter
          setState(() {
            final removed = _selectedLetters.removeAt(index);
            _availableLetters.add(removed);
            widget.onAnswerChanged(_selectedLetters.join());
          });
        }
      },
      child: Container(
        width: 40,
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: letter.isNotEmpty
              ? widget.themeColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: letter.isNotEmpty
                ? widget.themeColor
                : Colors.white.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              color: letter.isNotEmpty ? Colors.white : Colors.white30,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableLetter(String letter) {
    return GestureDetector(
      onTap: () {
        if (_selectedLetters.length < widget.answer.length) {
          setState(() {
            _selectedLetters.add(letter);
            _availableLetters.remove(letter);
            widget.onAnswerChanged(_selectedLetters.join());
          });
        }
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primaryPurple.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            letter,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
