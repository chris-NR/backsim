import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';

class BackgroundState extends Equatable {
  final bool isRunning;
  final double progress;

  const BackgroundState({this.isRunning = false, this.progress = 0});

  BackgroundState copyWith({bool? isRunning, double? progress}) {
    return BackgroundState(
        isRunning: isRunning ?? this.isRunning,
        progress: progress ?? this.progress);
  }

  @override
  List<Object?> get props => [isRunning, progress];
}

// Cubit to simulate a background task with progress updates
class BackgroundCubit extends Cubit<BackgroundState> {
  static const _length = Duration(minutes: 1);
  static const _interval = Duration(milliseconds: 100);
  static final _ticks = _length.inMilliseconds ~/ _interval.inMilliseconds;
  Timer? _timer;

  BackgroundCubit() : super(const BackgroundState());

  void startSimulation() {
    _timer?.cancel();
    _timer = Timer.periodic(_interval, _emitUpdate);
    emit(state.copyWith(isRunning: true)); // first event
  }

  void stopSimulation() {
    _timer?.cancel();
    emit(state.copyWith(isRunning: false));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _emitUpdate(Timer timer) {
    if (timer.tick < _ticks) {
      emit(state.copyWith(progress: timer.tick / _ticks));
    } else {
      stopSimulation();
    }
  }
}
