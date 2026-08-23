import 'package:bookbite/app/theme/bookbite_theme.dart';
import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    required this.onComplete,
    required this.onToggleLocale,
    super.key,
  });

  final Future<void> Function() onComplete;
  final VoidCallback onToggleLocale;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await widget.onComplete();
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        final s = BookBiteLocalizations.of(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(s.onboardingSaveFailed)));
      }
    }
  }

  void _next() {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    _controller.nextPage(
      duration: reduceMotion ? Duration.zero : BookBiteTokens.motionDuration,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    final pages = [
      _OnboardingSlide(
        title: s.onboardingLibraryTitle,
        body: s.onboardingLibraryBody,
        illustration: const _LibraryIllustration(),
      ),
      _OnboardingSlide(
        title: s.onboardingCaptureTitle,
        body: s.onboardingCaptureBody,
        illustration: const _CaptureIllustration(),
      ),
      _OnboardingSlide(
        title: s.onboardingPrivateTitle,
        body: s.onboardingPrivateBody,
        illustration: const _PrivateIllustration(),
      ),
    ];
    final last = _index == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _saving ? null : widget.onToggleLocale,
                    child: Text(s.switchLanguage),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _saving ? null : _finish,
                    child: Text(s.skip),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (value) => setState(() => _index = value),
                children: pages,
              ),
            ),
            Semantics(
              label: s.onboardingPagePosition(_index + 1, pages.length),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < pages.length; i++)
                    AnimatedContainer(
                      duration: MediaQuery.disableAnimationsOf(context)
                          ? Duration.zero
                          : BookBiteTokens.motionDuration,
                      width: i == _index ? 28 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: i == _index
                            ? BookBiteTokens.primary
                            : BookBiteTokens.border,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saving ? null : (last ? _finish : _next),
                  icon: _saving && last
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          last
                              ? Icons.check_rounded
                              : Icons.arrow_forward_rounded,
                        ),
                  label: Text(last ? s.getStarted : s.next),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.title,
    required this.body,
    required this.illustration,
  });

  final String title;
  final String body;
  final Widget illustration;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final horizontal = constraints.maxWidth >= 700;
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 12, 28, 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
          child: horizontal
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: _illustration()),
                    const SizedBox(width: 48),
                    Expanded(child: _copy(context)),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _illustration(),
                    const SizedBox(height: 32),
                    _copy(context),
                  ],
                ),
        ),
      );
    },
  );

  Widget _illustration() => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 440),
    child: illustration,
  );

  Widget _copy(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 520),
    child: Column(
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          body,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    ),
  );
}

class _IllustrationFrame extends StatelessWidget {
  const _IllustrationFrame({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1.25,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: BookBiteTokens.softSurface,
        border: Border.all(color: BookBiteTokens.border),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(padding: const EdgeInsets.all(24), child: child),
    ),
  );
}

class _LibraryIllustration extends StatelessWidget {
  const _LibraryIllustration();

  @override
  Widget build(BuildContext context) => _IllustrationFrame(
    child: Column(
      children: [
        const Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _book(52, BookBiteTokens.atmosphericSage),
            _book(68, BookBiteTokens.shelfEdge),
            _book(58, BookBiteTokens.primary),
            _book(74, BookBiteTokens.shelfWood),
            _book(62, BookBiteTokens.activityHigh),
          ],
        ),
        Container(height: 9, color: BookBiteTokens.shelfBoard),
      ],
    ),
  );

  static Widget _book(double height, Color color) => Container(
    width: 34,
    height: height,
    margin: const EdgeInsets.symmetric(horizontal: 3),
    decoration: BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
    ),
  );
}

class _CaptureIllustration extends StatelessWidget {
  const _CaptureIllustration();

  @override
  Widget build(BuildContext context) => _IllustrationFrame(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _captureIcon(Icons.photo_camera_outlined),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Icon(Icons.arrow_forward_rounded),
            ),
            _captureIcon(Icons.mic_none_rounded),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          constraints: const BoxConstraints(maxWidth: 270),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: BookBiteTokens.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: BookBiteTokens.border),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TextLine(width: 210),
              SizedBox(height: 8),
              _TextLine(width: 170),
              SizedBox(height: 8),
              _TextLine(width: 196),
            ],
          ),
        ),
      ],
    ),
  );

  static Widget _captureIcon(IconData icon) => Container(
    width: 68,
    height: 68,
    decoration: const BoxDecoration(
      color: BookBiteTokens.selectedSurface,
      shape: BoxShape.circle,
    ),
    child: Icon(icon, size: 32, color: BookBiteTokens.primary),
  );
}

class _TextLine extends StatelessWidget {
  const _TextLine({required this.width});
  final double width;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: 7,
    decoration: BoxDecoration(
      color: BookBiteTokens.atmosphericSage.withValues(alpha: .45),
      borderRadius: BorderRadius.circular(5),
    ),
  );
}

class _PrivateIllustration extends StatelessWidget {
  const _PrivateIllustration();

  @override
  Widget build(BuildContext context) => const _IllustrationFrame(
    child: Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.square(
            dimension: 170,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 2,
              color: BookBiteTokens.border,
            ),
          ),
          Icon(
            Icons.lock_outline_rounded,
            size: 116,
            color: BookBiteTokens.primary,
          ),
        ],
      ),
    ),
  );
}
