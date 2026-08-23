import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

/// Opaque handle to the native `we_context` (a loaded whisper model).
final class WeContext extends Opaque {}

typedef WeContextPtr = Pointer<WeContext>;

typedef _WeInitNative = WeContextPtr Function(Pointer<Utf8>, Int32);
typedef _WeInitDart = WeContextPtr Function(Pointer<Utf8>, int);

typedef _WeFreeNative = Void Function(WeContextPtr);
typedef _WeFreeDart = void Function(WeContextPtr);

typedef _WeTranscribeNative = Int32 Function(
    WeContextPtr, Pointer<Float>, Int32, Pointer<Utf8>, Int32, Int32, Int32);
typedef _WeTranscribeDart = int Function(
    WeContextPtr, Pointer<Float>, int, Pointer<Utf8>, int, int, int);

/// Flag values accepted by `we_transcribe` (see whisper_edge.h).
const int weFlagNoContext = 1;
const int weFlagSuppressNonSpeech = 2;

typedef _WeIntOfCtxNative = Int32 Function(WeContextPtr);
typedef _WeIntOfCtxDart = int Function(WeContextPtr);

typedef _WeSegmentTextNative = Pointer<Utf8> Function(WeContextPtr, Int32);
typedef _WeSegmentTextDart = Pointer<Utf8> Function(WeContextPtr, int);

typedef _WeSegmentTimeNative = Int64 Function(WeContextPtr, Int32);
typedef _WeSegmentTimeDart = int Function(WeContextPtr, int);

typedef _WeStrOfCtxNative = Pointer<Utf8> Function(WeContextPtr);
typedef _WeStrOfCtxDart = Pointer<Utf8> Function(WeContextPtr);

typedef _WeStrNative = Pointer<Utf8> Function();
typedef _WeStrDart = Pointer<Utf8> Function();

const String _libName = 'whisper_edge';

final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    try {
      return DynamicLibrary.open('$_libName.framework/$_libName');
    } on ArgumentError {
      // Statically linked (e.g. `use_frameworks! :linkage => :static`).
      return DynamicLibrary.process();
    }
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// Low-level bindings to the whisper_edge C shim. Prefer the high-level
/// [WhisperTranscriber] API; this is exposed for advanced use only.
class WhisperEdgeBindings {
  WhisperEdgeBindings._();

  static final WhisperEdgeBindings instance = WhisperEdgeBindings._();

  final weInit =
      _dylib.lookupFunction<_WeInitNative, _WeInitDart>('we_init');
  final weFree =
      _dylib.lookupFunction<_WeFreeNative, _WeFreeDart>('we_free');
  final weTranscribe = _dylib
      .lookupFunction<_WeTranscribeNative, _WeTranscribeDart>('we_transcribe');
  final weNSegments = _dylib
      .lookupFunction<_WeIntOfCtxNative, _WeIntOfCtxDart>('we_n_segments');
  final weSegmentText =
      _dylib.lookupFunction<_WeSegmentTextNative, _WeSegmentTextDart>(
          'we_segment_text');
  final weSegmentT0 =
      _dylib.lookupFunction<_WeSegmentTimeNative, _WeSegmentTimeDart>(
          'we_segment_t0');
  final weSegmentT1 =
      _dylib.lookupFunction<_WeSegmentTimeNative, _WeSegmentTimeDart>(
          'we_segment_t1');
  final weDetectedLanguage =
      _dylib.lookupFunction<_WeStrOfCtxNative, _WeStrOfCtxDart>(
          'we_detected_language');
  final weProgress = _dylib
      .lookupFunction<_WeIntOfCtxNative, _WeIntOfCtxDart>('we_progress');
  final weAbort =
      _dylib.lookupFunction<_WeFreeNative, _WeFreeDart>('we_abort');
  final weSystemInfo =
      _dylib.lookupFunction<_WeStrNative, _WeStrDart>('we_system_info');
}
