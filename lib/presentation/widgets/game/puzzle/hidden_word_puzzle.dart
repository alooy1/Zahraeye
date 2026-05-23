import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class HiddenWordPuzzle extends StatefulWidget {
  final String answer;
  final ValueChanged<String> onAnswerChanged;
  final Color themeColor;

  const HiddenWordPuzzle({
    super.key,
    required this.answer,
    required this.onAnswerChanged,
    required this.themeColor,
  });

  @override
  State<HiddenWordPuzzle> createState() => _HiddenWordPuzzleState();
}

class _HiddenWordPuzzleState extends State<HiddenWordPuzzle> {
  late List<List<String>> _grid;
  final Set<String> _selectedPositions = {};
  String _currentWord = '';
  final List<String> _foundWords = [];

  @override
  void initState() {
    super.initState();
    _generateGrid();
  }

  void _generateGrid() {
    // Create a grid with the answer and random letters
    const gridSize = 8;
    _grid =
        List.generate(gridSize, (row) => List.generate(gridSize, (col) => ''));

    // Place the answer (horizontal)
    final startCol = (gridSize - widget.answer.length) ~/ 2;
    for (int i = 0; i < widget.answer.length; i++) {
      _grid[gridSize ~/ 2][startCol + i] = widget.answer[i];
    }

    // Fill remaining with random letters
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (_grid[r][c].isEmpty) {
          _grid[r][c] = letters[(r * c + r + c) % letters.length];
        }
      }
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
          'Find the hidden word',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white70,
              ),
        ),

        const SizedBox(height: 16),

        // Grid
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: 64,
            itemBuilder: (context, index) {
              final row = index ~/ 8;
              final col = index % 8;
              final letter = _grid[row][col];
              final isSelected = _selectedPositions.contains('$row-$col');

              return GestureDetector(
                onTap: () => _onCellTap(row, col),
                onPanStart: (details) {
                  _selectedPositions.clear();
                  _currentWord = '';
                  _onCellTap(row, col);
                },
                onPanUpdate: (details) {
                  _onCellTap(row, col);
                },
                onPanEnd: (_) => _onSelectionComplete(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? widget.themeColor.withOpacity(0.7)
                        : AppColors.galaxyPurple.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      letter,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        // Current selection
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Text(
            _currentWord.isEmpty ? 'Select letters' : _currentWord,
            style: TextStyle(
              color: _currentWord.isEmpty ? Colors.white38 : Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Found words
        if (_foundWords.isNotEmpty)
          Wrap(
            spacing: 8,
            children: _foundWords.map((word) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.success),
                ),
                child: Text(
                  word,
                  style: const TextStyle(color: AppColors.success),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  void _onCellTap(int row, int col) {
    final pos = '$row-$col';
    if (!_selectedPositions.contains(pos)) {
      setState(() {
        _selectedPositions.add(pos);
        _currentWord += _grid[row][col];
      });
    }
  }

  void _onSelectionComplete() {
    if (_currentWord.toUpperCase() == widget.answer.toUpperCase()) {
      // Found the answer!
      widget.onAnswerChanged(_currentWord);
      setState(() {
        _foundWords.add(_currentWord);
        _selectedPositions.clear();
        _currentWord = '';
      });
    } else {
      setState(() {
        _selectedPositions.clear();
        _currentWord = '';
      });
    }
  }
}
