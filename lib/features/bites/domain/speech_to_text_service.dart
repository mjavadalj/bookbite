abstract interface class SpeechToTextService {
  Future<String> transcribe(String managedAudioReference);
}
