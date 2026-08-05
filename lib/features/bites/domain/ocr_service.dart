abstract interface class OcrService {
  Future<String> extractText(String managedImageReference);
}
