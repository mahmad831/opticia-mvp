import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../services/gaze_tracker.dart';
import '../widgets/gaze_cursor.dart';
import 'settings/sensitivity_screen.dart';
import 'settings/sound_screen.dart';
import 'settings/manual_screen.dart';

class HomeScreen extends StatefulWidget { const HomeScreen({super.key}); @override State<HomeScreen> createState()=>_HomeScreenState(); }

class _HomeScreenState extends State<HomeScreen> {
  CameraController? _c; FaceDetector? _d; final _tracker = GazeTracker();
  Offset _cursor = const Offset(120,200); bool _clicking = false; DateTime _gazeStart = DateTime.now();
  bool _running = false;

  Future<void> _start() async {
    if (_running) return;
    _running = true;
    final cams = await availableCameras();
    final front = cams.firstWhere((c)=>c.lensDirection==CameraLensDirection.front, orElse: ()=>cams.first);
    _c = CameraController(front, ResolutionPreset.low, enableAudio: false);
    await _c!.initialize();
    _d = FaceDetector(options: FaceDetectorOptions(enableContours: true, enableLandmarks: true));
    _loop();
    setState((){});
  }

  Future<void> _loop() async {
    while (mounted && _running) {
      try{
        final file = await _c!.takePicture();
        final input = InputImage.fromFilePath(file.path);
        final faces = await _d!.processImage(input);
        if (faces.isNotEmpty) {
          final off = _tracker.estimate(faces.first);
          setState(()=>_cursor += Offset(off.dx*8, off.dy*8));
          final now = DateTime.now();
          if ((now.difference(_gazeStart).inMilliseconds)>900) {
            setState(()=>_clicking=true);
            await Future.delayed(const Duration(milliseconds: 120));
            setState(()=>_clicking=false);
            _gazeStart = now;
          }
        }
      } catch (_) {}
      await Future.delayed(const Duration(milliseconds: 60));
    }
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Opticia')),
      body: Stack(children:[
        Center(child: FilledButton(onPressed: _start, child: const Text('START'))),
        GazeCursor(pos: _cursor, clicking: _clicking),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(spacing: 12, runSpacing: 12, children: [
              FilledButton.tonal(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>const SensitivityScreen())), child: const Text('Sensitivity')),
              FilledButton.tonal(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>const SoundScreen())), child: const Text('Sound')),
              FilledButton.tonal(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>const ManualScreen())), child: const Text('Manual')),
            ]),
          ),
        )
      ]),
    );
  }

  @override void dispose(){ _running = false; _c?.dispose(); _d?.close(); super.dispose(); }
}
