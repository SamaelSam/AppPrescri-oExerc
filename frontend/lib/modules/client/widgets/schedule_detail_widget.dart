import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../models/schedule_model.dart';
import '../controllers/exercise_controller.dart';

class ScheduleDetailWidget extends StatefulWidget {
  final ScheduleModel schedule;
  final ExerciseController exerciseController;

  const ScheduleDetailWidget({
    super.key,
    required this.schedule,
    required this.exerciseController,
  });

  @override
  State<ScheduleDetailWidget> createState() => _ScheduleDetailWidgetState();
}

class _ScheduleDetailWidgetState extends State<ScheduleDetailWidget> {
  int currentExerciseIndex = 0;
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() {
    final exerciseId = widget.schedule.exerciseIds[currentExerciseIndex];
    final exercise = widget.exerciseController.exercises
        .firstWhereOrNull((e) => e.id == exerciseId);

    if (exercise?.videoUrl != null) {
      final videoId = YoutubePlayerController.convertUrlToId(exercise!.videoUrl!);
      if (videoId != null) {
        if (_youtubeController == null) {
          _youtubeController = YoutubePlayerController.fromVideoId(
            videoId: videoId,
            params: const YoutubePlayerParams(
              showControls: true,
              showFullscreenButton: true,
              enableJavaScript: true,
              playsInline: true,
            ),
          );
        } else {
          _youtubeController!.loadVideoById(videoId: videoId);
        }
        return;
      }
    }

    _youtubeController?.close();
    _youtubeController = null;
  }

  @override
  void dispose() {
    _youtubeController?.close();
    super.dispose();
  }

  void _changeExercise(int newIndex) {
    setState(() {
      currentExerciseIndex = newIndex;
      _loadVideo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final exerciseId = widget.schedule.exerciseIds[currentExerciseIndex];
    final exercise = widget.exerciseController.exercises
        .firstWhereOrNull((e) => e.id == exerciseId);

    final totalExercises = widget.schedule.exerciseIds.length;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Exercício ${currentExerciseIndex + 1} de $totalExercises',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                if (exercise != null) ...[
                  Text(
                    exercise.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 10),
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _youtubeController != null
                        ? YoutubePlayer(controller: _youtubeController!)
                        : const Center(
                            child: Text(
                              'Vídeo não disponível para este exercício.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Descrição:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    exercise.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: currentExerciseIndex > 0
                          ? () => _changeExercise(currentExerciseIndex - 1)
                          : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Anterior'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: currentExerciseIndex < totalExercises - 1
                          ? () => _changeExercise(currentExerciseIndex + 1)
                          : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Próximo'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
