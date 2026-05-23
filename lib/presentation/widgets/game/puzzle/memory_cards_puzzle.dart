import 'package:flutter/material.dart';
import 'dart:math';

import '../../../../core/constants/app_constants.dart';

class MemoryCardsPuzzle extends StatefulWidget {
  final String answer;
  final ValueChanged<String> onAnswerChanged;
  final Color themeColor;

  const MemoryCardsPuzzle({
    super.key,
    required this.answer,
    required this.onAnswerChanged,
    required this.themeColor,
  });

  @override
  State<MemoryCardsPuzzle> createState() => _MemoryCardsPuzzleState();
}

class _MemoryCardsPuzzleState extends State<MemoryCardsPuzzle> {
  final List<_CardData> _cards = [];
  int? _firstFlipped;
  int? _secondFlipped;
  bool _canFlip = true;
  String _revealedLetters = '';

  @override
  void initState() {
    super.initState();
    _generateCards();
  }

  void _generateCards() {
    final letters = widget.answer.toUpperCase().split('');
    final allChars = <String>[];

    // Add all answer letters twice (for pairs)
    for (final letter in letters) {
      allChars.add(letter);
      allChars.add(letter);
    }

    // Add some extra cards to make grid fuller
    const extraChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    while (allChars.length < 16) {
      allChars.add(extraChars[random.nextInt(extraChars.length)]);
    }

    // Shuffle
    allChars.shuffle(random);

    // Create cards
    _cards.clear();
    for (int i = 0; i < allChars.length; i++) {
      _cards.add(_CardData(
        index: i,
        letter: allChars[i],
        isFlipped: false,
        isMatched: false,
      ));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Instructions
        Text(
          'Match pairs to reveal the answer',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white70,
              ),
        ),

        const SizedBox(height: 16),

        // Revealed letters
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lightbulb, color: AppColors.starGold, size: 20),
              const SizedBox(width: 8),
              Text(
                'Revealed: $_revealedLetters',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Cards grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: _cards.length,
          itemBuilder: (context, index) {
            return _buildCard(_cards[index], index);
          },
        ),

        const SizedBox(height: 16),

        // Reset button
        TextButton.icon(
          onPressed: _resetGame,
          icon: const Icon(Icons.refresh),
          label: const Text('Restart'),
        ),
      ],
    );
  }

  Widget _buildCard(_CardData card, int index) {
    final isRevealed = card.isFlipped || card.isMatched;

    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: card.isMatched
              ? AppColors.success.withOpacity(0.3)
              : (isRevealed
                  ? widget.themeColor.withOpacity(0.3)
                  : widget.themeColor.withOpacity(0.8)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: card.isMatched
                ? AppColors.success
                : (isRevealed
                    ? widget.themeColor
                    : Colors.white.withOpacity(0.3)),
            width: 2,
          ),
          boxShadow: isRevealed
              ? [
                  BoxShadow(
                    color:
                        (card.isMatched ? AppColors.success : widget.themeColor)
                            .withOpacity(0.4),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: isRevealed
              ? Text(
                  card.letter,
                  style: TextStyle(
                    color: card.isMatched ? AppColors.success : Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Icon(
                  Icons.help_outline,
                  color: Colors.white.withOpacity(0.7),
                  size: 28,
                ),
        ),
      ),
    );
  }

  void _onCardTap(int index) {
    if (!_canFlip) return;
    if (_cards[index].isFlipped || _cards[index].isMatched) return;

    setState(() {
      _cards[index].isFlipped = true;
    });

    if (_firstFlipped == null) {
      _firstFlipped = index;
    } else {
      _secondFlipped = index;
      _canFlip = false;
      _checkMatch();
    }
  }

  void _checkMatch() {
    final first = _cards[_firstFlipped!];
    final second = _cards[_secondFlipped!];

    if (first.letter == second.letter) {
      // Match!
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _cards[_firstFlipped!].isMatched = true;
          _cards[_secondFlipped!].isMatched = true;
          _revealedLetters += first.letter;
          _firstFlipped = null;
          _secondFlipped = null;
          _canFlip = true;
        });

        // Check if puzzle is complete
        if (_revealedLetters.length == widget.answer.length) {
          widget.onAnswerChanged(_revealedLetters);
        }
      });
    } else {
      // No match
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          _cards[_firstFlipped!].isFlipped = false;
          _cards[_secondFlipped!].isFlipped = false;
          _firstFlipped = null;
          _secondFlipped = null;
          _canFlip = true;
        });
      });
    }
  }

  void _resetGame() {
    setState(() {
      _revealedLetters = '';
      _firstFlipped = null;
      _secondFlipped = null;
      _canFlip = true;
    });
    _generateCards();
  }
}

class _CardData {
  final int index;
  final String letter;
  bool isFlipped;
  bool isMatched;

  _CardData({
    required this.index,
    required this.letter,
    this.isFlipped = false,
    this.isMatched = false,
  });
}
