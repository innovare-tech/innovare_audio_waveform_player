import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innovare_audio_waveform_player/innovare_audio_waveform_player.dart';

void main() {
  group('InnovareAudioWaveformPlayer', () {
    const testUri = 'https://example.com/test.mp3';
    const testWaveform = [0.1, 0.3, 0.7, 0.4, 0.8, 0.2, 0.9];

    testWidgets('creates widget with required parameters', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InnovareAudioWaveformPlayer(
              uri: testUri,
              waveform: testWaveform,
            ),
          ),
        ),
      );

      expect(find.byType(InnovareAudioWaveformPlayer), findsOneWidget);
      expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);
    });

    testWidgets('displays play button initially', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InnovareAudioWaveformPlayer(
              uri: testUri,
              waveform: testWaveform,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);
      expect(find.byIcon(Icons.pause_circle_filled), findsNothing);
    });

    testWidgets('shows speed control with default 1.0x', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InnovareAudioWaveformPlayer(
              uri: testUri,
              waveform: testWaveform,
            ),
          ),
        ),
      );

      expect(find.text('1.0x'), findsOneWidget);
    });

    testWidgets('cycles through speed options when tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InnovareAudioWaveformPlayer(
              uri: testUri,
              waveform: testWaveform,
            ),
          ),
        ),
      );

      // Initial speed should be 1.0x
      expect(find.text('1.0x'), findsOneWidget);

      // Tap speed control
      await tester.tap(find.text('1.0x'));
      await tester.pump();

      // Speed should change to 1.5x
      expect(find.text('1.5x'), findsOneWidget);

      // Tap again
      await tester.tap(find.text('1.5x'));
      await tester.pump();

      // Speed should change to 2.0x
      expect(find.text('2.0x'), findsOneWidget);

      // Tap again to cycle back
      await tester.tap(find.text('2.0x'));
      await tester.pump();

      // Should cycle back to 1.0x
      expect(find.text('1.0x'), findsOneWidget);
    });

    testWidgets('displays time format correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InnovareAudioWaveformPlayer(
              uri: testUri,
              waveform: testWaveform,
            ),
          ),
        ),
      );

      // Should display initial time format
      expect(find.textContaining('0:00:00 / 0:00:00'), findsOneWidget);
    });

    testWidgets('applies custom colors correctly', (tester) async {
      const customAccentColor = Colors.red;
      const customBackgroundColor = Colors.blue;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InnovareAudioWaveformPlayer(
              uri: testUri,
              waveform: testWaveform,
              accentColor: customAccentColor,
              backgroundColor: customBackgroundColor,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      expect(container.color, customBackgroundColor);
    });

    testWidgets('handles custom height parameter', (tester) async {
      const customHeight = 50.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InnovareAudioWaveformPlayer(
              uri: testUri,
              waveform: testWaveform,
              height: customHeight,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.byType(SizedBox).first,
      );
      expect(sizedBox.height, customHeight);
    });

    testWidgets('handles empty waveform gracefully', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InnovareAudioWaveformPlayer(
              uri: testUri,
              waveform: [],
            ),
          ),
        ),
      );

      expect(find.byType(InnovareAudioWaveformPlayer), findsOneWidget);
    });

    testWidgets('handles waveform with zero values', (tester) async {
      const zeroWaveform = [0.0, 0.0, 0.0];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InnovareAudioWaveformPlayer(
              uri: testUri,
              waveform: zeroWaveform,
            ),
          ),
        ),
      );

      expect(find.byType(InnovareAudioWaveformPlayer), findsOneWidget);
    });

    testWidgets('constrains width correctly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InnovareAudioWaveformPlayer(
              uri: testUri,
              waveform: testWaveform,
            ),
          ),
        ),
      );

      final constrainedBox = tester.widget<ConstrainedBox>(
        find.byType(ConstrainedBox),
      );

      // Should be 45% of screen width (800 * 0.45 = 360)
      expect(constrainedBox.constraints.maxWidth, 360.0);
    });

    group('Parameter validation', () {
      testWidgets('throws assertion error for negative height', (tester) async {
        expect(
              () => InnovareAudioWaveformPlayer(
            uri: testUri,
            waveform: testWaveform,
            height: -10,
          ),
          throwsAssertionError,
        );
      });

      testWidgets('throws assertion error for zero height', (tester) async {
        expect(
              () => InnovareAudioWaveformPlayer(
            uri: testUri,
            waveform: testWaveform,
            height: 0,
          ),
          throwsAssertionError,
        );
      });
    });

    group('Gradient support', () {
      testWidgets('accepts custom gradient for played waveform', (tester) async {
        const gradient = LinearGradient(
          colors: [Colors.red, Colors.blue],
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: InnovareAudioWaveformPlayer(
                uri: testUri,
                waveform: testWaveform,
                playedWaveformGradient: gradient,
              ),
            ),
          ),
        );

        expect(find.byType(InnovareAudioWaveformPlayer), findsOneWidget);
      });
    });
  });
}
