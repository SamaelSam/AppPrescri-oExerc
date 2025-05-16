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
    _initVideo();
  }

  void _initVideo() {
    final exId = widget.schedule.exerciseIds[currentExerciseIndex];
    final exercise = widget.exerciseController.exercises
        .firstWhereOrNull((e) => e.id == exId);

    if (exercise?.videoUrl != null) {
      final videoId =
          YoutubePlayerController.convertUrlToId(exercise!.videoUrl!);
      if (videoId != null) {
        final novoController = YoutubePlayerController.fromVideoId(
          videoId: videoId,
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
            enableJavaScript: true,
            playsInline: true,
          ),
        );

        _youtubeController?.close();
        setState(() {
          _youtubeController = novoController;
        });
        return;
      }
    }

    _youtubeController?.close();
    setState(() {
      _youtubeController = null;
    });
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

    return SizedBox(
      width: 400,
      height: 500,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Exercício ${currentExerciseIndex + 1} de ${widget.schedule.exerciseIds.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (exercise != null) ...[
              Text(
                exercise.name,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              if (_youtubeController != null)
                SizedBox(
                  width: double.infinity,
                  height: 260,
                  child: YoutubePlayer(
                    controller: _youtubeController!,
                    aspectRatio: 16 / 9,
                  ),
                )
              else
                const Text(
                  'Vídeo não disponível para este exercício.',
                  style: TextStyle(color: Colors.grey),
                ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    exercise.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentExerciseIndex > 0
                      ? () {
                          setState(() {
                            currentExerciseIndex--;
                            _initVideo();
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
                            _initVideo();
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
    );
  }
}
