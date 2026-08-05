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
