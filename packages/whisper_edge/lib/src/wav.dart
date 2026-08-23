import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

/// Sample rate whisper models operate on.
const int whisperSampleRate = 16000;

/// Thrown when an audio file cannot be parsed.
class WavFormatException implements Exception {
  WavFormatException(this.message);

  final String message;

  @override
  String toString() => 'WavFormatException: $message';
}

/// Decodes a RIFF/WAVE file into mono float32 PCM at 16 kHz, the input
/// format whisper expects. Handles PCM 8/16/24/32-bit and float32 sources,
/// downmixes multi-channel audio and linearly resamples other sample rates.
Float32List decodeWavToWhisperPcm(Uint8List bytes) {
  final data = ByteData.sublistView(bytes);
  if (bytes.length < 44 ||
      _fourCc(data, 0) != 'RIFF' ||
      _fourCc(data, 8) != 'WAVE') {
    throw WavFormatException('Not a RIFF/WAVE file');
  }

  int? audioFormat;
  int channels = 1;
  int sampleRate = whisperSampleRate;
  int bitsPerSample = 16;
  int? dataOffset;
  int? dataLength;

  var offset = 12;
  while (offset + 8 <= bytes.length) {
    final chunkId = _fourCc(data, offset);
    final chunkSize = data.getUint32(offset + 4, Endian.little);
    final chunkStart = offset + 8;
    if (chunkId == 'fmt ') {
      audioFormat = data.getUint16(chunkStart, Endian.little);
      channels = data.getUint16(chunkStart + 2, Endian.little);
      sampleRate = data.getUint32(chunkStart + 4, Endian.little);
      bitsPerSample = data.getUint16(chunkStart + 14, Endian.little);
      if (audioFormat == 0xFFFE /* WAVE_FORMAT_EXTENSIBLE */ &&
          chunkSize >= 40) {
        // SubFormat GUID starts with the effective format code.
        audioFormat = data.getUint16(chunkStart + 24, Endian.little);
      }
    } else if (chunkId == 'data') {
      dataOffset = chunkStart;
      dataLength = math.min(chunkSize, bytes.length - chunkStart);
    }
    // Chunks are word-aligned.
    offset = chunkStart + chunkSize + (chunkSize.isOdd ? 1 : 0);
  }

  if (audioFormat == null) {
    throw WavFormatException('Missing fmt chunk');
  }
  if (dataOffset == null || dataLength == null) {
    throw WavFormatException('Missing data chunk');
  }
  if (channels < 1) {
    throw WavFormatException('Invalid channel count: $channels');
  }

  final samples = _decodeSamples(
      data, dataOffset, dataLength, audioFormat, bitsPerSample);
  final mono = _downmix(samples, channels);
  return resamplePcm(mono, sampleRate, whisperSampleRate);
}

/// Convenience wrapper over [decodeWavToWhisperPcm] for a file on disk.
Future<Float32List> decodeWavFileToWhisperPcm(String path) async {
  return decodeWavToWhisperPcm(await File(path).readAsBytes());
}

/// Converts raw 16-bit little-endian mono PCM (e.g. a live recording stream)
/// into whisper's float32 format.
Float32List pcm16ToFloat32(Uint8List bytes) {
  final data = ByteData.sublistView(bytes);
  final out = Float32List(bytes.length ~/ 2);
  for (var i = 0; i < out.length; i++) {
    out[i] = data.getInt16(i * 2, Endian.little) / 32768.0;
  }
  return out;
}

/// Linear resampler. Fine for speech; use a proper resampler if you need
/// audiophile quality.
Float32List resamplePcm(Float32List input, int fromRate, int toRate) {
  if (fromRate == toRate || input.isEmpty) {
    return input;
  }
  final ratio = fromRate / toRate;
  final outLength = (input.length / ratio).floor();
  final out = Float32List(outLength);
  for (var i = 0; i < outLength; i++) {
    final pos = i * ratio;
    final idx = pos.floor();
    final frac = pos - idx;
    final a = input[idx];
    final b = idx + 1 < input.length ? input[idx + 1] : a;
    out[i] = a + (b - a) * frac;
  }
  return out;
}

String _fourCc(ByteData data, int offset) {
  return String.fromCharCodes([
    data.getUint8(offset),
    data.getUint8(offset + 1),
    data.getUint8(offset + 2),
    data.getUint8(offset + 3),
  ]);
}

Float32List _decodeSamples(ByteData data, int offset, int length,
    int audioFormat, int bitsPerSample) {
  switch ((audioFormat, bitsPerSample)) {
    case (1, 8):
      final out = Float32List(length);
      for (var i = 0; i < out.length; i++) {
        out[i] = (data.getUint8(offset + i) - 128) / 128.0;
      }
      return out;
    case (1, 16):
      final out = Float32List(length ~/ 2);
      for (var i = 0; i < out.length; i++) {
        out[i] = data.getInt16(offset + i * 2, Endian.little) / 32768.0;
      }
      return out;
    case (1, 24):
      final out = Float32List(length ~/ 3);
      for (var i = 0; i < out.length; i++) {
        final base = offset + i * 3;
        var v = data.getUint8(base) |
            (data.getUint8(base + 1) << 8) |
            (data.getUint8(base + 2) << 16);
        if (v >= 0x800000) v -= 0x1000000;
        out[i] = v / 8388608.0;
      }
      return out;
    case (1, 32):
      final out = Float32List(length ~/ 4);
      for (var i = 0; i < out.length; i++) {
        out[i] = data.getInt32(offset + i * 4, Endian.little) / 2147483648.0;
      }
      return out;
    case (3, 32):
      final out = Float32List(length ~/ 4);
      for (var i = 0; i < out.length; i++) {
        out[i] = data.getFloat32(offset + i * 4, Endian.little);
      }
      return out;
    default:
      throw WavFormatException(
          'Unsupported WAV encoding: format=$audioFormat, '
          '$bitsPerSample bits per sample');
  }
}

Float32List _downmix(Float32List interleaved, int channels) {
  if (channels == 1) {
    return interleaved;
  }
  final frames = interleaved.length ~/ channels;
  final out = Float32List(frames);
  for (var i = 0; i < frames; i++) {
    var sum = 0.0;
    for (var c = 0; c < channels; c++) {
      sum += interleaved[i * channels + c];
    }
    out[i] = sum / channels;
  }
  return out;
}
