import 'package:flutter/widgets.dart';

class BookBiteLocalizations {
  const BookBiteLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('fa')];
  static const delegate = _BookBiteLocalizationsDelegate();

  static BookBiteLocalizations of(BuildContext context) {
    return Localizations.of<BookBiteLocalizations>(
      context,
      BookBiteLocalizations,
    )!;
  }

  bool get isPersian => locale.languageCode == 'fa';
  String get readingSession =>
      isPersian ? 'Ù†Ø´Ø³Øª Ù…Ø·Ø§Ù„Ø¹Ù‡' : 'Reading Session';
  String get sessionNavigation => isPersian ? 'Ù†Ø´Ø³Øª' : 'Session';
  String get library => isPersian ? 'Ú©ØªØ§Ø¨Ø®Ø§Ù†Ù‡' : 'Library';
  String get discover => isPersian ? 'Ú©Ø§ÙˆØ´' : 'Discover';
  String get journey => isPersian ? 'Ù…Ø³ÛŒØ±' : 'Journey';
  String get settings => isPersian ? 'ØªÙ†Ø¸ÛŒÙ…Ø§Øª' : 'Settings';
  String get welcome => isPersian
      ? 'Ø¨Ø±Ø§ÛŒ Ø®ÙˆØ§Ù†Ø¯Ù† Ø¢Ù…Ø§Ø¯Ù‡â€ŒØ§ÛŒØ¯ØŸ'
      : 'Ready to read?';
  String get idleDescription => isPersian
      ? 'Ø¨Ø§ Ø¢Ø±Ø§Ù…Ø´ Ø´Ø±ÙˆØ¹ Ú©Ù†ÛŒØ¯ØŒ ÛŒØ§ ÛŒÚ© Ù„Ø­Ø¸Ù‡ Ø§Ø² Ú©ØªØ§Ø¨ØªØ§Ù† Ø±Ø§ Ø«Ø¨Øª Ú©Ù†ÛŒØ¯.'
      : 'Start calmly, or capture a moment from your book.';
  String get startSession => isPersian ? 'Ø´Ø±ÙˆØ¹ Ù†Ø´Ø³Øª' : 'Start session';
  String get photo => isPersian ? 'Ø¹Ú©Ø³' : 'Photo';
  String get voice => isPersian ? 'ØµØ¯Ø§' : 'Voice';
  String get comingSoon => isPersian ? 'Ø¨Ù‡â€ŒØ²ÙˆØ¯ÛŒ' : 'Coming later';
  String get language => isPersian ? 'Ø²Ø¨Ø§Ù†' : 'Language';
  String get switchLanguage => isPersian ? 'English' : 'ÙØ§Ø±Ø³ÛŒ';
  String get searchCatalog => isPersian
      ? 'Ø¬Ø³Øªâ€ŒÙˆØ¬ÙˆÛŒ Ø¹Ù†ÙˆØ§Ù†ØŒ Ù†ÙˆÛŒØ³Ù†Ø¯Ù‡ ÛŒØ§ Ø´Ø§Ø¨Ú©'
      : 'Search title, author, or ISBN';
  String get exploreThisWeek =>
      isPersian ? 'Ú©Ø§ÙˆØ´ Ø§ÛŒÙ† Ù‡ÙØªÙ‡' : 'Explore this week';
  String get browseCatalog =>
      isPersian ? 'Ù…Ø±ÙˆØ± ÙÙ‡Ø±Ø³Øª' : 'Browse catalog';
  String get filter => isPersian ? 'ÙÛŒÙ„ØªØ±' : 'Filter';
  String get cancel => isPersian ? 'Ù„ØºÙˆ' : 'Cancel';
  String get clear => isPersian ? 'Ù¾Ø§Ú© Ú©Ø±Ø¯Ù†' : 'Clear';
  String get catalogResults =>
      isPersian ? 'Ù†ØªØ§ÛŒØ¬ ÙÙ‡Ø±Ø³Øª' : 'Catalog results';
  String get authorUnavailable =>
      isPersian ? 'Ù†ÙˆÛŒØ³Ù†Ø¯Ù‡ Ù†Ø§Ù…Ø´Ø®Øµ' : 'Author unavailable';
  String get typeMoreToSearch => isPersian
      ? 'Ø¨Ø±Ø§ÛŒ Ø¬Ø³Øªâ€ŒÙˆØ¬Ùˆ Ø¯Ø³Øªâ€ŒÚ©Ù… Ø³Ù‡ Ù†ÙˆÛŒØ³Ù‡ Ø¨Ù†ÙˆÛŒØ³ÛŒØ¯.'
      : 'Type at least three characters to search.';
  String get searchGuidance => isPersian
      ? 'Ø¨Ø±Ø§ÛŒ ÛŒØ§ÙØªÙ† Ú©ØªØ§Ø¨ØŒ Ø¹Ù†ÙˆØ§Ù†ØŒ Ù†ÙˆÛŒØ³Ù†Ø¯Ù‡ ÛŒØ§ Ø´Ø§Ø¨Ú© Ø±Ø§ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯.'
      : 'Enter a title, author, or ISBN to find a book.';
  String get manualCreateTitle =>
      isPersian ? 'Ú©ØªØ§Ø¨ØªØ§Ù† Ø§ÛŒÙ†Ø¬Ø§ Ù†ÛŒØ³ØªØŸ' : 'Not here?';
  String get manualCreateDescription => isPersian
      ? 'Ú©ØªØ§Ø¨ÛŒ Ø±Ø§ Ø¯Ø³ØªÛŒ Ø§Ø¶Ø§ÙÙ‡ Ú©Ù†ÛŒØ¯ â€” Ø¢ÙÙ„Ø§ÛŒÙ† Ù‡Ù… Ú©Ø§Ø± Ù…ÛŒâ€ŒÚ©Ù†Ø¯'
      : 'Create a book manually â€” works offline';
  String get noMatches => isPersian
      ? 'Ù†ØªÛŒØ¬Ù‡â€ŒØ§ÛŒ Ø¨Ø±Ø§ÛŒ Â«{query}Â» Ù¾ÛŒØ¯Ø§ Ù†Ø´Ø¯.'
      : 'No matches found for â€œ{query}â€.';
  String get savedCatalog => isPersian
      ? 'Ø§Ø·Ù„Ø§Ø¹Ø§Øª Ø°Ø®ÛŒØ±Ù‡â€ŒØ´Ø¯Ù‡Ù” ÙÙ‡Ø±Ø³Øª'
      : 'Saved catalog information';
  String get catalogUnavailable => isPersian
      ? 'ÙÙ‡Ø±Ø³Øª Ú©ØªØ§Ø¨ Ù…ÙˆÙ‚ØªØ§Ù‹ Ø¯Ø± Ø¯Ø³ØªØ±Ø³ Ù†ÛŒØ³Øª.'
      : 'The book catalog is temporarily unavailable.';
  String get liveSearchNeedsConnection => isPersian
      ? 'Ø¬Ø³Øªâ€ŒÙˆØ¬ÙˆÛŒ Ø²Ù†Ø¯Ù‡ Ø¨Ù‡ Ø§ØªØµØ§Ù„ Ø§ÛŒÙ†ØªØ±Ù†Øª Ù†ÛŒØ§Ø² Ø¯Ø§Ø±Ø¯.'
      : 'Live catalog search needs a connection.';
  String get retry => isPersian ? 'ØªÙ„Ø§Ø´ Ø¯ÙˆØ¨Ø§Ø±Ù‡' : 'Retry';
  String get loadMoreBooks => isPersian
      ? 'Ø¨Ø§Ø±Ú¯ÛŒØ±ÛŒ Û²Û° Ú©ØªØ§Ø¨ Ø¯ÛŒÚ¯Ø±'
      : 'Load 20 more books';
  String get endOfCatalog => isPersian
      ? 'Ù¾Ø§ÛŒØ§Ù† Ø§ÛŒÙ† ÙÙ‡Ø±Ø³Øª'
      : 'You have reached the end of this catalog.';
  String get categoriesComingSoon => isPersian
      ? 'Ø¯Ø³ØªÙ‡â€ŒØ¨Ù†Ø¯ÛŒâ€ŒÙ‡Ø§ÛŒ Ø¨ÛŒØ´ØªØ± Ø¨Ù‡â€ŒØ²ÙˆØ¯ÛŒ Ù…ÛŒâ€ŒØ¢ÛŒÙ†Ø¯.'
      : 'More categories are coming later.';
  String get filtersComingSoon => isPersian
      ? 'ÙÛŒÙ„ØªØ±Ù‡Ø§ Ø¨Ù‡â€ŒØ²ÙˆØ¯ÛŒ Ù…ÛŒâ€ŒØ¢ÛŒÙ†Ø¯.'
      : 'Filters are coming later.';
  String get allCategory => isPersian ? 'Ù‡Ù…Ù‡' : 'All';
  String get philosophy => isPersian ? 'ÙÙ„Ø³ÙÙ‡' : 'Philosophy';
  String get fiction => isPersian ? 'Ø¯Ø§Ø³ØªØ§Ù†ÛŒ' : 'Fiction';
  String get history => isPersian ? 'ØªØ§Ø±ÛŒØ®' : 'History';
  String get biography => isPersian ? 'Ø²Ù†Ø¯Ú¯ÛŒâ€ŒÙ†Ø§Ù…Ù‡' : 'Biography';
  String get selfHelp => isPersian ? 'Ø®ÙˆØ¯ÛŒØ§Ø±ÛŒ' : 'Self-help';
  String get browseEmpty => isPersian
      ? 'Ø§Ú©Ù†ÙˆÙ† Ú©ØªØ§Ø¨ÛŒ Ø¨Ø±Ø§ÛŒ Ù…Ø±ÙˆØ± Ø¯Ø± Ø¯Ø³ØªØ±Ø³ Ù†ÛŒØ³Øª.'
      : 'No books are available to browse right now.';
  String get pendingSearch => isPersian
      ? 'Ø¯Ø± Ø­Ø§Ù„ Ø¢Ù…Ø§Ø¯Ù‡â€ŒØ³Ø§Ø²ÛŒ Ø¬Ø³Øªâ€ŒÙˆØ¬ÙˆÛŒ Â«{query}Â»'
      : 'Preparing search for â€œ{query}â€';
  String get previousResults =>
      isPersian ? 'Ù†ØªØ§ÛŒØ¬ Â«{query}Â»' : 'Results for â€œ{query}â€';
  String get searchTooLong => isPersian
      ? 'Ù…ØªÙ† Ø¬Ø³Øªâ€ŒÙˆØ¬Ùˆ Ø®ÛŒÙ„ÛŒ Ø·ÙˆÙ„Ø§Ù†ÛŒ Ø§Ø³Øª.'
      : 'Search text is too long.';
  String get catalogBookOverviewComingSoon => isPersian
      ? 'Ù†Ù…Ø§ÛŒ Ú©Ù„ÛŒ Ú©ØªØ§Ø¨ ÙÙ‡Ø±Ø³Øª Ø¯Ø± Ù…Ø±Ø­Ù„Ù‡Ù” Ø¨Ø¹Ø¯ÛŒ Ø§ÙØ²ÙˆØ¯Ù‡ Ù…ÛŒâ€ŒØ´ÙˆØ¯.'
      : 'CatalogBook overview is part of the next milestone.';
  String get back => isPersian ? 'بازگشت' : 'Back';
  String get aboutThisBook => isPersian ? 'درباره این کتاب' : 'About this book';
  String get details => isPersian ? 'جزئیات' : 'Details';
  String get relatedCatalogBooks =>
      isPersian ? 'کتاب‌های مرتبط در فهرست' : 'Related catalog books';
  String get addToLibrary =>
      isPersian ? 'افزودن به کتابخانه' : 'Add to your library';
  String get addComingLater => isPersian
      ? 'افزودن کتاب در مرحله بعد فعال می‌شود.'
      : 'Adding books will be available in the next milestone.';
  String get offlineCatalogCopy => isPersian
      ? 'نسخه ذخیره‌شده فهرست؛ آفلاین'
      : 'Saved catalog copy · Offline';
  String get refreshingCatalog => isPersian
      ? 'در حال به‌روزرسانی اطلاعات فهرست'
      : 'Refreshing catalog information';
  String get metadataSavedHelper => isPersian
      ? 'پس از افزودن، اطلاعات کتاب برای دسترسی آفلاین روی دستگاه ذخیره می‌شود.'
      : 'After adding, book information is saved locally for offline access.';
  String get noDescription => isPersian
      ? 'توضیحی از سوی فهرست ارائه نشده است.'
      : 'No description was provided by the catalog.';
  String get unavailableDetail => isPersian
      ? 'اطلاعات این کتاب فعلاً در دسترس نیست.'
      : 'This book detail is temporarily unavailable.';
  String get connectionNeeded => isPersian
      ? 'برای دریافت جزئیات کتاب به اتصال اینترنت نیاز است.'
      : 'A connection is needed to load this book detail.';
  String get publicationDate => isPersian ? 'تاریخ انتشار' : 'Publication date';
  String get firstPublished => isPersian ? 'اولین انتشار' : 'First published';
  String get edition => isPersian ? 'ویرایش' : 'Edition';
  String get languageLabel => isPersian ? 'زبان ویرایش' : 'Edition language';
  String get originalLanguage => isPersian ? 'زبان اصلی' : 'Original language';
  String get pageCount => isPersian ? 'تعداد صفحات' : 'Pages';
  String get isbn13 => 'ISBN-13';
  String get isbn10 => 'ISBN-10';
  String get authorLabel => isPersian ? 'نویسنده' : 'Author';
  String get compactAdd =>
      isPersian ? '\u0627\u0641\u0632\u0648\u062f\u0646' : 'Add';
  String get savedState => isPersian ? 'ذخیره شد' : 'Saved';
  String get savingToLibrary =>
      isPersian ? 'در حال افزودن به کتابخانه…' : 'Adding to your library…';
  String get savingShort => isPersian ? 'در حال ذخیره…' : 'Saving…';
  String get tryAddAgain => isPersian ? 'تلاش دوباره' : 'Try again';
  String get savedOfflineHelper => isPersian
      ? 'این کتاب روی دستگاه ذخیره شد و بدون اینترنت در دسترس است.'
      : 'Saved on this device and available without an internet connection.';
  String get addToLibraryFailed => isPersian
      ? 'کتاب افزوده نشد. اطلاعات فهرست تغییری نکرد؛ دوباره تلاش کنید.'
      : 'The book was not added. Its catalog details are unchanged; try again.';
}

class _BookBiteLocalizationsDelegate
    extends LocalizationsDelegate<BookBiteLocalizations> {
  const _BookBiteLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => BookBiteLocalizations.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<BookBiteLocalizations> load(Locale locale) async {
    return BookBiteLocalizations(locale);
  }

  @override
  bool shouldReload(_BookBiteLocalizationsDelegate old) => false;
}
