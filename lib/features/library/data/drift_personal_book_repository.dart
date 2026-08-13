import 'dart:convert';

import 'package:bookbite/core/data/database/app_database.dart' as database;
import 'package:bookbite/features/library/domain/personal_book.dart' as domain;
import 'package:bookbite/features/library/domain/personal_book_repository.dart';
import 'package:drift/drift.dart';

class DriftPersonalBookRepository implements PersonalBookRepository {
  DriftPersonalBookRepository(this._database);

  final database.AppDatabase _database;

  @override
  Future<domain.PersonalBook> importCatalogBook(domain.NewPersonalBook book) =>
      _database.transaction(() async {
        final existing = await findByCatalogIdentity(
          provider: book.provenance.provider,
          bookId: book.provenance.bookId,
        );
        if (existing != null) return existing;

        final timestamp = book.createdAt.toUtc().millisecondsSinceEpoch;
        await _database
            .into(_database.personalBookEntries)
            .insert(
              database.PersonalBookEntriesCompanion.insert(
                id: book.id,
                title: book.title,
                authorsJson: jsonEncode(book.authors),
                snapshotJson: jsonEncode(_snapshotToJson(book.snapshot)),
                catalogProvider: Value(book.provenance.provider),
                catalogBookId: Value(book.provenance.bookId),
                catalogWorkId: Value(book.provenance.workId),
                createdAt: timestamp,
                updatedAt: timestamp,
              ),
            );
        final inserted = await findById(book.id);
        if (inserted == null) {
          throw StateError('Imported PersonalBook could not be read back.');
        }
        return inserted;
      });

  @override
  Future<domain.PersonalBook?> findById(String id) async {
    final row = await (_database.select(
      _database.personalBookEntries,
    )..where((entry) => entry.id.equals(id))).getSingleOrNull();
    return row == null ? null : _bookFromRow(row);
  }

  @override
  Future<domain.PersonalBook?> findByCatalogIdentity({
    required String provider,
    required String bookId,
  }) async {
    final row =
        await (_database.select(_database.personalBookEntries)..where(
              (entry) =>
                  entry.catalogProvider.equals(provider) &
                  entry.catalogBookId.equals(bookId),
            ))
            .getSingleOrNull();
    return row == null ? null : _bookFromRow(row);
  }

  @override
  Stream<List<domain.PersonalBookSummary>> watchActiveBooks() {
    final query = _database.select(_database.personalBookEntries)
      ..where((entry) => entry.archivedAt.isNull())
      ..orderBy([(entry) => OrderingTerm.desc(entry.createdAt)]);
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => domain.PersonalBookSummary(
              id: row.id,
              title: row.title,
              author: _strings(row.authorsJson).firstOrNull,
              createdAt: _date(row.createdAt),
            ),
          )
          .toList(growable: false),
    );
  }

  domain.PersonalBook _bookFromRow(database.PersonalBookEntry row) {
    final snapshot = _snapshotFromJson(row.snapshotJson);
    return domain.PersonalBook(
      id: row.id,
      title: row.title,
      authors: _strings(row.authorsJson),
      createdAt: _date(row.createdAt),
      updatedAt: _date(row.updatedAt),
      archivedAt: row.archivedAt == null ? null : _date(row.archivedAt!),
      provenance: row.catalogProvider == null || row.catalogBookId == null
          ? null
          : domain.CatalogProvenance(
              provider: row.catalogProvider!,
              bookId: row.catalogBookId!,
              workId: row.catalogWorkId,
            ),
      snapshot: snapshot,
    );
  }

  Map<String, Object?> _snapshotToJson(
    domain.CatalogMetadataSnapshot snapshot,
  ) => {
    'version': 1,
    'title': snapshot.title,
    'authors': snapshot.authors,
    'coverUrl': snapshot.coverUrl?.toString(),
    'description': snapshot.description,
    'subjects': snapshot.subjects,
    'publicationDate': snapshot.publicationDate,
    'firstPublishedYear': snapshot.firstPublishedYear,
    'edition': snapshot.edition,
    'language': snapshot.language,
    'originalLanguage': snapshot.originalLanguage,
    'pageCount': snapshot.pageCount,
    'isbn10': snapshot.isbn10,
    'isbn13': snapshot.isbn13,
  };

  domain.CatalogMetadataSnapshot _snapshotFromJson(String source) {
    final value = jsonDecode(source);
    if (value is! Map<String, dynamic> || value['title'] is! String) {
      throw const FormatException('Invalid PersonalBook metadata snapshot.');
    }
    return domain.CatalogMetadataSnapshot(
      title: value['title'] as String,
      authors: _stringList(value['authors']),
      coverUrl: _uri(value['coverUrl']),
      description: _string(value['description']),
      subjects: _stringList(value['subjects']),
      publicationDate: _string(value['publicationDate']),
      firstPublishedYear: _integer(value['firstPublishedYear']),
      edition: _string(value['edition']),
      language: _string(value['language']),
      originalLanguage: _string(value['originalLanguage']),
      pageCount: _integer(value['pageCount']),
      isbn10: _stringList(value['isbn10']),
      isbn13: _stringList(value['isbn13']),
    );
  }

  List<String> _strings(String source) => _stringList(jsonDecode(source));

  List<String> _stringList(Object? value) =>
      value is List ? value.whereType<String>().toList() : const [];

  String? _string(Object? value) => value is String ? value : null;

  int? _integer(Object? value) => value is int ? value : null;

  Uri? _uri(Object? value) => value is String ? Uri.tryParse(value) : null;

  DateTime _date(int milliseconds) =>
      DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
}
