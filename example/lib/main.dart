import 'package:flutter/material.dart';
import 'package:innovare_audio_waveform_player/innovare_audio_waveform_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Innovare Audio Waveform Player Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const AudioPlayerDemo(),
      );
}

class AudioPlayerDemo extends StatelessWidget {
  const AudioPlayerDemo({super.key});

  // Sample waveform data - in a real app, this would come from audio analysis
  static const sampleWaveform = [
    0.1,
    0.3,
    0.7,
    0.4,
    0.8,
    0.2,
    0.9,
    0.6,
    0.3,
    0.5,
    0.8,
    0.4,
    0.7,
    0.9,
    0.2,
    0.6,
    0.4,
    0.8,
    0.3,
    0.7,
    0.5,
    0.9,
    0.1,
    0.6,
    0.8,
    0.3,
    0.7,
    0.4,
    0.9,
    0.2,
    0.6,
    0.8,
    0.5,
    0.3,
    0.7,
    0.9,
    0.4,
    0.1,
    0.8,
    0.6,
    0.3,
    0.7,
    0.5,
    0.9,
    0.2,
    0.8,
    0.4,
    0.6,
    0.7,
    0.3,
  ];

  // Demo audio URL - replace with your actual audio file
  static const audioUrl = 'https://www.soundjay.com/misc/bell-ringing-05.wav';

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text('Audio Waveform Player Demo'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Default Theme',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              InnovareAudioWaveformPlayer(
                uri: audioUrl,
                waveform: sampleWaveform,
              ),
              SizedBox(height: 30),
              Text(
                'Custom Colors',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              InnovareAudioWaveformPlayer(
                uri: audioUrl,
                waveform: sampleWaveform,
                accentColor: Colors.green,
                backgroundColor: Color(0xFF2D2D30),
                height: 40,
              ),
              SizedBox(height: 30),
              Text(
                'With Gradient',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              InnovareAudioWaveformPlayer(
                uri: audioUrl,
                waveform: sampleWaveform,
                accentColor: Colors.purple,
                backgroundColor: Color(0xFF1A1A2E),
                height: 35,
                playedWaveformGradient: LinearGradient(
                  colors: [Colors.purple, Colors.pink, Colors.orange],
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Compact Version',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              InnovareAudioWaveformPlayer(
                uri: audioUrl,
                waveform: sampleWaveform,
                accentColor: Colors.red,
                backgroundColor: Color(0xFF0F0F23),
                height: 25,
              ),
              SizedBox(height: 30),
              Text(
                'Large Version',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              InnovareAudioWaveformPlayer(
                uri: audioUrl,
                waveform: sampleWaveform,
                accentColor: Colors.teal,
                backgroundColor: Color(0xFF263238),
                height: 60,
              ),
              SizedBox(height: 30),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Features:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('• Play/pause with animated pulse effect'),
                      Text('• Interactive waveform - tap or drag to seek'),
                      Text('• Speed control (1.0x, 1.5x, 2.0x)'),
                      Text('• Customizable colors and gradients'),
                      Text('• Responsive design'),
                      Text('• Progress visualization'),
                      Text('• Time display'),
                      SizedBox(height: 10),
                      Text(
                        'Note: This demo uses a sample audio file. Replace the audioUrl with your own audio file for testing.',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
