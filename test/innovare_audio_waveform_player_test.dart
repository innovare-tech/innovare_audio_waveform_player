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

      // Wait for widget to initialize
      await tester.pump();

      // Look for time display pattern (may be different formats)
      final timeDisplayFinder = find.byWidgetPredicate(
            (widget) => widget is Text &&
            widget.data != null &&
            widget.data!.contains('/'),
      );

      expect(timeDisplayFinder, findsOneWidget);

      // Verify it contains time-like pattern
      final timeWidget = tester.widget<Text>(timeDisplayFinder);
      expect(timeWidget.data, matches(r'\d+:\d+:\d+ / \d+:\d+:\d+'));
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

      // Find container with background color
      final containerFinder = find.byWidgetPredicate(
            (widget) => widget is Container && widget.color == customBackgroundColor,
      );
      expect(containerFinder, findsOneWidget);
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

      // Find SizedBox with the custom height (used for waveform)
      final sizedBoxFinder = find.byWidgetPredicate(
            (widget) => widget is SizedBox && widget.height == customHeight,
      );
      expect(sizedBoxFinder, findsOneWidget);
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
      // Should not crash and should show play button
      expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);
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
      expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);
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

      // Find ConstrainedBox specifically for the player with expected max width
      final constrainedBoxFinder = find.byWidgetPredicate(
            (widget) => widget is ConstrainedBox &&
            widget.constraints.maxWidth == 360.0, // 45% of 800px
      );

      expect(constrainedBoxFinder, findsOneWidget);
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

    group('Basic widget structure', () {
      testWidgets('contains essential UI components', (tester) async {
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

        // Test for presence of essential components without being too specific about count
        expect(find.byType(InnovareAudioWaveformPlayer), findsOneWidget);
        expect(find.byType(ClipRRect), findsAtLeastNWidgets(1));
        expect(find.byType(Container), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(Row), findsAtLeastNWidgets(1));
        expect(find.byType(IconButton), findsAtLeastNWidgets(1));
        expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
      });

      testWidgets('has main widget present', (tester) async {
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

        // Verify the main structure exists
        final player = find.byType(InnovareAudioWaveformPlayer);
        expect(player, findsOneWidget);

        // Verify ClipRRect exists as outer widget
        final clipRRect = find.descendant(
          of: player,
          matching: find.byType(ClipRRect),
        );
        expect(clipRRect, findsAtLeastNWidgets(1));
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

        // Should contain CustomPaint for waveform rendering
        expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
      });
    });

    group('Animation components', () {
      testWidgets('contains scale transition for pulse effect', (tester) async {
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

        // Should have ScaleTransition for pulse animation
        expect(find.byType(ScaleTransition), findsAtLeastNWidgets(1));

        // Should have TweenAnimationBuilder for color animation
        expect(find.byType(TweenAnimationBuilder<Color?>), findsAtLeastNWidgets(1));
      });
    });

    group('Functional behavior', () {
      testWidgets('widget initializes without errors', (tester) async {
        // Test that widget can be created and rendered without throwing
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

        // Verify no exceptions were thrown during render
        expect(tester.takeException(), isNull);

        // Verify widget tree is stable
        await tester.pump(const Duration(milliseconds: 100));
        expect(tester.takeException(), isNull);
      });

      testWidgets('respects widget constraints', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400, // Increased to a more realistic minimum width
                height: 100,
                child: InnovareAudioWaveformPlayer(
                  uri: testUri,
                  waveform: testWaveform,
                ),
              ),
            ),
          ),
        );

        // Widget should render within reasonable constraints without overflow
        expect(tester.takeException(), isNull);
        expect(find.byType(InnovareAudioWaveformPlayer), findsOneWidget);
      });

      testWidgets('handles different waveform sizes', (tester) async {
        // Test with very small waveform
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: InnovareAudioWaveformPlayer(
                uri: testUri,
                waveform: [0.5],
              ),
            ),
          ),
        );

        expect(find.byType(InnovareAudioWaveformPlayer), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Test with larger waveform
        final largeWaveform = List.generate(100, (i) => (i % 10) / 10.0);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InnovareAudioWaveformPlayer(
                uri: testUri,
                waveform: largeWaveform,
              ),
            ),
          ),
        );

        expect(find.byType(InnovareAudioWaveformPlayer), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('UI interaction', () {
      testWidgets('play button is interactive', (tester) async {
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

        final playButton = find.byIcon(Icons.play_circle_fill);
        expect(playButton, findsOneWidget);

        // Verify button is tappable (no exception should be thrown)
        await tester.tap(playButton);
        await tester.pump();

        expect(tester.takeException(), isNull);
      });

      testWidgets('speed control is interactive', (tester) async {
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

        final speedControl = find.text('1.0x');
        expect(speedControl, findsOneWidget);

        // Verify speed control is tappable
        await tester.tap(speedControl);
        await tester.pump();

        expect(tester.takeException(), isNull);
        expect(find.text('1.5x'), findsOneWidget);
      });
    });
  });
}
