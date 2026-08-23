import 'dart:io';

import 'package:bookbite/features/onboarding/domain/onboarding_store.dart';
import 'package:path_provider/path_provider.dart';

class FileOnboardingStore implements OnboardingStore {
  const FileOnboardingStore();

  static const markerName = '.bookbite_onboarding_v1';

  Future<File> _marker() async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}${Platform.pathSeparator}$markerName');
  }

  @override
  Future<bool> isComplete() async => (await _marker()).exists();

  @override
  Future<void> markComplete() async {
    final marker = await _marker();
    await marker.writeAsString('complete\n', flush: true);
  }
}
