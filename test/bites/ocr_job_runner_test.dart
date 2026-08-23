import 'package:bookbite/features/bites/application/ocr_job_runner.dart';
import 'package:bookbite/features/bites/domain/ocr_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeOcrService implements OcrService {
  const _FakeOcrService(this.result);

  final String result;

  @override
  Future<String> extractText(String managedImageReference) async => result;
}

class _FailingOcrService implements OcrService {
  const _FailingOcrService();

  @override
  Future<String> extractText(String managedImageReference) =>
      Future<String>.error(StateError('fixture failure'));
}

void main() {
  test('runs one queued OCR job and publishes ready text', () async {
    final runner = OcrJobRunner(const _FakeOcrService(' Hello\r\nworld '));
    addTearDown(runner.dispose);

    await runner.enqueue(id: 'bite-1', imageReference: '/managed/page.jpg');
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(runner.snapshot('bite-1')?.status, OcrJobStatus.ready);
    expect(runner.snapshot('bite-1')?.text, 'Hello\nworld');
  });

  test('duplicate enqueue is idempotent', () async {
    final runner = OcrJobRunner(const _FakeOcrService('text'));
    addTearDown(runner.dispose);

    await runner.enqueue(id: 'bite-1', imageReference: '/managed/page.jpg');
    await runner.enqueue(id: 'bite-1', imageReference: '/managed/page-2.jpg');
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(runner.snapshot('bite-1')?.text, 'text');
  });

  test('publishes a recoverable failed status', () async {
    final runner = OcrJobRunner(const _FailingOcrService());
    addTearDown(runner.dispose);

    await runner.enqueue(id: 'bite-1', imageReference: '/managed/page.jpg');
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(runner.snapshot('bite-1')?.status, OcrJobStatus.failed);
    expect(runner.snapshot('bite-1')?.error, 'ocr_failed');
  });
}
