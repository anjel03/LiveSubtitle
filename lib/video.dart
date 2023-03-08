import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import 'audio.dart';
import 'front_end.dart';

class MyVideoPicker extends StatefulWidget {
  @override
  _MyVideoPickerState createState() => _MyVideoPickerState();
}

class _MyVideoPickerState extends State<MyVideoPicker> {
  File? _videoFile;
  VideoPlayerController? _videoPlayerController;
  bool _isVideoPlayerReady = false;
  bool _isPlaying = false;
  Future<void> _uploadVideo() async {
    if (_videoFile != null) {
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('videos/${_videoFile!.path.split('/').last}');
        await ref.putFile(_videoFile!);
        final downloadUrl = await ref.getDownloadURL();
        Text("Video uploaded successfully: $downloadUrl");
      } catch (e) {
        Text("Error uploading video: $e");
      }
    }
  }

  void _pickVideo() async {
    final pickedFile =
        await ImagePicker().getVideo(source: ImageSource.gallery);
    setState(() {
      _videoFile = File(pickedFile!.path);
      _videoPlayerController = VideoPlayerController.file(_videoFile!);
    });
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _videoPlayerController!.addListener(() {
      if (_videoPlayerController!.value.isInitialized) {
        setState(() {
          _isVideoPlayerReady = true;
        });
      }
    });
    _videoPlayerController!.setLooping(true);
    _videoPlayerController!.initialize().then((_) {
      setState(() {});
    });
  }

  void _playPause() {
    setState(() {
      if (_isPlaying) {
        _videoPlayerController!.pause();
        _isPlaying = false;
      } else {
        _videoPlayerController!.play();
        _isPlaying = true;
      }
    });
  }

  void _setPlaybackSpeed(double speed) {
    _videoPlayerController!.setPlaybackSpeed(speed);
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController!.dispose();
  }

  Future<void> uploadVideo() async {
    if (_videoFile != null) {
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('videos/${_videoFile!.path.split('/').last}');
        await ref.putFile(_videoFile!);
        final downloadUrl = await ref.getDownloadURL();
        Text("Video uploaded successfully: $downloadUrl");
      } catch (e) {
        Text("Error uploading video: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Video Picker Demo'),
        ),
        body: Center(
          child: _videoFile == null
              ? Text('No video selected.')
              : _isVideoPlayerReady
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio:
                              _videoPlayerController!.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController!),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: _playPause,
                              icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow),
                            ),
                            IconButton(
                              onPressed: () => _setPlaybackSpeed(0.5),
                              icon: Text('0.5x'),
                            ),
                            IconButton(
                              onPressed: () => _setPlaybackSpeed(1),
                              icon: Text('1x'),
                            ),
                            IconButton(
                              onPressed: () => _setPlaybackSpeed(2),
                              icon: Text('2x'),
                            ),
                          ],
                        ),
                      ],
                    )
                  : CircularProgressIndicator(),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 6),
            FloatingActionButton(
              onPressed: _pickVideo,
              tooltip: 'Pick Video',
              child: Icon(Icons.add),
            ),
            SizedBox(width: 6),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VideoToAudioConverter()),
                );
              },
              tooltip: 'Extract audio',
              child: Icon(Icons.explicit_rounded),
            ),
            SizedBox(width: 6),
            FloatingActionButton(
              onPressed: _uploadVideo,
              tooltip: 'Upload Video',
              child: Icon(Icons.cloud_upload),
            ),
            SizedBox(width: 6),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Front_end()),
                );
              },
              tooltip: 'Upload Video',
              child: Icon(Icons.arrow_back_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
