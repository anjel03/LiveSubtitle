import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';


class VideoToAudioConverter extends StatefulWidget {
  @override
  _VideoToAudioConverterState createState() => _VideoToAudioConverterState();
}

class _VideoToAudioConverterState extends State<VideoToAudioConverter> {
  final _ffmpeg = FlutterFFmpeg();
  File? _videoFile;
  File? _audioFile;
  bool _isConverting = false;

  Future<void> _uploadAudio() async {
    if (_videoFile != null) {
      try {
        final ref = FirebaseStorage.instance.ref().child('audios/${_audioFile!.path.split('/').last}');
        await ref.putFile(_audioFile!);
        final downloadUrl = await ref.getDownloadURL();
        Text("Audio uploaded successfully: $downloadUrl");
      } catch (e) {
        Text("Error uploading video: $e");
      }
    }
  }
  Future<void> _convertVideoToAudio() async {
    setState(() {
      _isConverting = true;
    });

    final appDir = await getApplicationDocumentsDirectory();
    final outputFilePath = "/storage/emulated/0/Download/output1.mp3";

    final arguments = ['-i', _videoFile!.path,'-vn',
      '-acodec',
      'libmp3lame',
      '-ab',
      '128k', outputFilePath];

    await _ffmpeg.executeWithArguments(arguments);

    setState(() {
      _audioFile = File(outputFilePath);
      _isConverting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Video to Audio Converter"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_videoFile != null)
                  Text("Selected video: ${_videoFile!.path}"),
                if (_audioFile != null)
                  Text("Audio saved to: ${_audioFile!.path}"),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(type: FileType.video);
                    if (result != null) {
                      setState(() {
                        _videoFile = File(result.files.single.path!);
                      });
                    }
                  },
                  child: Text("Select Video"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _videoFile == null || _isConverting ? null : _convertVideoToAudio,
                  child: _isConverting ? CircularProgressIndicator() : Text("Convert to Audio"),
                ),SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadAudio,
                  child: Text("Upload Audio"),
                ),
              ],
            ),
          ),
        )
    );
  }
}