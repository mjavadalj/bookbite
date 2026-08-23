import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:flutter/material.dart';

class BookBiteLaunchPage extends StatefulWidget {
  const BookBiteLaunchPage({this.error = false, this.onRetry, super.key});

  final bool error;
  final VoidCallback? onRetry;

  @override
  State<BookBiteLaunchPage> createState() => _BookBiteLaunchPageState();
}

class _BookBiteLaunchPageState extends State<BookBiteLaunchPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.error) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _progressController.value = 1;
    } else if (!_progressController.isAnimating &&
        _progressController.value == 0) {
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF3EEE2),
      body: SafeArea(
        child: Semantics(
          label: widget.error ? s.launchFailed : s.preparingBookBite,
          liveRegion: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 26),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: widget.error
                        ? _LaunchError(
                            message: s.launchFailed,
                            retryLabel: s.retry,
                            onRetry: widget.onRetry,
                          )
                        : const _LaunchIdentity(),
                  ),
                ),
                if (!widget.error)
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) => _LaunchProgressBar(
                      progress: .58 * _progressController.value,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LaunchIdentity extends StatelessWidget {
  const _LaunchIdentity();

  @override
  Widget build(BuildContext context) => const Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      _BookBiteMark(size: 56),
      SizedBox(height: 16),
      Text(
        'BookBite',
        maxLines: 1,
        style: TextStyle(
          color: Color(0xFF2B2820),
          fontFamily: 'serif',
          fontSize: 26,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
          letterSpacing: -.25,
          height: 1,
        ),
      ),
    ],
  );
}

class _LaunchProgressBar extends StatelessWidget {
  const _LaunchProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        key: const ValueKey('bookbite-launch-progress'),
        height: 2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: Color(0x1A2B2820)),
            FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: progress,
              child: const ColoredBox(color: Color(0xFF6B7052)),
            ),
          ],
        ),
      ),
    ),
  );
}

class _LaunchError extends StatelessWidget {
  const _LaunchError({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const _BookBiteMark(size: 56),
      const SizedBox(height: 24),
      Text(message, textAlign: TextAlign.center),
      const SizedBox(height: 16),
      FilledButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh_rounded),
        label: Text(retryLabel),
      ),
    ],
  );
}

class _BookBiteMark extends StatelessWidget {
  const _BookBiteMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(painter: const _BookBiteMarkPainter()),
  );
}

class _BookBiteMarkPainter extends CustomPainter {
  const _BookBiteMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 512;
    canvas.scale(scale, scale);
    final olive = Paint()..color = const Color(0xFF6B7052);
    final cream = Paint()..color = const Color(0xFFF3EEE2);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 512, 512),
        const Radius.circular(112),
      ),
      olive,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(158, 128, 196, 256),
        const Radius.circular(20),
      ),
      cream,
    );
    canvas.drawCircle(const Offset(322, 156), 44, olive);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
