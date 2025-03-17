import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'background_cubit.dart';

class BackgroundView extends StatelessWidget {
  const BackgroundView({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Stack(
        children: [
          // Static complex backdrop
          RepaintBoundary(
            child: CustomPaint(
              isComplex: true,
              willChange: false,
              painter: DashedBoxesPainter(),
              size: Size.infinite,
            ),
          ),

          // Control button
          Positioned(
            bottom: 16,
            right: 16,
            child: RepaintBoundary(
              child: BlocBuilder<BackgroundCubit, BackgroundState>(
                buildWhen: (previous, current) =>
                    previous.isRunning != current.isRunning,
                builder: (context, state) {
                  if (state.isRunning) {
                    return FloatingActionButton(
                      backgroundColor: Colors.red,
                      key: const Key('stop_simulation'),
                      child: const Icon(Icons.stop),
                      onPressed: () =>
                          context.read<BackgroundCubit>().stopSimulation(),
                    );
                  } else {
                    return FloatingActionButton(
                      backgroundColor: Colors.green,
                      key: const Key('start_simulation'),
                      child: const Icon(Icons.play_arrow),
                      onPressed: () =>
                          context.read<BackgroundCubit>().startSimulation(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashedBoxesPainter extends CustomPainter {
  static const boxCount = 10;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.save();
    canvas.translate(center.dx, center.dy);

    final side = sqrt(size.shortestSide * size.shortestSide / 2);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 1.0;

    for (int i = 0; i < boxCount; i++) {
      canvas.rotate(2 * pi / boxCount);
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: side,
        height: side,
      );
      final path = Path()..addRect(rect);
      canvas.drawPathDashed(
          path: path, paint: paint, dashLength: 2, dashGap: 3);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DashedBoxesPainter oldDelegate) => false;
}

extension CanvasX on Canvas {
  void drawPathDashed({
    required Path path,
    required Paint paint,
    required double dashLength,
    required double dashGap,
  }) {
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      for (double length = 0;
          length < pathMetric.length;
          length += dashLength + dashGap) {
        final dashPath = pathMetric.extractPath(length, length + dashLength);
        drawPath(dashPath, paint);
      }
    }
  }
}
