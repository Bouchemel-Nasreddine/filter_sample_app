
import 'package:filter_app/song_picker.dart';
import 'package:flutter/material.dart';
import 'package:camera_deep_ar/camera_deep_ar.dart';

import 'audio_player.dart';
import 'config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CameraDeepArController _deepArController;
  late Player _audioplayer;
  bool _isVideoRecording = false;
  bool _isPlaying = false;
  String currentEffect = "assets/aviators";

  @override
  void initState() {
    super.initState();
    _deepArController = CameraDeepArController(config);
    _audioplayer = Player();
    CameraDeepArController.checkPermissions(); // checking for the needed permission (requesting them if needed)
    _deepArController.setEventHandler(
      DeepArEventHandler(
        onCameraReady: (v) {
        },
        onSnapPhotoCompleted: (v) {
        },
        onVideoRecordingComplete: (v) {
          // TODO: Implement video saving
        },
        onSwitchEffect: (v) {
        },
      ),
    );
  }

  @override
  void dispose() {
    _deepArController.dispose();
    _audioplayer.dispose();
    super.dispose();
  }  

  @override
  Widget build(BuildContext context) {
    _deepArController.switchEffect(config.cameraMode, currentEffect);
    bool _rebuildCamera = true;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          if (_rebuildCamera)  DeepArPreview(_deepArController) ,  
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  !_isVideoRecording ? _deepArController.startVideoRecording()
                    : _deepArController.stopVideoRecording();
                  setState(() {
                    _isVideoRecording = !_isVideoRecording;
                  });
                },
                child: _isVideoRecording ? const Text('stop') : const Text('start'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_isPlaying) {
                    _audioplayer.stop();
                    
                  } else {showDialog(
                    context: context,
                    builder: (context) => SongPicker(),
                  );
                  }
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                }, 
                child: _isPlaying ? const Text('stop') : const Text('song'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // temporary effect switch, later it will be managed with a list and a iterator
                    currentEffect == "assets/aviators" ? currentEffect = "assets/manly_face"
                      : currentEffect == "assets/manly_face" ? currentEffect = "assets/beard"
                        : currentEffect == "assets/beard" ? currentEffect = "none"
                          : currentEffect = "assets/aviators";
                  });
                },
                child: const Text('filter'),
              ),
            ],
          ),
        ],
      ),
    );
  }

}


