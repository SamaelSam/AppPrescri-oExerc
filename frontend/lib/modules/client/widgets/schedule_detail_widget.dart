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
    _initOrLoadVideo();
  }

  void _initOrLoadVideo() {
    final exId = widget.schedule.exerciseIds[currentExerciseIndex];
    final exercise = widget.exerciseController.exercises
        .firstWhereOrNull((e) => e.id == exId);

    if (exercise?.videoUrl != null) {
      final videoId =
          YoutubePlayerController.convertUrlToId(exercise!.videoUrl!);
      if (videoId != null) {
        if (_youtubeController == null) {
          // Cria o controller uma vez
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
          // Apenas troca o vídeo
          _youtubeController!.loadVideoById(videoId: videoId);
        }
        return;
      }
    }

    // Se não houver vídeo
    _youtubeController?.close();
    _youtubeController = null;
  }

  @override
  void dispose() {
    _youtubeController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exId = widget.schedule.exerciseIds[currentExerciseIndex];
    final exercise = widget.exerciseController.exercises
        .firstWhereOrNull((e) => e.id == exId);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Exercício ${currentExerciseIndex + 1} de ${widget.schedule.exerciseIds.length}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (exercise != null) ...[
                    Text(
                      exercise.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
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
                    const Text(
                      'Descrição:',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      exercise.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                  ],
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: currentExerciseIndex > 0
                            ? () {
                                setState(() {
                                  currentExerciseIndex--;
                                  _initOrLoadVideo();
                                });
                              }
                            : null,
                        child: const Text('Anterior'),
                      ),
                      ElevatedButton(
                        onPressed: currentExerciseIndex <
                                widget.schedule.exerciseIds.length - 1
                            ? () {
                                setState(() {
                                  currentExerciseIndex++;
                                  _initOrLoadVideo();
                                });
                              }
                            : null,
                        child: const Text('Próximo'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
