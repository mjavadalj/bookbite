import 'dart:io';

/// Prebuilt ggml whisper models hosted on Hugging Face
/// (https://huggingface.co/ggerganov/whisper.cpp) — the complete catalog,
/// with sizes as published there.
///
/// Rough guidance for phones: `tinyQ5_1`/`baseQ5_1` are fast and light,
/// `smallQ5_1` is the sweet spot for quality vs. speed on recent devices,
/// `mediumQ5_0`/`largeV3TurboQ5_0` need a recent high-end device, and the
/// full large models are mostly desktop material. `.en` variants are
/// English-only but noticeably better at the same size.
enum WhisperModel {
  tiny('ggml-tiny.bin', 78),
  tinyQ5_1('ggml-tiny-q5_1.bin', 32),
  tinyQ8_0('ggml-tiny-q8_0.bin', 44),
  tinyEn('ggml-tiny.en.bin', 78),
  tinyEnQ5_1('ggml-tiny.en-q5_1.bin', 32),
  tinyEnQ8_0('ggml-tiny.en-q8_0.bin', 44),
  base('ggml-base.bin', 148),
  baseQ5_1('ggml-base-q5_1.bin', 60),
  baseQ8_0('ggml-base-q8_0.bin', 82),
  baseEn('ggml-base.en.bin', 148),
  baseEnQ5_1('ggml-base.en-q5_1.bin', 60),
  baseEnQ8_0('ggml-base.en-q8_0.bin', 82),
  small('ggml-small.bin', 488),
  smallQ5_1('ggml-small-q5_1.bin', 190),
  smallQ8_0('ggml-small-q8_0.bin', 264),
  smallEn('ggml-small.en.bin', 488),
  smallEnQ5_1('ggml-small.en-q5_1.bin', 190),
  smallEnQ8_0('ggml-small.en-q8_0.bin', 264),
  medium('ggml-medium.bin', 1534),
  mediumQ5_0('ggml-medium-q5_0.bin', 539),
  mediumQ8_0('ggml-medium-q8_0.bin', 823),
  mediumEn('ggml-medium.en.bin', 1534),
  mediumEnQ5_0('ggml-medium.en-q5_0.bin', 539),
  mediumEnQ8_0('ggml-medium.en-q8_0.bin', 823),
  largeV1('ggml-large-v1.bin', 3095),
  largeV2('ggml-large-v2.bin', 3095),
  largeV2Q5_0('ggml-large-v2-q5_0.bin', 1081),
  largeV2Q8_0('ggml-large-v2-q8_0.bin', 1656),
  largeV3('ggml-large-v3.bin', 3095),
  largeV3Q5_0('ggml-large-v3-q5_0.bin', 1081),
  largeV3Turbo('ggml-large-v3-turbo.bin', 1625),
  largeV3TurboQ5_0('ggml-large-v3-turbo-q5_0.bin', 574),
  largeV3TurboQ8_0('ggml-large-v3-turbo-q8_0.bin', 874);

  const WhisperModel(this.fileName, this.approxSizeMb);

  final String fileName;
  final int approxSizeMb;

  Uri get downloadUri => Uri.parse(
      'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/$fileName');

  /// Whether the model only supports English audio.
  bool get englishOnly => fileName.contains('.en');
}

/// Downloads ggml models with progress reporting and atomic writes.
class WhisperModelDownloader {
  WhisperModelDownloader({HttpClient? client})
      : _client = client ?? HttpClient();

  final HttpClient _client;

  /// Path the model would be stored at inside [directory].
  static String pathFor(WhisperModel model, Directory directory) =>
      '${directory.path}${Platform.pathSeparator}${model.fileName}';

  /// Returns true when [model] is already fully downloaded in [directory].
  static Future<bool> isDownloaded(
      WhisperModel model, Directory directory) async {
    return File(pathFor(model, directory)).exists();
  }

  /// Deletes [model] from [directory] (including a half-finished .part
  /// file). Returns true if anything was removed. Don't delete a model
  /// that is currently loaded in a [WhisperTranscriber]; dispose it first.
  static Future<bool> delete(WhisperModel model, Directory directory) async {
    var removed = false;
    final file = File(pathFor(model, directory));
    if (await file.exists()) {
      await file.delete();
      removed = true;
    }
    final partial = File('${file.path}.part');
    if (await partial.exists()) {
      await partial.delete();
      removed = true;
    }
    return removed;
  }

  /// Downloads [model] into [directory] and returns the file path.
  /// If the model already exists it is returned immediately.
  ///
  /// [onProgress] receives (receivedBytes, totalBytes); totalBytes is -1
  /// when the server does not report a length.
  Future<String> download(
    WhisperModel model,
    Directory directory, {
    void Function(int received, int total)? onProgress,
  }) async {
    final target = File(pathFor(model, directory));
    if (await target.exists()) {
      return target.path;
    }
    await directory.create(recursive: true);

    final request = await _client.getUrl(model.downloadUri);
    request.followRedirects = true;
    request.maxRedirects = 10;
    final response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
          'Model download failed with HTTP ${response.statusCode}',
          uri: model.downloadUri);
    }

    final partial = File('${target.path}.part');
    final sink = partial.openWrite();
    final total = response.contentLength;
    var received = 0;
    try {
      await for (final chunk in response) {
        sink.add(chunk);
        received += chunk.length;
        onProgress?.call(received, total);
      }
      await sink.flush();
    } finally {
      await sink.close();
    }
    if (total > 0 && received != total) {
      await partial.delete();
      throw const HttpException('Model download was truncated');
    }
    await partial.rename(target.path);
    return target.path;
  }

  void close() => _client.close(force: true);
}
