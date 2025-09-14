import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});
  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool camOk = false;
  bool micOk = false;
  bool accessibilitySeen = false; // visual only (no extra plugin)

  @override
  void initState() {
    super.initState();
    () async {
      camOk = await Permission.camera.isGranted;
      micOk = await Permission.microphone.isGranted;
      setState(() {});
    }();
  }

  Future<void> _askCamera() async {
    final s = await Permission.camera.request();
    setState(() => camOk = s.isGranted);
  }

  Future<void> _askMic() async {
    final s = await Permission.microphone.request();
    setState(() => micOk = s.isGranted);
  }

  void _openAccessibilityHint() {
    setState(() => accessibilitySeen = true);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enable Accessibility'),
        content: const Text(
          'For full system-wide control later, enable the app service in:\n'
          'Settings → Accessibility.\n\n'
          'For this MVP, you can tap Next after giving Camera (and optionally Microphone).',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  bool get canContinue => camOk; // keep simple for MVP (enable when camera granted)

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2ECC71);
    const bg = Color(0xFF1F1F1F); // dark
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo circle
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.black.withOpacity(0.25),
                  backgroundImage: const AssetImage('assets/opticia_logo.png'), // optional, ignore if you don’t have it
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Opticia',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
              const SizedBox(height: 28),

              // Camera tile
              _GreenTile(
                label: 'Camera',
                icon: Icons.photo_camera_outlined,
                granted: camOk,
                onTap: _askCamera,
              ),
              const SizedBox(height: 14),

              // Accessibility tile (opens hint dialog for MVP)
              _GreenTile(
                label: 'Accessibility',
                icon: Icons.accessibility_new,
                granted: accessibilitySeen, // purely visual tick after they tap it
                onTap: _openAccessibilityHint,
              ),
              const SizedBox(height: 14),

              // Microphone tile
              _GreenTile(
                label: 'Microphone',
                icon: Icons.mic_none_rounded,
                granted: micOk,
                onTap: _askMic,
              ),

              const Spacer(),
              _GreenCTA(
                label: 'Next',
                icon: Icons.arrow_forward,
                enabled: canContinue,
                onTap: () => Navigator.pushReplacementNamed(context, '/auth'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Big rounded green tile like your mock
class _GreenTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool granted;
  final VoidCallback onTap;
  const _GreenTile({
    required this.label,
    required this.icon,
    required this.granted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2ECC71);
    return Material(
      color: green,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                granted ? Icons.check_circle : icon,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom green CTA matching the mock
class _GreenCTA extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  const _GreenCTA({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2ECC71);
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: green,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: enabled ? onTap : null,
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(icon, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
