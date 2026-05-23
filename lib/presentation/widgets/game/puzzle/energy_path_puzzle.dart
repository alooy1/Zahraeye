import 'package:flutter/material.dart';
import 'dart:math';

import '../../../../core/constants/app_constants.dart';

class EnergyPathPuzzle extends StatefulWidget {
  final String answer;
  final ValueChanged<String> onAnswerChanged;
  final Color themeColor;

  const EnergyPathPuzzle({
    super.key,
    required this.answer,
    required this.onAnswerChanged,
    required this.themeColor,
  });

  @override
  State<EnergyPathPuzzle> createState() => _EnergyPathPuzzleState();
}

class _EnergyPathPuzzleState extends State<EnergyPathPuzzle> {
  final List<_EnergyNode> _nodes = [];
  final List<_PathSegment> _path = [];
  int _currentPathIndex = 0;
  String _currentAnswer = '';

  @override
  void initState() {
    super.initState();
    _generateNodes();
  }

  void _generateNodes() {
    _nodes.clear();
    _path.clear();

    final answerLength = widget.answer.length;
    const gridSize = 5;

    // Generate nodes in a grid pattern
    final random = Random(42);
    final letters = widget.answer.toUpperCase().split('');
    final allLetters = List<String>.from(letters);

    // Add decoy letters
    const decoys = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    while (allLetters.length < gridSize * gridSize) {
      allLetters.add(decoys[random.nextInt(decoys.length)]);
    }
    allLetters.shuffle(random);

    // Create nodes
    int index = 0;
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        _nodes.add(_EnergyNode(
          id: index,
          row: row,
          col: col,
          letter: index < allLetters.length ? allLetters[index] : '',
          x: 50.0 + col * 70,
          y: 50.0 + row * 70,
          isActive: false,
          isCorrect: false,
        ));
        index++;
      }
    }

    // Mark the correct path (simple left-to-right zigzag for answer)
    for (int i = 0; i < answerLength; i++) {
      _path.add(_PathSegment(
        fromNode: i,
        toNode: i + 1,
      ));
    }

    // Mark first node as active
    if (_nodes.isNotEmpty) {
      _nodes[0].isActive = true;
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
          'Connect the energy path in order',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white70,
              ),
        ),

        const SizedBox(height: 16),

        // Current progress
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bolt, color: widget.themeColor, size: 24),
              const SizedBox(width: 8),
              Text(
                _currentAnswer.isEmpty
                    ? 'Start from the glowing node'
                    : _currentAnswer,
                style: TextStyle(
                  color: _currentAnswer.isEmpty ? Colors.white54 : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Node grid
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.galaxyPurple.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Stack(
            children: [
              // Connection lines
              CustomPaint(
                size: const Size(350, 350),
                painter: _PathPainter(
                  nodes: _nodes,
                  path: _path,
                  currentIndex: _currentPathIndex,
                  themeColor: widget.themeColor,
                ),
              ),
              // Nodes
              ..._nodes.map((node) => _buildNode(node)),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Reset button
        TextButton.icon(
          onPressed: _resetGame,
          icon: const Icon(Icons.refresh),
          label: const Text('Reset Path'),
        ),
      ],
    );
  }

  Widget _buildNode(_EnergyNode node) {
    return Positioned(
      left: node.x - 25,
      top: node.y - 25,
      child: GestureDetector(
        onTap: () => _onNodeTap(node),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: node.isActive
                ? widget.themeColor
                : (node.isCorrect
                    ? AppColors.success
                    : AppColors.primaryPurple.withOpacity(0.6)),
            border: Border.all(
              color: node.isActive
                  ? Colors.white
                  : (node.isCorrect
                      ? AppColors.success
                      : Colors.white.withOpacity(0.3)),
              width: node.isActive ? 3 : 2,
            ),
            boxShadow: node.isActive || node.isCorrect
                ? [
                    BoxShadow(
                      color: (node.isCorrect
                              ? AppColors.success
                              : widget.themeColor)
                          .withOpacity(0.6),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              node.letter,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onNodeTap(_EnergyNode node) {
    // Check if this is the next correct node
    final targetIndex = _currentPathIndex;
    final correctNodeId = targetIndex;

    if (node.id == correctNodeId && !node.isCorrect) {
      setState(() {
        node.isCorrect = true;
        node.isActive = false;
        _currentAnswer += node.letter;
        _currentPathIndex++;

        // Activate next node
        if (_currentPathIndex < _nodes.length) {
          _nodes[_currentPathIndex].isActive = true;
        }
      });

      widget.onAnswerChanged(_currentAnswer);
    }
  }

  void _resetGame() {
    setState(() {
      _currentAnswer = '';
      _currentPathIndex = 0;
    });
    _generateNodes();
  }
}

class _EnergyNode {
  final int id;
  final int row;
  final int col;
  final String letter;
  double x;
  double y;
  bool isActive;
  bool isCorrect;

  _EnergyNode({
    required this.id,
    required this.row,
    required this.col,
    required this.letter,
    required this.x,
    required this.y,
    this.isActive = false,
    this.isCorrect = false,
  });
}

class _PathSegment {
  final int fromNode;
  final int toNode;

  _PathSegment({
    required this.fromNode,
    required this.toNode,
  });
}

class _PathPainter extends CustomPainter {
  final List<_EnergyNode> nodes;
  final List<_PathSegment> path;
  final int currentIndex;
  final Color themeColor;

  _PathPainter({
    required this.nodes,
    required this.path,
    required this.currentIndex,
    required this.themeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = themeColor.withOpacity(0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw connections between correct nodes
    for (int i = 0; i < currentIndex && i < nodes.length - 1; i++) {
      final fromNode =
          nodes.where((n) => n.isCorrect && nodes.indexOf(n) == i).firstOrNull;
      final toNode = nodes
          .where((n) => n.isCorrect && nodes.indexOf(n) == i + 1)
          .firstOrNull;

      if (fromNode != null && toNode != null) {
        paint.color = AppColors.success.withOpacity(0.6);
        paint.strokeWidth = 3;
        canvas.drawLine(
          Offset(fromNode.x, fromNode.y),
          Offset(toNode.x, toNode.y),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
