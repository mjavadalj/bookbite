import 'dart:io';

import 'package:bookbite/core/data/file_storage.dart';
import 'package:path_provider/path_provider.dart';

class LocalManagedFileStorage implements ManagedFileStorage {
  const LocalManagedFileStorage();

  @override
  Future<String> persist({
    required String temporaryPath,
    required String mediaId,
  }) async {
    final source = File(temporaryPath);
    if (!await source.exists()) throw StateError('Capture source is missing.');
    final length = await source.length();
    if (length <= 0 || length > 64 * 1024 * 1024) {
      throw const FormatException('Capture source has an invalid size.');
    }
    final root = await getApplicationSupportDirectory();
    final directory = Directory('${root.path}${Platform.pathSeparator}media');
    await directory.create(recursive: true);
    final extension = _safeExtension(source.path);
    final destination = File(
      '${directory.path}${Platform.pathSeparator}$mediaId$extension',
    );
    final partial = File('${destination.path}.partial');
    final sink = partial.openWrite();
    await sink.addStream(source.openRead());
    await sink.flush();
    await sink.close();
    if (await partial.length() != length) {
      await partial.delete();
      throw StateError('Capture copy verification failed.');
    }
    await partial.rename(destination.path);
    return destination.path;
  }

  @override
  Future<void> delete(String managedReference) async {
    final file = File(managedReference);
    if (await file.exists()) await file.delete();
  }

  @override
  Future<List<String>> listManagedReferences() async {
    final root = await getApplicationSupportDirectory();
    final directory = Directory('${root.path}${Platform.pathSeparator}media');
    if (!await directory.exists()) return const [];
    final references = <String>[];
    await for (final entity in directory.list()) {
      if (entity is! File) continue;
      if (entity.path.endsWith('.partial')) {
        await entity.delete();
      } else {
        references.add(entity.path);
      }
    }
    return references;
  }

  String _safeExtension(String path) {
    final dot = path.lastIndexOf('.');
    if (dot < 0) return '.bin';
    final value = path.substring(dot).toLowerCase();
    return switch (value) {
      '.jpg' || '.jpeg' || '.png' || '.webp' || '.wav' => value,
      _ => '.bin',
    };
  }
}
