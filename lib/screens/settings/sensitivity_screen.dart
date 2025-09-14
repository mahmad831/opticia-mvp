import 'package:flutter/material.dart';
class SensitivityScreen extends StatefulWidget { const SensitivityScreen({super.key}); @override State<SensitivityScreen> createState()=>_SensitivityScreenState(); }
class _SensitivityScreenState extends State<SensitivityScreen>{ double _speed=1.0; double _dwell=0.9; @override Widget build(BuildContext c){ return Scaffold(appBar: AppBar(title: const Text('Adjust Sensitivity')), body: Padding(padding: const EdgeInsets.all(16), child: Column(children:[
  const Text('Cursor Speed'), Slider(min:0.5,max:2.0,value:_speed,onChanged:(v)=>setState(()=>_speed=v)), const SizedBox(height:12),
  const Text('Eye-Closing / Dwell Threshold (s)'), Slider(min:0.3,max:1.5,divisions:12,value:_dwell,onChanged:(v)=>setState(()=>_dwell=v)),
  const SizedBox(height:16), FilledButton(onPressed: ()=>Navigator.pop(c), child: const Text('Save Settings'))
]))); }}
