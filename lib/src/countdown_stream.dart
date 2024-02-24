import 'dart:async';

/// A countdown timer class that provides a stream of countdown ticks.
///
/// This class allows you to start a countdown timer of a specified duration,
/// pause, resume, reset, and dispose the timer, while listening to the countdown
/// updates via a broadcast stream.
///
/// Example usage:
/// ```
/// final countdown = CountdownStream(initialSeconds: 10);
///
/// countdown.stream.listen((seconds) {
///   print('$seconds seconds remaining');
/// });
///
/// countdown.startTimer();
///
/// // Later on...
/// countdown.pauseTimer();
///
/// // And then...
/// countdown.resumeTimer();
///
/// // Finally, when done...
/// countdown.dispose();
/// ```
class CountdownStream {
  /// Initial countdown value in seconds.
  final int initialSeconds;
  /// Current countdown value in seconds.
  int currentSeconds;
  /// Timer object to manage the countdown.
  Timer? _timer;
  /// StreamController to broadcast countdown updates.
  final StreamController<int> _streamController = StreamController<int>.broadcast();
  /// Duration between each tick of the countdown.
  final Duration tickDuration;

  /// Callback functions that can be set to react to different events.
  Function()? onComplete;
  Function()? onResumed;
  Function()? onPaused;
  Function()? onReset;
  Function()? onDispose;

  /// Constructor to initialize the CountdownStream with optional initial seconds and tick duration.
  CountdownStream({
    this.initialSeconds = 120,
    int tickSeconds = 1,
  })  : currentSeconds = initialSeconds,
        tickDuration = Duration(seconds: tickSeconds);

  /// Getter to expose the stream of countdown updates.
  Stream<int> get stream => _streamController.stream;

  /// Starts or resumes the countdown timer. Optionally resets the countdown to initial seconds.
  void startTimer([bool reset = true]) {
    if (_timer != null && _timer!.isActive) return;

    if (reset) currentSeconds = initialSeconds;
    _timer = Timer.periodic(tickDuration, (Timer timer) {
      if (currentSeconds == 0) {
        stopTimer();
        if (onComplete != null) onComplete!(); // Callback when countdown completes.
      } else {
        currentSeconds--;
        _streamController.add(currentSeconds); // Update listeners with the current second.
      }
    });
  }

  /// Pauses the countdown timer if it is active.
  void pauseTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      _timer = null;
      if (onPaused != null) onPaused!(); // Callback when countdown is paused.
    }
  }

  /// Resumes the countdown from the current second if the timer is not active.
  void resumeTimer() {
    if (_timer != null || currentSeconds <= 0) return;
    startTimer(false);
    if (onResumed != null) onResumed!(); // Callback when countdown is resumed.
  }

  /// Stops the countdown timer and notifies listeners with the current second.
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _streamController.add(currentSeconds);
  }

  /// Resets the countdown timer to the initial seconds and updates listeners.
  void resetTimer() {
    stopTimer();
    currentSeconds = initialSeconds;
    _streamController.add(currentSeconds);
    if (onReset != null) onReset!(); // Callback when countdown is reset.
  }

  /// Disposes resources used by the countdown timer and stream controller.
  void dispose() {
    _timer?.cancel();
    _streamController.close();
    if (onDispose != null) onDispose!(); // Callback when object is disposed.
  }
}