# CountdownStream Package

A simple and efficient countdown timer package for Dart applications, providing a stream of countdown ticks with pause, resume, reset, and dispose capabilities.

## Features

* Start a countdown timer with a specified duration in seconds.
* Pause and resume the countdown at any time.
* Reset the countdown timer back to the initial duration.
* Listen to the countdown updates via a broadcast stream.
* Perform actions on completion, pause, resume, reset, and dispose events.

## Getting Started

To use this package, add countdown_stream as a dependency in your pubspec.yaml file.

## Installation

```yaml
dependencies:
  countdown_stream: ^0.0.1
```

Then, run the following command to get the package:

```bash
pub get
```

Or if you are using Flutter:

```bash
flutter pub get
```

## Usage

Import the package where you want to use it:

```dart
import 'package:countdown_stream/countdown_stream.dart';
```

Create a `CountdownStream` instance, listen to the countdown ticks, and control the timer as needed:

```dart
final countdown = CountdownStream(initialSeconds: 10);

countdown.stream.listen((seconds) {
  print('$seconds seconds remaining');
});

countdown.startTimer();

// To pause the countdown
countdown.pauseTimer();

// To resume the countdown
countdown.resumeTimer();

// To reset the countdown
countdown.resetTimer();

// Don't forget to dispose of the countdown stream when done
countdown.dispose();
```

## Example

```dart
void main() {
  final countdown = CountdownStream(initialSeconds: 10);

  countdown.stream.listen((seconds) {
    print('$seconds seconds remaining');
  });

  countdown.onComplete = () {
    print('Countdown completed!');
    countdown.dispose();
  };

  countdown.startTimer();
}
```

Ensure you dispose of the `CountdownStream` instance when it's no longer needed to free up resources.

