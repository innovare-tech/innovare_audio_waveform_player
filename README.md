# Innovare Audio Waveform Player

A customizable audio waveform player widget for Flutter with animated transitions, play-pulse effects, and dynamic theming.

[![pub package](https://img.shields.io/pub/v/innovare_audio_waveform_player.svg)](https://pub.dev/packages/innovare_audio_waveform_player)
[![popularity](https://img.shields.io/pub/popularity/innovare_audio_waveform_player?logo=dart)](https://pub.dev/packages/innovare_audio_waveform_player/score)
[![likes](https://img.shields.io/pub/likes/innovare_audio_waveform_player?logo=dart)](https://pub.dev/packages/innovare_audio_waveform_player/score)
[![pub points](https://img.shields.io/pub/points/innovare_audio_waveform_player?logo=dart)](https://pub.dev/packages/innovare_audio_waveform_player/score)

## Features

- 🎵 **Interactive Waveform Visualization** - Tap or drag to seek through audio
- ▶️ **Play/Pause Controls** - With animated pulse effects
- ⚡ **Speed Control** - Toggle between 1.0x, 1.5x, and 2.0x playback speeds
- 🎨 **Customizable Theming** - Colors, gradients, and dimensions
- 📱 **Responsive Design** - Adapts to different screen sizes
- ⏱️ **Progress Tracking** - Visual and time-based progress indicators
- 🌐 **Cross-Platform** - Works on Android, iOS, Web, macOS, Windows, and Linux

## Preview

![Waveform Player Demo](https://raw.githubusercontent.com/yourusername/innovare_audio_waveform_player/main/assets/demo.gif)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  innovare_audio_waveform_player: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:innovare_audio_waveform_player/innovare_audio_waveform_player.dart';

InnovareAudioWaveformPlayer(
  uri: 'https://example.com/audio.mp3',
  waveform: [0.1, 0.3, 0.7, 0.4, 0.8, 0.2, 0.9],
)
```

### Advanced Usage

```dart
InnovareAudioWaveformPlayer(
  uri: 'https://example.com/audio.mp3',
  waveform: [0.1, 0.3, 0.7, 0.4, 0.8, 0.2, 0.9],
  height: 40,
  accentColor: Colors.blue,
  backgroundColor: Colors.grey.shade900,
  playedWaveformGradient: LinearGradient(
    colors: [Colors.blue, Colors.purple],
  ),
)
```

### Custom Theming Example

```dart
InnovareAudioWaveformPlayer(
  uri: 'assets/audio/sample.mp3',
  waveform: waveformData,
  height: 50,
  accentColor: Colors.green,
  backgroundColor: const Color(0xFF1A1A2E),
  playedWaveformGradient: const LinearGradient(
    colors: [Colors.green, Colors.teal, Colors.blue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `uri` | `String` | **required** | Audio file URI (URL or asset path) |
| `waveform` | `List<double>` | **required** | Normalized waveform amplitudes (0.0 to 1.0) |
| `height` | `double` | `30` | Height of the waveform visualization |
| `accentColor` | `Color` | `Colors.blueAccent` | Primary accent color for the player |
| `backgroundColor` | `Color` | `Color(0xFF1C1C1E)` | Background color of the player container |
| `playedWaveformGradient` | `Gradient?` | `null` | Optional gradient for the played portion |

## Generating Waveform Data

The widget requires waveform data as a list of normalized amplitudes. Here are some approaches to generate this data:

### 1. Audio Analysis Libraries

You can use audio processing libraries to extract waveform data:

```dart
// Example with audio analysis
Future<List<double>> generateWaveform(String audioPath) async {
  // Use libraries like 'fftea', 'flutter_audio_waveforms', etc.
  // This is a simplified example
  return [0.1, 0.3, 0.7, 0.4, 0.8, 0.2, 0.9, 0.6, 0.3, 0.5];
}
```

### 2. Pre-computed Data

For better performance, pre-compute waveform data on your server:

```dart
// Load pre-computed waveform from API
Future<List<double>> loadWaveform(String audioId) async {
  final response = await http.get(Uri.parse('https://api.example.com/waveform/$audioId'));
  final data = json.decode(response.body);
  return List<double>.from(data['waveform']);
}
```

### 3. Static Sample Data

For testing or demo purposes:

```dart
static const demoWaveform = [
  0.1, 0.3, 0.7, 0.4, 0.8, 0.2, 0.9, 0.6, 0.3, 0.5,
  0.8, 0.4, 0.7, 0.9, 0.2, 0.6, 0.4, 0.8, 0.3, 0.7,
  0.5, 0.9, 0.1, 0.6, 0.8, 0.3, 0.7, 0.4, 0.9, 0.2,
];
```

## Platform Support

| Platform | Support |
|----------|---------|
| Android | ✅ |
| iOS | ✅ |
| Web | ✅ |
| macOS | ✅ |
| Windows | ✅ |
| Linux | ✅ |

## Dependencies

This package depends on:
- [`just_audio`](https://pub.dev/packages/just_audio) for audio playback
- [`flutter/material.dart`](https://api.flutter.dev/flutter/material/material-library.html) for UI components

## Example

Check out the [example](example/) directory for a complete demo application showing various configurations and use cases.

To run the example:

```bash
cd example
flutter run
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Clone the repository
2. Install dependencies: `flutter pub get`
3. Run tests: `flutter test`
4. Run the example: `cd example && flutter run`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes.

## Support

If you find this package helpful, please give it a ⭐ on [GitHub](https://github.com/yourusername/innovare_audio_waveform_player) and a 👍 on [pub.dev](https://pub.dev/packages/innovare_audio_waveform_player)!

For issues and feature requests, please use the [GitHub Issues](https://github.com/yourusername/innovare_audio_waveform_player/issues) page.