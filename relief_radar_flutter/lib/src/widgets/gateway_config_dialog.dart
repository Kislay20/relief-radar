import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../client.dart';
import '../theme/app_theme.dart';

/// Preset configurations for standard development and operational environments.
class GatewayPreset {
  final String label;
  final String description;
  final String url;
  final IconData icon;

  const GatewayPreset({
    required this.label,
    required this.description,
    required this.url,
    required this.icon,
  });
}

const List<GatewayPreset> _defaultPresets = [
  GatewayPreset(
    label: 'Live Production (Render)',
    description: 'Cloud Serverpod API: relief-radar-api.onrender.com',
    url: 'https://relief-radar-api.onrender.com/',
    icon: Icons.cloud_done_rounded,
  ),
  GatewayPreset(
    label: 'Host PC Wi-Fi',
    description: 'Direct LAN access (SRMIST: 10.3.197.147)',
    url: 'http://10.3.197.147:8080/',
    icon: Icons.wifi,
  ),
  GatewayPreset(
    label: 'USB / ADB Reverse',
    description: 'Requires "adb reverse tcp:8080 tcp:8080"',
    url: 'http://127.0.0.1:8080/',
    icon: Icons.usb,
  ),
  GatewayPreset(
    label: 'PC Mobile Hotspot',
    description: 'Connect phone to Windows Hotspot',
    url: 'http://192.168.137.1:8080/',
    icon: Icons.wifi_tethering,
  ),
  GatewayPreset(
    label: 'Android Emulator',
    description: 'Standard 10.0.2.2 alias for host PC',
    url: 'http://10.0.2.2:8080/',
    icon: Icons.developer_mode,
  ),
];

/// Displays the tactical Serverpod Gateway configuration bottom sheet.
Future<void> showGatewayConfigSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const GatewayConfigSheet(),
  );
}

class GatewayConfigSheet extends StatefulWidget {
  const GatewayConfigSheet({super.key});

  @override
  State<GatewayConfigSheet> createState() => _GatewayConfigSheetState();
}

class _GatewayConfigSheetState extends State<GatewayConfigSheet> {
  late TextEditingController _urlController;
  bool _isProbing = false;
  GatewayProbeResult? _lastProbeResult;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: activeServerUrlNotifier.value);
    _probeCurrent();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _probeCurrent() async {
    final candidate = _urlController.text.trim();
    if (candidate.isEmpty) return;
    setState(() {
      _isProbing = true;
      _lastProbeResult = null;
    });

    final res = await probeGatewayDetails(candidate);
    if (mounted) {
      setState(() {
        _isProbing = false;
        _lastProbeResult = res;
      });
    }
  }

  Future<void> _applyGateway() async {
    var rawUrl = _urlController.text.trim();
    if (rawUrl.isEmpty) return;

    if (!rawUrl.startsWith('http://') && !rawUrl.startsWith('https://')) {
      rawUrl = 'http://$rawUrl';
    }
    if (!rawUrl.endsWith('/')) {
      rawUrl = '$rawUrl/';
    }

    setState(() => _isSaving = true);
    await savePreferredGateway(rawUrl);

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.of(context).pop();
      AppTheme.showTacticalSnackbar(
        context,
        'Connected gateway switched to: $rawUrl',
        isSuccess: true,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    const surfaceColor = Color(0xFF1E293B);
    const borderColor = Color(0xFF334155);

    return Padding(
      padding: EdgeInsets.only(top: 60, bottom: bottomInset),
      child: GlassContainer(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        backgroundColor: const Color(0xFF101720).withValues(alpha: 0.85),
        glowColor: const Color(0xFFD32F2F),
        blurSigma: 16.0,
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B1214),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFD32F2F)),
                      ),
                      child: const Icon(
                        Icons.router_outlined,
                        color: Color(0xFFEF5350),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GATEWAY CONFIGURATION',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Text(
                            'Configure Serverpod API Endpoint & Failover',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Active Gateway Status Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'CURRENT ACTIVE GATEWAY',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                          if (_isProbing)
                            const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF64B5F6),
                              ),
                            )
                          else if (_lastProbeResult != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _lastProbeResult!.isSuccessful
                                    ? const Color(0xFF1B5E20)
                                    : const Color(0xFFB71C1C),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _lastProbeResult!.isSuccessful
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: Colors.white,
                                    size: 11,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _lastProbeResult!.isSuccessful
                                        ? 'ONLINE (${_lastProbeResult!.latency?.inMilliseconds ?? 0}ms)'
                                        : 'UNREACHABLE',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SelectableText(
                        activeServerUrlNotifier.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                        ),
                      ),
                      if (_lastProbeResult != null &&
                          !_lastProbeResult!.isSuccessful) ...[
                        const SizedBox(height: 6),
                        Text(
                          _lastProbeResult!.error ?? 'Connection failed',
                          style: const TextStyle(
                            color: Color(0xFFFF8A80),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Presets Selection
                const Text(
                  'QUICK PRESETS',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),

                ...List.generate(_defaultPresets.length, (index) {
                  final preset = _defaultPresets[index];
                  final isSelected = _urlController.text.trim() == preset.url;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InkWell(
                      onTap: () {
                        _urlController.text = preset.url;
                        _probeCurrent();
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1E3A5F)
                              : surfaceColor.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF64B5F6)
                                : borderColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              preset.icon,
                              color: isSelected
                                  ? const Color(0xFF90CAF9)
                                  : const Color(0xFF94A3B8),
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    preset.label,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFFE2E8F0),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    preset.description,
                                    style: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              preset.url,
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF90CAF9)
                                    : const Color(0xFF64748B),
                                fontSize: 10,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 12),

                // Custom Gateway URL Input
                const Text(
                  'TARGET GATEWAY URL',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F151C),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.link,
                          color: Color(0xFF94A3B8),
                          size: 18,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _urlController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'monospace',
                          ),
                          decoration: const InputDecoration(
                            hintText: 'http://10.3.197.147:8080/',
                            hintStyle: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          keyboardType: TextInputType.url,
                          autocorrect: false,
                          enableSuggestions: false,
                          onSubmitted: (_) => _probeCurrent(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.content_paste,
                          color: Color(0xFF94A3B8),
                          size: 18,
                        ),
                        tooltip: 'Paste from clipboard',
                        onPressed: () async {
                          final data = await Clipboard.getData(
                            Clipboard.kTextPlain,
                          );
                          if (data?.text != null && data!.text!.isNotEmpty) {
                            _urlController.text = data.text!.trim();
                            _probeCurrent();
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Color(0xFF94A3B8),
                          size: 18,
                        ),
                        tooltip: 'Clear',
                        onPressed: () {
                          _urlController.clear();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Action Buttons Row: Probe & Save
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: OutlinedButton.icon(
                        onPressed: _isProbing ? null : _probeCurrent,
                        icon: _isProbing
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF64B5F6),
                                ),
                              )
                            : const Icon(Icons.network_check, size: 16),
                        label: Text(
                          _isProbing ? 'PROBING...' : 'TEST GATEWAY',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF64B5F6),
                          side: const BorderSide(color: Color(0xFF1E3A5F)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _applyGateway,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.bolt, size: 18),
                        label: Text(
                          _isSaving ? 'CONNECTING...' : 'APPLY & CONNECT',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFFD32F2F),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tactical Diagnostics Guide
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B0F15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.help_outline,
                            color: Color(0xFFF59E0B),
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'CONNECTION INSTRUCTIONS',
                            style: TextStyle(
                              color: Color(0xFFF59E0B),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '⚡ Method 1: USB Debugging (Most Reliable)\n'
                        'Plug your phone into your computer with USB Debugging enabled, then run in your computer terminal:\n'
                        'adb reverse tcp:8080 tcp:8080\n'
                        'Then select "http://127.0.0.1:8080/".',
                        style: TextStyle(
                          color: Color(0xFFCBD5E1),
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '📶 Method 2: Wi-Fi / Windows Hotspot\n'
                        'Connect both devices to the same Wi-Fi or connect phone to PC Mobile Hotspot.\n'
                        'Use: http://10.3.197.147:8080/ (Wi-Fi) or http://192.168.137.1:8080/ (Hotspot).\n'
                        'Ensure Windows Firewall allows TCP port 8080.',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
