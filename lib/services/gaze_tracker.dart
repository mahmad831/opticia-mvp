import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class GazeTracker {
  double sensitivity = 1.0; // 0.5..2.0

  Offset estimate(Face f) {
    final lm   = f.landmarks;
    final lEye = lm[FaceLandmarkType.leftEye]?.position;
    final rEye = lm[FaceLandmarkType.rightEye]?.position;
    final nose = lm[FaceLandmarkType.noseBase]?.position;
    if (lEye == null || rEye == null || nose == null) return Offset.zero;

    // Explicitly convert ints to doubles
    final lEx = lEye.x.toDouble();
    final rEx = rEye.x.toDouble();
    final lEy = lEye.y.toDouble();
    final rEy = rEye.y.toDouble();
    final nX  = nose.x.toDouble();
    final nY  = nose.y.toDouble();

    final centerX = (lEx + rEx) / 2.0;
    final eyeSpan = (rEx - lEx).abs();
    final denom   = max(1.0, eyeSpan);

    final dx = (nX - centerX) / denom;
    final dy = (nY - min(lEy, rEy)) / denom;

    return Offset(dx * sensitivity, dy * sensitivity * 0.7);
  }
}
