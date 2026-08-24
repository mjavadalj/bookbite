import 'dart:convert';

import 'package:bookbite/features/discover/data/open_library_catalog_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _CapturingClient implements CatalogHttpClient {
  _CapturingClient({this.body = '{"docs":[],"numFound":0}'});

  final String body;
  Uri? uri;

  @override
  Future<CatalogHttpResponse> get(
    Uri uri, {
    required Map<String, String> headers,
  }) async {
    this.uri = uri;
    return CatalogHttpResponse(statusCode: 200, bytes: utf8.encode(body));
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

  test(
    'catalog results omit entries without both a cover and an author',
    () async {
      final client = _CapturingClient(
        body: jsonEncode({
          'numFound': 4,
          'docs': [
            {
              'key': '/works/OL1W',
              'title': 'Complete',
              'author_name': ['Author'],
              'cover_i': 101,
            },
            {
              'key': '/works/OL2W',
              'title': 'No cover',
              'author_name': ['Author'],
            },
            {'key': '/works/OL3W', 'title': 'No author', 'cover_i': 303},
            {
              'key': '/works/OL4W',
              'title': 'Empty author',
              'author_name': <String>[],
              'cover_i': 404,
            },
          ],
        }),
      );
      final repository = OpenLibraryCatalogRepository(
        client: client,
        contact: 'test@example.com',
      );

      final page = await repository.browse(language: 'en', offset: 0);

      expect(page.books.map((book) => book.title), ['Complete']);
      expect(page.books.single.coverUrl, isNotNull);
      expect(page.books.single.authors, ['Author']);
    },
  );
}
