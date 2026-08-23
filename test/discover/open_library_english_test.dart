import 'dart:convert';

import 'package:bookbite/features/discover/data/open_library_catalog_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _CapturingClient implements CatalogHttpClient {
  Uri? uri;

  @override
  Future<CatalogHttpResponse> get(
    Uri uri, {
    required Map<String, String> headers,
  }) async {
    this.uri = uri;
    return CatalogHttpResponse(
      statusCode: 200,
      bytes: utf8.encode('{"docs":[],"numFound":0}'),
    );
  }
}

void main() {
  test(
    'Open Library search requests English results regardless of UI locale',
    () async {
      final client = _CapturingClient();
      final repository = OpenLibraryCatalogRepository(
        client: client,
        contact: 'test@example.com',
      );

      await repository.search(
        query: 'Don Quixote',
        isIsbn: false,
        language: 'fa',
        offset: 0,
      );

      expect(client.uri?.queryParameters['lang'], 'en');
      expect(client.uri?.queryParameters['q'], contains('language:eng'));
    },
  );
}
