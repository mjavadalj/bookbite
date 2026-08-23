## 0.1.1

* `WhisperModel`: full ggerganov/whisper.cpp catalog (33 models) with exact published sizes — adds medium, large-v1/v2/v3, large-v3-turbo and all q5/q8 + `.en` quantized variants.
* `WhisperModelDownloader.delete` removes a downloaded model (and any stale `.part` file).
* Fixed `englishOnly` detection for quantized `.en` variants (e.g. `ggml-base.en-q5_1.bin`).

## 0.1.0

* Initial release: offline transcription on iOS and Android via whisper.cpp v1.9.1.
* `WhisperTranscriber` — isolate-based transcription with timestamps, language detection, translate-to-English, progress and cancellation.
* `WhisperModelDownloader` + `WhisperModel` catalog (official ggml models from Hugging Face).
* WAV decoding helpers (PCM 8/16/24/32-bit and float32, resampling, downmix).
* iOS: prebuilt Metal/Accelerate xcframework (iOS 16.4+). Android: built from source with the NDK (minSdk 24).
