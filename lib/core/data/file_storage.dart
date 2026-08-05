abstract interface class ManagedFileStorage {
  Future<String> persist({
    required String temporaryPath,
    required String mediaId,
  });

  Future<void> delete(String managedReference);
}
