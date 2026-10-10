import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:relief_radar_client/relief_radar_client.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';

import '../../client.dart';
import '../theme/app_theme.dart';
import '../widgets/gateway_config_dialog.dart';

/// Professional Emergency-Response Authentication Portal.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Sign In Controllers
  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();
  bool _obscureSignInPassword = true;

  // Sign Up / Registration Controllers
  final _signUpNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpOtpController = TextEditingController();
  bool _obscureSignUpPassword = true;

  bool _isLoading = false;
  bool _isAwaitingOtp = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Listen to session changes
    sessionManager.addListener(_onSessionChanged);
    _onSessionChanged();

    // Listen to client-level errors (including failures in SignInWithEmailButton)
    clientErrorNotifier.addListener(_onClientErrorChanged);
  }

  void _onTabChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signUpOtpController.dispose();
    sessionManager.removeListener(_onSessionChanged);
    clientErrorNotifier.removeListener(_onClientErrorChanged);
    super.dispose();
  }

  void _onSessionChanged() {
    if (sessionManager.isSignedIn && mounted) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  /// Catches errors intercepted by Client.onFailedCall (e.g. from SignInWithEmailButton).
  void _onClientErrorChanged() {
    final errorInfo = clientErrorNotifier.value;
    if (errorInfo == null || !mounted) return;

    // Reset local loading state so buttons don't stay disabled/hanging
    setState(() {
      _isLoading = false;
      _errorMessage = errorInfo.message;
    });

    // If an external dialog (like SignInWithEmailDialog) is open, close it so it doesn't freeze
    if (ModalRoute.of(context)?.isCurrent != true) {
      Navigator.of(context, rootNavigator: true).maybePop();
    }

    // Show high-visibility emergency feedback with actionable details
    _showErrorSnackBar(
      errorInfo.message,
      onDetails: () => _showDiagnosticsDialog(
        title: errorInfo.title,
        message: errorInfo.message,
        details: errorInfo.details,
      ),
    );

    // Auto-display AlertDialog only for 405 Method Not Allowed or 5xx server faults
    if (errorInfo.statusCode == 405 ||
        (errorInfo.statusCode != null && errorInfo.statusCode! >= 500)) {
      _showDiagnosticsDialog(
        title: errorInfo.title,
        message: errorInfo.message,
        details: errorInfo.details,
      );
    }
  }

  void _handleError(Object error, [StackTrace? stack]) {
    String title = 'Authentication Failure';
    String message = 'An unexpected error occurred during request processing.';
    String details = error.toString();
    int? statusCode;

    if (error is TimeoutException) {
      title = 'Connection Timeout';
      message =
          'Request timed out connecting to ${client.host}. If on USB, run: adb reverse tcp:8080 tcp:8080. If on Wi-Fi, verify network connection.';
      details = error.message ?? error.toString();
    } else if (error is SocketException) {
      title = 'Network Connection Failed';
      message =
          'Unable to reach backend at ${client.host}. Run "adb reverse tcp:8080 tcp:8080" for USB or check firewall.';
      details = error.toString();
    } else if (error is ServerpodClientHttpException) {
      statusCode = error.statusCode;
      if (error.statusCode == 405) {
        title = 'Error 405: Method Not Allowed';
        message =
            'Server rejected the request with HTTP 405 (Method Not Allowed). '
            'Ensure the backend server has serverpod_auth registered and is running on API port 8080 (not 8082).';
      } else {
        title = 'Server Error (HTTP ${error.statusCode})';
        message = error.message.isNotEmpty
            ? error.message
            : 'Server returned HTTP ${error.statusCode}.';
      }
      details =
          'HTTP Status: ${error.statusCode}\nEndpoint message: ${error.message}';
    } else if (error is ServerpodClientNetworkException) {
      title = 'Network Connection Failed';
      message =
          'Unable to reach backend at ${client.host}. Check gateway connection or run "adb reverse tcp:8080 tcp:8080".';
      details = error.toString();
    } else if (error is ServerpodClientException) {
      title = 'Serverpod Client Error';
      message = error.message;
      details = error.toString();
    } else {
      message = error.toString();
    }

    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });

    _showErrorSnackBar(
      message,
      onDetails: () => _showDiagnosticsDialog(
        title: title,
        message: message,
        details: details,
      ),
    );

    if (statusCode == 405) {
      _showDiagnosticsDialog(
        title: title,
        message: message,
        details: details,
      );
    }
  }

  void _showErrorSnackBar(String message, {VoidCallback? onDetails}) {
    if (!mounted) return;
    AppTheme.showTacticalSnackbar(
      context,
      message,
      isSuccess: false,
      duration: const Duration(seconds: 6),
      action: onDetails != null
          ? SnackBarAction(
              label: 'DETAILS',
              textColor: const Color(0xFF00E5FF),
              onPressed: onDetails,
            )
          : null,
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    AppTheme.showTacticalSnackbar(
      context,
      message,
      isSuccess: true,
      duration: const Duration(seconds: 4),
    );
  }

  void _showDiagnosticsDialog({
    required String title,
    required String message,
    String? details,
  }) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161E27), // Dark slate
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFB71C1C), width: 1.5),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF3B1214),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFEF5350),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: const TextStyle(
                  color: Color(0xFFE2E8F0),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              if (details != null && details.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'TECHNICAL DIAGNOSTICS:',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F151C),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF2D3C4D)),
                  ),
                  child: SelectableText(
                    details,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              showGatewayConfigSheet(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF64B5F6),
            ),
            child: const Text(
              'CONFIGURE GATEWAY',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEF5350),
            ),
            child: const Text(
              'ACKNOWLEDGE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signInDirect() async {
    final email = _signInEmailController.text.trim();
    final password = _signInPasswordController.text;

    debugPrint(
      '[LoginPage] Sign in direct initiated for "$email" on ${client.host}',
    );

    if (email.isEmpty || password.isEmpty) {
      const msg =
          'Please enter both your responder email and security password.';
      setState(() => _errorMessage = msg);
      _showErrorSnackBar(msg);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await authCaller.email
          .authenticate(email, password)
          .timeout(
            const Duration(seconds: 8),
            onTimeout: () {
              throw TimeoutException(
                'Authentication timed out reaching gateway at ${client.host}. Ensure the server is running and reachable.',
              );
            },
          );

      if (!response.success ||
          response.userInfo == null ||
          response.keyId == null ||
          response.key == null) {
        final reason =
            response.failReason?.toString() ??
            'Invalid credentials or unverified responder account.';
        final msg = 'Authentication failed: $reason';
        setState(() => _errorMessage = msg);
        _showErrorSnackBar(msg);
        return;
      }

      await sessionManager.registerSignedInUser(
        response.userInfo!,
        response.keyId!,
        response.key!,
      );

      if (mounted) {
        debugPrint(
          '[LoginPage] Authentication verified! Navigating to operations dashboard...',
        );
        _showSuccessSnackBar(
          'Authorized as ${response.userInfo!.userName ?? email}',
        );
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
    } catch (e, st) {
      debugPrint('[LoginPage] Authentication error: $e');
      _handleError(e, st);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _requestSignUpOtp() async {
    final name = _signUpNameController.text.trim();
    final email = _signUpEmailController.text.trim();
    final password = _signUpPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      const msg = 'Please fill out all registration fields.';
      setState(() => _errorMessage = msg);
      _showErrorSnackBar(msg);
      return;
    }

    if (password.length < 8) {
      const msg = 'Password must be at least 8 characters long.';
      setState(() => _errorMessage = msg);
      _showErrorSnackBar(msg);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await authCaller.email
          .createAccountRequest(
            name,
            email,
            password,
          )
          .timeout(
            const Duration(seconds: 8),
            onTimeout: () {
              throw TimeoutException(
                'Request timed out reaching gateway at ${client.host}. Ensure the server is running and reachable.',
              );
            },
          );
      if (!success) {
        const msg =
            'Account creation request failed. Email may already be registered.';
        setState(() => _errorMessage = msg);
        _showErrorSnackBar(msg);
        return;
      }

      setState(() {
        _isAwaitingOtp = true;
      });

      _showSuccessSnackBar(
        'Validation OTP dispatched! Check backend server console output.',
      );
    } catch (e, st) {
      debugPrint('[LoginPage] Registration OTP error: $e');
      _handleError(e, st);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtpAndComplete() async {
    final email = _signUpEmailController.text.trim();
    final code = _signUpOtpController.text.trim();
    final password = _signUpPasswordController.text;

    if (code.isEmpty) {
      const msg = 'Please input the 8-digit verification code.';
      setState(() => _errorMessage = msg);
      _showErrorSnackBar(msg);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userInfo = await authCaller.email
          .createAccount(email, code)
          .timeout(
            const Duration(seconds: 8),
            onTimeout: () {
              throw TimeoutException(
                'Request timed out reaching gateway at ${client.host}.',
              );
            },
          );
      if (userInfo == null) {
        const msg =
            'Invalid verification OTP. Check backend server console logs.';
        setState(() => _errorMessage = msg);
        _showErrorSnackBar(msg);
        return;
      }

      // Auto-authenticate with registered credentials
      final response = await authCaller.email
          .authenticate(email, password)
          .timeout(const Duration(seconds: 8));
      if (response.success &&
          response.userInfo != null &&
          response.keyId != null &&
          response.key != null) {
        await sessionManager.registerSignedInUser(
          response.userInfo!,
          response.keyId!,
          response.key!,
        );
        if (mounted) {
          _showSuccessSnackBar(
            'Registration complete! Welcome to Command Ops.',
          );
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      } else {
        setState(() {
          _errorMessage =
              'Account confirmed! Please sign in with your credentials.';
        });
        _tabController.animateTo(0);
      }
    } catch (e, st) {
      debugPrint('[LoginPage] OTP verification error: $e');
      _handleError(e, st);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1015), // Deep Gunmetal
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 380),
                curve: Curves.easeOutCubic,
                builder: (context, value, animChild) {
                  return Transform.translate(
                    offset: Offset(0, 18 * (1.0 - value)),
                    child: Opacity(
                      opacity: value,
                      child: animChild,
                    ),
                  );
                },
                child: GlassContainer(
                  glowColor: const Color(0xFF00E5FF),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Emergency Command Badge
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B1214),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFC62828)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.crisis_alert_rounded,
                                size: 14,
                                color: Color(0xFFEF5350),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'DISASTER RESPONSE // COMMAND OPS',
                                style: TextStyle(
                                  color: Color(0xFFEF5350),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Platform Title
                      const Center(
                        child: Text(
                          'RELIEF RADAR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Center(
                        child: Text(
                          'First Responder & Field Operations Portal',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Target Host Node Pill
                      Center(
                        child: InkWell(
                          onTap: () => showGatewayConfigSheet(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E2833),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF2E3E50),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Color(0xFF4CAF50),
                                ),
                                const SizedBox(width: 6),
                                ListenableBuilder(
                                  listenable: activeServerUrlNotifier,
                                  builder: (context, _) {
                                    return Text(
                                      'GATEWAY: ${activeServerUrlNotifier.value}',
                                      style: const TextStyle(
                                        color: Color(0xFFCBD5E1),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.tune,
                                  size: 11,
                                  color: Color(0xFF94A3B8),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // In-Page Error Banner (if error occurred)
                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF371617),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFB71C1C)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Color(0xFFEF5350),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(
                                        color: Color(0xFFFFCDD2),
                                        fontSize: 12,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Color(0xFFEF5350),
                                    ),
                                    onPressed: () =>
                                        setState(() => _errorMessage = null),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                              if (_errorMessage!.contains('127.0.0.1') ||
                                  _errorMessage!.contains(
                                    'Unable to reach backend',
                                  ) ||
                                  _errorMessage!.contains('SocketException') ||
                                  _errorMessage!.contains(
                                    'Network Connection Failed',
                                  )) ...[
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: () =>
                                        showGatewayConfigSheet(context),
                                    icon: const Icon(
                                      Icons.settings_ethernet,
                                      size: 14,
                                    ),
                                    label: const Text(
                                      'CONFIGURE GATEWAY',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFFFF8A80),
                                      backgroundColor: const Color(0xFF4A191B),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Tactical Sliding Pill Tab Selector
                      ListenableBuilder(
                        listenable: _tabController,
                        builder: (context, _) {
                          final isSignIn = _tabController.index == 0;
                          return GlassContainer(
                            height: 48,
                            borderRadius: BorderRadius.circular(30),
                            backgroundColor: const Color(
                              0xFF0C1015,
                            ).withValues(alpha: 0.88),
                            borderColor: const Color(0xFF283545),
                            glowColor: isSignIn
                                ? const Color(0xFFC62828)
                                : const Color(0xFF00E5FF),
                            padding: const EdgeInsets.all(4),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final pillWidth = constraints.maxWidth / 2;
                                return Stack(
                                  children: [
                                    // Sliding Glow Pill Indicator
                                    AnimatedAlign(
                                      alignment: isSignIn
                                          ? Alignment.centerLeft
                                          : Alignment.centerRight,
                                      duration: const Duration(
                                        milliseconds: 240,
                                      ),
                                      curve: Curves.easeInOutCubic,
                                      child: Container(
                                        width: pillWidth,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            26,
                                          ),
                                          gradient: LinearGradient(
                                            colors: isSignIn
                                                ? [
                                                    const Color(0xFFC62828),
                                                    const Color(0xFFE53935),
                                                  ]
                                                : [
                                                    const Color(0xFF0097A7),
                                                    const Color(0xFF00E5FF),
                                                  ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  (isSignIn
                                                          ? const Color(
                                                              0xFFC62828,
                                                            )
                                                          : const Color(
                                                              0xFF00E5FF,
                                                            ))
                                                      .withValues(alpha: 0.45),
                                              blurRadius: 12,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Interactive Tab Labels
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              if (_tabController.index != 0) {
                                                _tabController.animateTo(0);
                                              }
                                            },
                                            child: Center(
                                              child: AnimatedDefaultTextStyle(
                                                duration: const Duration(
                                                  milliseconds: 200,
                                                ),
                                                style: TextStyle(
                                                  fontFamily: 'Rajdhani',
                                                  color: isSignIn
                                                      ? Colors.white
                                                      : const Color(0xFF94A3B8),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12.5,
                                                  letterSpacing: 0.8,
                                                ),
                                                child: const Text(
                                                  'RESPONDER LOGIN',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              if (_tabController.index != 1) {
                                                _tabController.animateTo(1);
                                              }
                                            },
                                            child: Center(
                                              child: AnimatedDefaultTextStyle(
                                                duration: const Duration(
                                                  milliseconds: 200,
                                                ),
                                                style: TextStyle(
                                                  fontFamily: 'Rajdhani',
                                                  color: !isSignIn
                                                      ? const Color(0xFF0C1015)
                                                      : const Color(0xFF94A3B8),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12.5,
                                                  letterSpacing: 0.8,
                                                ),
                                                child: const Text(
                                                  'REGISTER UNIT',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 18),

                      // Tab View Form Container (Natural height, no RenderFlex clipping or gesture conflicts)
                      ListenableBuilder(
                        listenable: _tabController,
                        builder: (context, _) {
                          if (_tabController.index == 0) {
                            // 1. Sign In Tab
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildTextField(
                                  controller: _signInEmailController,
                                  label: 'Responder Email',
                                  icon: Icons.alternate_email,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 12),
                                _buildTextField(
                                  controller: _signInPasswordController,
                                  label: 'Security Password',
                                  icon: Icons.lock_outline,
                                  obscureText: _obscureSignInPassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureSignInPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color(0xFF94A3B8),
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureSignInPassword =
                                            !_obscureSignInPassword;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 18),
                                ElevatedButton.icon(
                                  onPressed: _isLoading ? null : _signInDirect,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFC62828),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 3,
                                  ),
                                  icon: _isLoading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.security, size: 20),
                                  label: Text(
                                    _isLoading
                                        ? 'AUTHENTICATING...'
                                        : 'AUTHORIZE & LOG IN',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.8,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          // 2. Register Tab
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (!_isAwaitingOtp) ...[
                                _buildTextField(
                                  controller: _signUpNameController,
                                  label: 'Full Name / Call Sign',
                                  icon: Icons.badge_outlined,
                                ),
                                const SizedBox(height: 10),
                                _buildTextField(
                                  controller: _signUpEmailController,
                                  label: 'Official Email',
                                  icon: Icons.alternate_email,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 10),
                                _buildTextField(
                                  controller: _signUpPasswordController,
                                  label: 'Create Password (min. 8 chars)',
                                  icon: Icons.lock_outline,
                                  obscureText: _obscureSignUpPassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureSignUpPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color(0xFF94A3B8),
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureSignUpPassword =
                                            !_obscureSignUpPassword;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 18),
                                ElevatedButton.icon(
                                  onPressed: _isLoading
                                      ? null
                                      : _requestSignUpOtp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFC62828),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  icon: _isLoading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.send_rounded,
                                          size: 18,
                                        ),
                                  label: Text(
                                    _isLoading
                                        ? 'REQUESTING...'
                                        : 'DISPATCH VERIFICATION OTP',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ] else ...[
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF172C1C),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: const Color(0xFF2E7D32),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        color: Color(0xFF81C784),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'OTP printed in server console for ${_signUpEmailController.text}.',
                                          style: const TextStyle(
                                            color: Color(0xFFC8E6C9),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildTextField(
                                  controller: _signUpOtpController,
                                  label: 'Enter 8-Digit OTP Code',
                                  icon: Icons.pin_outlined,
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(height: 18),
                                ElevatedButton.icon(
                                  onPressed: _isLoading
                                      ? null
                                      : _verifyOtpAndComplete,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2E7D32),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  icon: _isLoading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.verified, size: 18),
                                  label: const Text(
                                    'CONFIRM OTP & COMPLETE',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                TextButton(
                                  onPressed: () =>
                                      setState(() => _isAwaitingOtp = false),
                                  child: const Text(
                                    'Back to details form',
                                    style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Expanded(child: Divider(color: Color(0xFF283545))),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'OR STANDARD SERVERPOD MODAL',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Color(0xFF283545))),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Standard Serverpod SignInWithEmailButton
                      // Any uncaught error inside its modal dialog is automatically intercepted
                      // by Client.onFailedCall and displayed via SnackBar & AlertDialog!
                      Center(
                        child: SignInWithEmailButton(
                          caller: authCaller,
                          onSignedIn: () {
                            _onSessionChanged();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E2833),
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF384B60)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                          ),
                          label: const Text(
                            'Launch Serverpod Email Dialog',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          icon: const Icon(Icons.open_in_new, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
        prefixIcon: Icon(icon, color: const Color(0xFFEF5350), size: 18),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF0F151C),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF283545)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1.5),
        ),
      ),
    );
  }
}
