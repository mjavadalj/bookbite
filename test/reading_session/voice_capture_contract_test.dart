import 'package:bookbite/features/reading_session/presentation/voice_capture_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('voice capture automatically stops at five seconds', () {
    expect(VoiceCapturePage.maximumDuration, const Duration(seconds: 5));
  });
}
