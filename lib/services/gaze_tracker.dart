import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class GazeTracker {
  double sensitivity = 1.0; // 0.5..2.0

  Offset estimate(Face f){
    final lm = f.landmarks;
    final lEye = lm[FaceLandmarkType.leftEye]?.position;
    final rEye = lm[FaceLandmarkType.rightEye]?.position;
    final nose = lm[FaceLandmarkType.noseBase]?.position;
    if (lEye==null || rEye==null || nose==null) return Offset.zero;
    final centerX = (lEye.x + rEye.x)/2;
    final dx = (nose.x - centerX)/max(1.0, (rEye.x - lEye.x).abs());
    final dy = (nose.y - min(lEye.y, rEye.y))/max(1.0, (rEye.x - lEye.x).abs());
    return Offset(dx*sensitivity, dy*sensitivity*0.7);
  }
}
