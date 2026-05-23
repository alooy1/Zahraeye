import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/question.dart';
import '../../../domain/entities/holy_location.dart';
import '../../providers/game_providers.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/game/puzzle/swipe_connect_puzzle.dart';
import '../../widgets/game/puzzle/hidden_word_puzzle.dart';
import '../../widgets/game/puzzle/rune_decode_puzzle.dart';
import '../../widgets/game/puzzle/rotate_wheel_puzzle.dart';
import '../../widgets/game/puzzle/memory_cards_puzzle.dart';
import '../../widgets/game/puzzle/fragment_merge_puzzle.dart';
import '../../widgets/game/puzzle/energy_path_puzzle.dart';
import '../../widgets/effects/puzzle_background.dart';

class PuzzlePage extends ConsumerStatefulWidget {
  final int locationId;
  final int stageId;

  const PuzzlePage({
    super.key,
    required this.locationId,
    required this.stageId,
  });

  @override
  ConsumerState<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends ConsumerState<PuzzlePage> {
  String _currentAnswer = '';
  bool _showSuccess = false;
  bool _showFailure = false;
  int _hintsUsed = 0;
  int _timeRemaining = 120;
  bool _timerStarted = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _timerStarted == false) {
        setState(() {
          _timerStarted = true;
        });
        _runTimer();
      }
    });
  }

  void _runTimer() async {
    while (mounted && _timeRemaining > 0 && !_showSuccess) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _timeRemaining--;
        });
      }
    }
  }

  void _onAnswerChanged(String answer) {
    setState(() {
      _currentAnswer = answer;
    });
  }

  void _checkAnswer(Question question) {
    final normalizedAnswer = _currentAnswer.toUpperCase().trim();
    final correctAnswer = question.answer.toUpperCase().trim();

    if (normalizedAnswer == correctAnswer) {
      // Success!
      setState(() {
        _showSuccess = true;
      });

      // Calculate stars based on time and hints
      int stars = 1;
      if (_timeRemaining > 60 && _hintsUsed == 0) {
        stars = 3;
      } else if (_timeRemaining > 30) {
        stars = 2;
      }

      // Save progress
      ref.read(playerProgressProvider.notifier).completeStage(
            widget.locationId.toString(),
            widget.stageId,
            stars,
          );

      // Show success dialog after animation
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          _showSuccessDialog(stars);
        }
      });
    } else {
      // Failure
      setState(() {
        _showFailure = true;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _showFailure = false;
            _currentAnswer = '';
          });
        }
      });
    }
  }

  void _useHint(Question question) {
    if (_hintsUsed < question.hintsEn.length) {
      setState(() {
        _hintsUsed++;
      });
    }
  }

  void _showSuccessDialog(int stars) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.galaxyPurple.withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        ),
        title: Column(
          children: [
            const Icon(
              Icons.celebration,
              color: AppColors.starGold,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'Stage Complete!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  index < stars ? Icons.star : Icons.star_border,
                  color: AppColors.starGold,
                  size: 40,
                );
              }),
            ),
            const SizedBox(height: 16),
            Text(
              '+${stars * 50} Coins',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.glowBlue,
                  ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionFuture = ref.watch(
      currentQuestionProvider(
          (locationId: widget.locationId.toString(), stageId: widget.stageId)),
    );
    final locations = ref.watch(holyLocationsProvider);

    final location = locations.firstWhere(
      (l) => l.id == widget.locationId,
      orElse: () => locations.first,
    );

    return Scaffold(
      body: Stack(
        children: [
          // Puzzle background
          PuzzleBackground(location: location),

          // Content
          questionFuture.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.glowBlue),
            ),
            error: (e, s) => Center(
              child: Text('Error: $e',
                  style: const TextStyle(color: Colors.white)),
            ),
            data: (question) {
              if (question == null) {
                return const Center(
                  child: Text(
                    'No question available',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return _buildPuzzleContent(context, question, location);
            },
          ),

          // Success overlay
          if (_showSuccess)
            Container(
              color: AppColors.success.withOpacity(0.3),
              child: const Center(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 120,
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .scale(begin: const Offset(0.5, 0.5)),

          // Failure overlay
          if (_showFailure)
            Container(
              color: AppColors.error.withOpacity(0.3),
              child: const Center(
                child: Icon(
                  Icons.cancel,
                  color: Colors.white,
                  size: 120,
                ),
              ),
            ).animate().shake(duration: 500.ms),
        ],
      ),
    );
  }

  Widget _buildPuzzleContent(
    BuildContext context,
    Question question,
    HolyLocation location,
  ) {
    return SafeArea(
      child: Column(
        children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Row(
              children: [
                // Back button
                GestureDetector(
                  onTap: () => _showExitConfirmation(context),
                  child: const GlassCard(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Stage info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stage ${widget.stageId}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        location.nameEn,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: location.themeColor,
                            ),
                      ),
                    ],
                  ),
                ),
                // Timer
                GlassCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer,
                        color: _timeRemaining < 30
                            ? AppColors.error
                            : location.themeColor,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_timeRemaining',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: _timeRemaining < 30
                                      ? AppColors.error
                                      : Colors.white,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Question
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  question.questionEn,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Puzzle area
          Expanded(
            child: _buildPuzzleWidget(question),
          ),

          // Answer input area
          _buildAnswerArea(question),

          // Hints
          if (question.hintsEn.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _hintsUsed < question.hintsEn.length
                          ? 'Hint: ${question.hintsEn[_hintsUsed]}'
                          : 'No more hints',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
                  if (_hintsUsed < question.hintsEn.length)
                    TextButton.icon(
                      onPressed: () => _useHint(question),
                      icon: const Icon(Icons.lightbulb, size: 18),
                      label: Text(
                          'Use Hint (${_hintsUsed + 1}/${question.hintsEn.length})'),
                    ),
                ],
              ),
            ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPuzzleWidget(Question question) {
    switch (question.puzzleType) {
      case 'swipe_connect':
        return SwipeConnectPuzzle(
          answer: question.answer,
          onAnswerChanged: _onAnswerChanged,
          themeColor: AppColors.primaryPurple,
        );
      case 'hidden_word':
        return HiddenWordPuzzle(
          answer: question.answer,
          onAnswerChanged: _onAnswerChanged,
          themeColor: AppColors.primaryBlue,
        );
      case 'rune_decode':
        return RuneDecodePuzzle(
          answer: question.answer,
          onAnswerChanged: _onAnswerChanged,
          themeColor: AppColors.nebulaPink,
        );
      case 'rotate_wheel':
        return RotateWheelPuzzle(
          answer: question.answer,
          onAnswerChanged: _onAnswerChanged,
          themeColor: AppColors.starGold,
        );
      case 'memory_cards':
        return MemoryCardsPuzzle(
          answer: question.answer,
          onAnswerChanged: _onAnswerChanged,
          themeColor: AppColors.accentCyan,
        );
      case 'fragment_merge':
        return FragmentMergePuzzle(
          answer: question.answer,
          onAnswerChanged: _onAnswerChanged,
          themeColor: AppColors.karbalaGold,
        );
      case 'energy_path':
        return EnergyPathPuzzle(
          answer: question.answer,
          onAnswerChanged: _onAnswerChanged,
          themeColor: AppColors.glowPurple,
        );
      default:
        return SwipeConnectPuzzle(
          answer: question.answer,
          onAnswerChanged: _onAnswerChanged,
          themeColor: AppColors.primaryPurple,
        );
    }
  }

  Widget _buildAnswerArea(Question question) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Current answer display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentAnswer.isEmpty ? '?' : _currentAnswer,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        letterSpacing: 8,
                        color: _currentAnswer.isEmpty
                            ? Colors.white54
                            : Colors.white,
                      ),
                ),
                Text(
                  ' / ${question.answer.length}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white38,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _currentAnswer.length >= question.answer.length
                  ? () => _checkAnswer(question)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                disabledBackgroundColor: AppColors.glassWhite,
              ),
              child: const Text(
                'Submit Answer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.galaxyPurple.withOpacity(0.95),
        title: const Text('Exit Puzzle?'),
        content: const Text('Your progress in this stage will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              this.context.pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
