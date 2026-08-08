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
  String get readingSession => isPersian ? 'نشست مطالعه' : 'Reading Session';
  String get sessionNavigation => isPersian ? 'نشست' : 'Session';
  String get library => isPersian ? 'کتابخانه' : 'Library';
  String get discover => isPersian ? 'کاوش' : 'Discover';
  String get journey => isPersian ? 'مسیر' : 'Journey';
  String get settings => isPersian ? 'تنظیمات' : 'Settings';
  String get welcome => isPersian ? 'برای خواندن آماده‌اید؟' : 'Ready to read?';
  String get idleDescription => isPersian
      ? 'با آرامش شروع کنید، یا یک لحظه از کتابتان را ثبت کنید.'
      : 'Start calmly, or capture a moment from your book.';
  String get startSession => isPersian ? 'شروع نشست' : 'Start session';
  String get photo => isPersian ? 'عکس' : 'Photo';
  String get voice => isPersian ? 'صدا' : 'Voice';
  String get comingSoon => isPersian ? 'به‌زودی' : 'Coming later';
  String get language => isPersian ? 'زبان' : 'Language';
  String get switchLanguage => isPersian ? 'English' : 'فارسی';
  String get searchCatalog => isPersian
      ? 'جست‌وجوی عنوان، نویسنده یا شابک'
      : 'Search title, author, or ISBN';
  String get exploreThisWeek =>
      isPersian ? 'کاوش این هفته' : 'Explore this week';
  String get browseCatalog => isPersian ? 'مرور فهرست' : 'Browse catalog';
  String get filter => isPersian ? 'فیلتر' : 'Filter';
  String get cancel => isPersian ? 'لغو' : 'Cancel';
  String get clear => isPersian ? 'پاک کردن' : 'Clear';
  String get catalogResults => isPersian ? 'نتایج فهرست' : 'Catalog results';
  String get authorUnavailable =>
      isPersian ? 'نویسنده نامشخص' : 'Author unavailable';
  String get typeMoreToSearch => isPersian
      ? 'برای جست‌وجو دست‌کم سه نویسه بنویسید.'
      : 'Type at least three characters to search.';
  String get searchGuidance => isPersian
      ? 'برای یافتن کتاب، عنوان، نویسنده یا شابک را وارد کنید.'
      : 'Enter a title, author, or ISBN to find a book.';
  String get manualCreateTitle =>
      isPersian ? 'کتابتان اینجا نیست؟' : 'Not here?';
  String get manualCreateDescription => isPersian
      ? 'کتابی را دستی اضافه کنید — آفلاین هم کار می‌کند'
      : 'Create a book manually — works offline';
  String get noMatches => isPersian
      ? 'نتیجه‌ای برای «{query}» پیدا نشد.'
      : 'No matches found for “{query}”.';
  String get savedCatalog =>
      isPersian ? 'اطلاعات ذخیره‌شدهٔ فهرست' : 'Saved catalog information';
  String get catalogUnavailable => isPersian
      ? 'فهرست کتاب موقتاً در دسترس نیست.'
      : 'The book catalog is temporarily unavailable.';
  String get liveSearchNeedsConnection => isPersian
      ? 'جست‌وجوی زنده به اتصال اینترنت نیاز دارد.'
      : 'Live catalog search needs a connection.';
  String get retry => isPersian ? 'تلاش دوباره' : 'Retry';
  String get loadMoreBooks =>
      isPersian ? 'بارگیری ۲۰ کتاب دیگر' : 'Load 20 more books';
  String get endOfCatalog => isPersian
      ? 'پایان این فهرست'
      : 'You have reached the end of this catalog.';
  String get categoriesComingSoon => isPersian
      ? 'دسته‌بندی‌های بیشتر به‌زودی می‌آیند.'
      : 'More categories are coming later.';
  String get filtersComingSoon =>
      isPersian ? 'فیلترها به‌زودی می‌آیند.' : 'Filters are coming later.';
  String get allCategory => isPersian ? 'همه' : 'All';
  String get philosophy => isPersian ? 'فلسفه' : 'Philosophy';
  String get fiction => isPersian ? 'داستانی' : 'Fiction';
  String get history => isPersian ? 'تاریخ' : 'History';
  String get biography => isPersian ? 'زندگی‌نامه' : 'Biography';
  String get selfHelp => isPersian ? 'خودیاری' : 'Self-help';
  String get browseEmpty => isPersian
      ? 'اکنون کتابی برای مرور در دسترس نیست.'
      : 'No books are available to browse right now.';
  String get pendingSearch => isPersian
      ? 'در حال آماده‌سازی جست‌وجوی «{query}»'
      : 'Preparing search for “{query}”';
  String get previousResults =>
      isPersian ? 'نتایج «{query}»' : 'Results for “{query}”';
  String get searchTooLong =>
      isPersian ? 'متن جست‌وجو خیلی طولانی است.' : 'Search text is too long.';
  String get catalogBookOverviewComingSoon => isPersian
      ? 'نمای کلی کتاب فهرست در مرحلهٔ بعدی افزوده می‌شود.'
      : 'CatalogBook overview is part of the next milestone.';
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
