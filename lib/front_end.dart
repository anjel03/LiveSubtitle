import 'package:car_login/speechtotext.dart';
import 'package:car_login/video.dart';
import 'package:flutter/material.dart';

import 'audio.dart';

class Front_end extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Captions'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: ()  {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyVideoPicker()),
                );
              },
              child: Text('Display Video'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoToAudioConverter()),
                );
              },

              child: Text('Extract Audio'),

            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpeechToTextScreen()),
                );
              },

              child: Text('Extract Text'),

            ),
          ],
        ),
      ),
    );
  }
}
