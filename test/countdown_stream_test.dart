import 'package:countdown_stream/countdown_stream.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CountdownStream Tests', () {
    late CountdownStream countdownStream;
    setUp(() {
      countdownStream = CountdownStream(initialSeconds: 10);
    });

    test('should start and emit countdown numbers', () async {
      expect(countdownStream.currentSeconds, 10);

      countdownStream.startTimer();
      await Future.delayed(const Duration(seconds: 1));
      expect(countdownStream.currentSeconds, 9);
    });

    test('should pause and resume', () async {
      countdownStream.startTimer();
      await Future.delayed(const Duration(seconds: 2));
      countdownStream.pauseTimer();

      final pausedSeconds = countdownStream.currentSeconds;
      await Future.delayed(const Duration(seconds: 2));
      expect(countdownStream.currentSeconds, pausedSeconds, reason: 'Timer should be paused');

      countdownStream.resumeTimer();
      await Future.delayed(const Duration(seconds: 1));
      expect(countdownStream.currentSeconds, pausedSeconds - 1);
    });

    test('should reset', () async {
      countdownStream.startTimer();
      await Future.delayed(const Duration(seconds: 3));
      countdownStream.resetTimer();

      expect(countdownStream.currentSeconds, countdownStream.initialSeconds);
    });

    test('should complete', () async {
      int completionFlag = 0;
      countdownStream.onComplete = () {
        completionFlag = 1;
      };

      countdownStream.startTimer();
      await Future.delayed(Duration(seconds: countdownStream.initialSeconds + 1));
      expect(completionFlag, 1, reason: 'onComplete should be called');
    });

    tearDown(() {
      countdownStream.dispose();
    });
  });
}
