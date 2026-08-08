import 'package:bookbite/features/discover/domain/search_query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalizes whitespace without changing visible input', () {
    final query = SearchQuery.parse('  The   Book  ');

    expect(query?.value, 'The Book');
    expect(query?.display, '  The   Book  ');
    expect(query?.isIsbn, isFalse);
  });

  test('recognizes ISBN values written with Persian digits', () {
    final query = SearchQuery.parse('۹۷۸-۰۳۰۷۴۷۴۲۷۸');

    expect(query?.isIsbn, isTrue);
  });

  test('does not send an empty or overlong query', () {
    expect(SearchQuery.parse('  '), isNull);
    expect(SearchQuery.parse('a' * 201), isNull);
  });
}
