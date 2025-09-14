import 'package:flutter/material.dart';
class SoundScreen extends StatefulWidget { const SoundScreen({super.key}); @override State<SoundScreen> createState()=>_SoundScreenState(); }
class _SoundScreenState extends State<SoundScreen>{ bool _enabled=true; double _interval=0.8; @override Widget build(BuildContext c){ return Scaffold(appBar: AppBar(title: const Text('Sound Settings')), body: Padding(padding: const EdgeInsets.all(16), child: Column(children:[
  SwitchListTile(value:_enabled,onChanged:(v)=>setState(()=>_enabled=v), title: const Text('Enable Sound Effect')),
  const SizedBox(height:12), const Text('Eye-Closing Sound Interval'), Slider(min:0.3,max:1.5,value:_interval,onChanged:(v)=>setState(()=>_interval=v)),
]))); }}
