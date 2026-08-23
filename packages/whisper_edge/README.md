# whisper_edge

On-device speech-to-text for Flutter, powered by
[whisper.cpp](https://github.com/ggml-org/whisper.cpp). Fully offline
transcription with timestamps, language detection, translation-to-English
and built-in model downloads — on iOS and Android.

- **iOS**: prebuilt `whisper.xcframework` with Metal + Accelerate acceleration (iOS 16.4+)
- **Android**: whisper.cpp compiled from source by the NDK (minSdk 24), ARM NEON optimized
- Heavy work runs in a worker isolate — the UI never blocks
- Progress reporting and cancellation
- WAV decoding helpers (any common encoding/sample rate → 16 kHz mono PCM)

## Quick start

```dart
import 'package:path_provider/path_provider.dart';
import 'package:whisper_edge/whisper_edge.dart';

// 1. Download a model once (≈60 MB for base-q5_1).
final dir = await getApplicationSupportDirectory();
final modelPath = await WhisperModelDownloader().download(
  WhisperModel.baseQ5_1,
  dir,
  onProgress: (received, total) => print('$received / $total'),
);

// 2. Load it.
final transcriber = await WhisperTranscriber.load(modelPath);

// 3. Transcribe a WAV file (or raw 16 kHz mono Float32List PCM).
final result = await transcriber.transcribeWavFile(
  '/path/to/audio.wav',
  language: 'auto',            // or "en", "tr", ...
  onProgress: (p) => print('$p%'),
);

print(result.language);        // detected language
for (final s in result.segments) {
  print('[${s.start} → ${s.end}] ${s.text}');
}

// 4. Free the native model when done.
transcriber.dispose();
```

`transcriber.cancel()` aborts an in-flight run.
`WhisperTranscriber.systemInfo` reports the compiled ggml backends.

## Choosing a model

| Model | Size | Notes |
|---|---|---|
| `tinyQ5_1` | 32 MB | fastest, rough quality |
| `baseQ5_1` | 60 MB | good default for phones |
| `smallQ5_1` | 190 MB | best quality/speed balance on recent devices |
| `largeV3TurboQ5_0` | 574 MB | near large-v3 quality, high-end devices |

`.en` variants (`tinyEn`, `baseEn`, `smallEn`) are English-only but more
accurate at the same size. Models come from the official
[ggerganov/whisper.cpp](https://huggingface.co/ggerganov/whisper.cpp)
Hugging Face repo; you can also load any compatible ggml `.bin` file by
passing its path straight to `WhisperTranscriber.load`.

## Audio input

Whisper expects **16 kHz mono float32 PCM**:

- `transcribeWavFile(path)` accepts WAV in PCM 8/16/24/32-bit or float32 at
  any sample rate/channel count and converts automatically.
- `transcribe(Float32List pcm)` takes raw samples — pair it with a recorder
  configured for 16 kHz mono (e.g. the `record` package with
  `AudioEncoder.wav`, `sampleRate: 16000`, `numChannels: 1`).
- `pcm16ToFloat32` / `resamplePcm` helpers cover live-stream use cases.

For compressed formats (m4a, mp3, ...), convert to WAV first (e.g. with
`ffmpeg_kit_flutter`) — kept out of this package to stay lightweight.

## How the native side works

- `src/whisper.cpp/` is a pruned, vendored copy of whisper.cpp
  (see `src/whisper.cpp/VENDORED_VERSION`), refreshed with
  `tool/fetch_whisper_cpp.sh`.
- Android compiles it from source via the plugin's CMake build.
- iOS links the prebuilt `ios/Frameworks/whisper.xcframework`, rebuilt with
  `tool/build_ios_xcframework.sh` (uses whisper.cpp's official
  `build-xcframework.sh`).
- Dart talks to a small C shim (`src/whisper_edge.c`) over FFI, so whisper.cpp
  upgrades never change the Dart-visible ABI.

## License

MIT. whisper.cpp is MIT-licensed by Georgi Gerganov and contributors; the
vendored copy retains its license file.
