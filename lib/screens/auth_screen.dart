import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../services/face_store.dart';
import '../services/face_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState()=>_AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  CameraController? _controller; FaceDetector? _detector; Face? _lastFace;
  bool _busy = false;

  @override void initState(){ super.initState(); _init(); }
  Future<void> _init() async {
    final cams = await availableCameras();
    final front = cams.firstWhere((c)=>c.lensDirection==CameraLensDirection.front, orElse: ()=>cams.first);
    _controller = CameraController(front, ResolutionPreset.medium, enableAudio: false);
    await _controller!.initialize();
    _detector = FaceDetector(options: FaceDetectorOptions(enableContours: true, enableLandmarks: true));
    // Use takePicture loop instead of imageStream to keep it simple
    setState((){});
  }

  Future<Face?> _detectOnce() async {
    if (_busy || _controller==null || !_controller!.value.isInitialized) return null;
    _busy = true;
    try{
      final file = await _controller!.takePicture();
      final input = InputImage.fromFilePath(file.path);
      final faces = await _detector!.processImage(input);
      return faces.isNotEmpty ? faces.first : null;
    } finally { _busy = false; }
  }

  List<double>? _embedding(Face f){
    final lm = f.landmarks;
    final lEye = lm[FaceLandmarkType.leftEye]?.position;
    final rEye = lm[FaceLandmarkType.rightEye]?.position;
    final nose = lm[FaceLandmarkType.noseBase]?.position;
    final mouth = lm[FaceLandmarkType.bottomMouth]?.position ?? lm[FaceLandmarkType.leftMouth]?.position;
    if (lEye==null || rEye==null || nose==null || mouth==null) return null;
    double eyeDist = (lEye.x - rEye.x).abs();
    double noseToMouth = (nose.y - mouth.y).abs();
    double noseToLEye = (nose.y - lEye.y).abs();
    double noseToREye = (nose.y - rEye.y).abs();
    return [eyeDist, noseToMouth, noseToLEye, noseToREye];
  }

  void _toast(String m){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m))); }

  Future<void> _register() async {
    final face = await _detectOnce();
    if (face==null) return _toast('No face detected');
    final v = _embedding(face); if (v==null) return _toast('Position face fully');
    await FaceStore.save(v);
    _toast('Registered Successfully');
  }

  Future<void> _login() async {
    final saved = await FaceStore.load(); if (saved==null) return _toast('User not found');
    final face = await _detectOnce(); if (face==null) return _toast('No face detected');
    final cur = _embedding(face); if (cur==null) return _toast('Position face fully');
    final ok = FaceAuth.isMatch(saved, cur, thresh: 0.93);
    _toast(ok ? 'Login Successful' : 'Face not recognized');
    if (ok && mounted) Navigator.pushReplacementNamed(context, '/home');
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Face Login')),
      body: Stack(children:[
        if (_controller?.value.isInitialized==true) CameraPreview(_controller!),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children:[
              Expanded(child: FilledButton(onPressed: _register, child: const Text('Register'))),
              const SizedBox(width: 12),
              Expanded(child: FilledButton(onPressed: _login, child: const Text('Login'))),
            ]),
          ),
        )
      ]),
    );
  }

  @override void dispose(){ _controller?.dispose(); _detector?.close(); super.dispose(); }
}
