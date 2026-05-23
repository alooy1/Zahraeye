import 'package:flutter/material.dart';
import 'dart:math';

import '../../../../core/constants/app_constants.dart';

class FragmentMergePuzzle extends StatefulWidget {
  final String answer;
  final ValueChanged<String> onAnswerChanged;
  final Color themeColor;

  const FragmentMergePuzzle({
    super.key,
    required this.answer,
    required this.onAnswerChanged,
    required this.themeColor,
  });

  @override
  State<FragmentMergePuzzle> createState() => _FragmentMergePuzzleState();
}

class _FragmentMergePuzzleState extends State<FragmentMergePuzzle> {
  final List<_Fragment> _fragments = [];
  final List<_DropZone> _dropZones = [];
  String _currentAnswer = '';

  @override
  void initState() {
    super.initState();
    _generateFragments();
  }

  void _generateFragments() {
    final answerLength = widget.answer.length;
    final fragmentCount = (answerLength / 3).ceil().clamp(2, 4);
    final fragmentSize = (answerLength / fragmentCount).ceil();

    _fragments.clear();
    _dropZones.clear();

    // Create fragments
    int charIndex = 0;
    for (int i = 0; i < fragmentCount; i++) {
      final fragmentText = StringBuffer();
      for (int j = 0; j < fragmentSize && charIndex < answerLength; j++) {
        fragmentText.write(widget.answer[charIndex]);
        charIndex++;
      }

      _fragments.add(_Fragment(
        id: i,
        text: fragmentText.toString(),
        position: const Offset(-1, -1),
        isPlaced: false,
      ));
    }

    // Shuffle fragments
    _fragments.shuffle(Random());

    // Create drop zones
    for (int i = 0; i < fragmentCount; i++) {
      _dropZones.add(_DropZone(
        id: i,
        expectedFragment: i,
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
          'Drag fragments to the correct order',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white70,
              ),
        ),

        const SizedBox(height: 24),

        // Drop zones
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _dropZones.map((zone) {
            final placedFragment = _fragments
                .where(
                  (f) =>
                      f.isPlaced &&
                      _dropZones.indexOf(zone) == _fragments.indexOf(f),
                )
                .firstOrNull;

            return DragTarget<_Fragment>(
              onWillAcceptWithDetails: (details) => true,
              onAcceptWithDetails: (details) {
                _onFragmentDropped(details.data, zone.id);
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 80,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: candidateData.isNotEmpty
                        ? AppColors.success.withOpacity(0.3)
                        : AppColors.glassWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: candidateData.isNotEmpty
                          ? AppColors.success
                          : AppColors.glassBorder,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      placedFragment?.text ?? '?',
                      style: TextStyle(
                        color: placedFragment != null
                            ? Colors.white
                            : Colors.white30,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 40),

        // Draggable fragments
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: _fragments.map((fragment) {
            if (fragment.isPlaced) return const SizedBox.shrink();

            return Draggable<_Fragment>(
              data: fragment,
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  width: 80,
                  height: 50,
                  decoration: BoxDecoration(
                    color: widget.themeColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: widget.themeColor.withOpacity(0.5),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      fragment.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              childWhenDragging: Container(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Container(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  color: widget.themeColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Center(
                  child: Text(
                    fragment.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // Reset button
        TextButton.icon(
          onPressed: _resetGame,
          icon: const Icon(Icons.refresh),
          label: const Text('Reset'),
        ),
      ],
    );
  }

  void _onFragmentDropped(_Fragment fragment, int zoneId) {
    setState(() {
      // Remove from previous zone if any
      for (int i = 0; i < _fragments.length; i++) {
        if (_fragments[i].id == fragment.id) {
          _fragments[i] = _Fragment(
            id: fragment.id,
            text: fragment.text,
            position: fragment.position,
            isPlaced: true,
          );
          break;
        }
      }
    });

    // Check if all fragments are placed
    _checkCompletion();
  }

  void _checkCompletion() {
    final placedFragments = _fragments.where((f) => f.isPlaced).toList();
    if (placedFragments.length != _dropZones.length) return;

    // Construct answer from placed fragments in zone order
    final answer = StringBuffer();
    for (final zone in _dropZones) {
      final fragment = _fragments.firstWhere(
        (f) => f.isPlaced && _fragments.indexOf(f) == zone.id,
        orElse: () =>
            _Fragment(id: -1, text: '', position: Offset.zero, isPlaced: false),
      );
      answer.write(fragment.text);
    }

    _currentAnswer = answer.toString();
    widget.onAnswerChanged(_currentAnswer);
  }

  void _resetGame() {
    setState(() {
      _currentAnswer = '';
    });
    _generateFragments();
  }
}

class _Fragment {
  final int id;
  final String text;
  Offset position;
  bool isPlaced;

  _Fragment({
    required this.id,
    required this.text,
    required this.position,
    this.isPlaced = false,
  });
}

class _DropZone {
  final int id;
  final int expectedFragment;

  _DropZone({
    required this.id,
    required this.expectedFragment,
  });
}
