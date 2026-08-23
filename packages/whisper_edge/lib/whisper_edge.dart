/// On-device speech-to-text for Flutter, powered by whisper.cpp.
///
/// Load a ggml whisper model with [WhisperTranscriber.load], then feed it
/// 16 kHz mono PCM (or any WAV file) to get timestamped transcripts —
/// fully offline, on iOS and Android.
library;

export 'src/live_transcriber.dart';
export 'src/models.dart';
export 'src/transcriber.dart';
export 'src/wav.dart';
