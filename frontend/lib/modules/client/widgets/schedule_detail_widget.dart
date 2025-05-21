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
  final Map<String, YoutubePlayerController> _controllers = {};

  YoutubePlayerController _initYoutubeController(String url) {
    final videoId = YoutubePlayerController.convertUrlToId(url);
    return YoutubePlayerController.fromVideoId(
      videoId: videoId ?? '',
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        enableJavaScript: true,
        playsInline: true,
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercises = widget.schedule.exerciseIds
        .map((id) => widget.exerciseController.exercises
            .firstWhereOrNull((e) => e.id == id))
        .where((e) => e != null)
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index]!;
        final controller = (exercise.videoUrl != null)
            ? _controllers.putIfAbsent(
                exercise.id!,
                () => _initYoutubeController(exercise.videoUrl!),
              )
            : null;

        return Card(
          margin: const EdgeInsets.only(bottom: 24),
          elevation: 6,
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Colors.black.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Exercício ${index + 1} de ${exercises.length}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  subtitle: Text(
                    exercise.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Vídeo ou placeholder
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: controller != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: YoutubePlayer(controller: controller),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.1),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.videocam_off,
                                  size: 48,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.3),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Sem vídeo disponível',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 20),

                // Séries e Repetições
                Row(
                  children: [
                    Icon(Icons.fitness_center,
                        size: 20, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 10),
                    Text(
                      '3 séries de 10 repetições',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Intervalo
                Row(
                  children: [
                    Icon(Icons.timer,
                        size: 20, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 10),
                    Text(
                      'Intervalo de 30 segundos',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Descrição
                Text(
                  'Descrição:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  exercise.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
