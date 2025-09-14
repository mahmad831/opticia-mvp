import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});
  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool camOk = false;

  Future<void> _askCamera() async {
    final status = await Permission.camera.request();
    setState(() => camOk = status.isGranted);
  }

  @override
  void initState() {
    super.initState();
    () async {
      camOk = await Permission.camera.isGranted;
      setState(() {});
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opticia')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            _permTile('Camera', camOk, _askCamera),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: camOk
                  ? () => Navigator.pushReplacementNamed(context, '/auth')
                  : null,
              child: const Text('Next'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _permTile(String label, bool granted, VoidCallback onTap) {
    return ListTile(
      tileColor: Colors.green.withOpacity(0.1),
      leading: Icon(granted ? Icons.lock_open : Icons.lock_outline),
      title: Text(label),
      trailing: FilledButton(
        onPressed: onTap,
        child: Text(granted ? 'Granted' : 'Allow'),
      ),
    );
  }
}
