import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

class BookBiteLocalizations {
  const BookBiteLocalizations(this.locale);

  final Locale locale;
  static const supportedLocales = [Locale('en'), Locale('fa')];
  static const delegate = _BookBiteLocalizationsDelegate();

  static BookBiteLocalizations of(BuildContext context) =>
      Localizations.of<BookBiteLocalizations>(context, BookBiteLocalizations)!;

  bool get isPersian => locale.languageCode == 'fa';
  String _t(String english, String persian) => isPersian ? persian : english;

  String get readingSession => _t('Reading Session', 'نشست مطالعه');
  String get sessionNavigation => _t('Reading Session', 'نشست مطالعه');
  String get library => _t('Library', 'کتابخانه');
  String get discover => _t('Discover', 'کاوش');
  String get journey => _t('Journey', 'مسیر');
  String get settings => _t('Settings', 'تنظیمات');
  String get preparingBookBite =>
      _t('Preparing BookBite', 'در حال آماده‌سازی بوک‌بایت');
  String get launchTagline => _t(
    'Your space. Your books. Your journey.',
    'فضای شما. کتاب‌های شما. مسیر شما.',
  );
  String get launchFailed => _t(
    'BookBite could not finish preparing. Your saved data was not changed.',
    'آماده‌سازی بوک‌بایت کامل نشد. داده‌های ذخیره‌شده شما تغییر نکرد.',
  );
  String get skip => _t('Skip', 'رد کردن');
  String get next => _t('Next', 'بعدی');
  String get getStarted => _t('Get started', 'شروع کنیم');
  String get onboardingLibraryTitle =>
      _t('Your reading life, together', 'زندگی مطالعه شما، یک‌جا');
  String get onboardingLibraryBody => _t(
    'Build a calm personal library and keep every reading session connected to the books that matter.',
    'یک کتابخانه شخصی آرام بسازید و هر نشست مطالعه را به کتاب‌های مهم خود پیوند دهید.',
  );
  String get onboardingCaptureTitle =>
      _t('Capture without losing your place', 'بدون گم‌کردن جای مطالعه ثبت کنید');
  String get onboardingCaptureBody => _t(
    'Photograph a page or record a five-second thought. BookBite extracts editable text while you keep reading.',
    'از یک صفحه عکس بگیرید یا یک فکر پنج‌ثانیه‌ای ضبط کنید. بوک‌بایت متن قابل ویرایش را هنگام ادامه مطالعه استخراج می‌کند.',
  );
  String get onboardingPrivateTitle =>
      _t('Private and available offline', 'خصوصی و در دسترس آفلاین');
  String get onboardingPrivateBody => _t(
    'Your books, sessions, photos, recordings, and edits stay on this device and remain yours.',
    'کتاب‌ها، نشست‌ها، عکس‌ها، صداها و ویرایش‌های شما روی همین دستگاه می‌مانند و متعلق به شما هستند.',
  );
  String get onboardingSaveFailed => _t(
    'Onboarding could not be saved. Please try again.',
    'ذخیره راه‌اندازی اولیه انجام نشد. دوباره تلاش کنید.',
  );
  String onboardingPagePosition(int current, int total) => _t(
    'Onboarding page $current of $total',
    'صفحه راه‌اندازی $current از $total',
  );
  String get welcomeBack => _t('Welcome back,', 'خوش آمدید،');
  String get reader => _t('Reader', 'خواننده');
  String get libraryJourneyStory => _t(
    'Your library. Your journey. Your story.',
    'کتابخانه شما. مسیر شما. داستان شما.',
  );
  String get todaysProgress => _t("Today's progress", 'پیشرفت امروز');
  String get readingTime => _t('reading time', 'زمان مطالعه');
  String get books => _t('Books', 'کتاب‌ها');
  String get dayStreak => _t('Day streak', 'روز پیوسته');
  String get levelShort => _t('Lv.', 'سطح');
  String get readerLevel => _t('Reader level', 'سطح خواننده');
  String get myBookshelf => _t('My bookshelf', 'قفسه کتاب من');
  String get totalReading => _t('Total reading', 'کل مطالعه');
  String get sessions => _t('Sessions', 'نشست‌ها');
  String get readingActivity => _t('Reading activity', 'فعالیت مطالعه');
  String get lastSixteenWeeks =>
      _t('The last 16 weeks of focused reading', '۱۶ هفته اخیر مطالعه متمرکز');
  String get readingProgression => _t('Reading progression', 'پیشرفت مطالعه');
  String get readingJourneyHelp => _t(
    'Built from your saved reading time',
    'ساخته‌شده از زمان مطالعه ذخیره‌شده شما',
  );
  String get today => _t('Today', 'امروز');
  String get less => _t('Less', 'کمتر');
  String get more => _t('More', 'بیشتر');
  String get mondayShort => _t('M', 'د');
  String get wednesdayShort => _t('W', 'چ');
  String get fridayShort => _t('F', 'ج');
  String dailyGoalPercent(int percent) => _t(
    '$percent percent of the daily reading goal',
    '$percent درصد از هدف روزانه مطالعه',
  );
  String readerLevelValue(int level) =>
      _t('Level $level reader', 'خواننده سطح $level');
  String levelShortValue(int level) => _t('Lv. $level', 'سطح $level');
  String levelProgressPercent(int percent) =>
      _t('$percent percent toward the next level', '$percent درصد تا سطح بعدی');
  String minutesToNextLevel(int minutes) => _t(
    '$minutes reading minutes to the next level',
    '$minutes دقیقه مطالعه تا سطح بعدی',
  );
  String activityOnDate(int minutes, String date) =>
      _t('$minutes reading minutes on $date', '$minutes دقیقه مطالعه در $date');
  String todayReadingMinutes(int minutes) => _t(
    '$minutes reading minutes saved today',
    '$minutes دقیقه مطالعه امروز ذخیره شده است',
  );
  String get welcome => _t('Ready to read?', 'برای خواندن آماده‌اید؟');
  String get idleDescription => _t(
    'Start calmly, or capture a moment from your book.',
    'با آرامش شروع کنید یا لحظه‌ای از کتابتان را ثبت کنید.',
  );
  String get startSession => _t('Start session', 'شروع نشست');
  String get photo => _t('Photo', 'عکس');
  String get voice => _t('Voice', 'صدا');
  String get startWithoutBook => _t('Start without a book', 'شروع بدون کتاب');
  String get chooseBook => _t(
    'Choose a book from your library to begin.',
    'برای شروع، کتابی از کتابخانه انتخاب کنید.',
  );
  String get searchLibrary => _t('Search your library', 'جست‌وجوی کتابخانه');
  String get yourLibrary => _t('Your library', 'کتابخانه شما');
  String get confirmBook =>
      _t('Start with this book?', 'با این کتاب شروع شود؟');
  String get beginReading => _t('Begin reading', 'شروع خواندن');
  String get inProgress => _t('In progress', 'در حال مطالعه');
  String get bitesCaptured => _t('Bites captured', 'یادداشت‌های ثبت‌شده');
  String get endSession => _t('End session', 'پایان نشست');
  String get endSessionQuestion =>
      _t('End this session?', 'این نشست پایان یابد؟');
  String get endSessionHelp => _t(
    'Your Bites and elapsed time will remain saved.',
    'یادداشت‌ها و زمان سپری‌شده ذخیره می‌مانند.',
  );
  String get capturePage => _t('Capture a page', 'ثبت صفحه');
  String get reviewPhoto => _t('Review photo', 'بازبینی عکس');
  String get switchCamera =>
      _t('Switch camera (coming later)', 'تعویض دوربین (بعداً)');
  String get gallery => _t('Gallery (coming later)', 'گالری (بعداً)');
  String get initializingCamera =>
      _t('Preparing the camera…', 'آماده‌سازی دوربین…');
  String get cameraUnavailable => _t(
    'Camera is unavailable on this device.',
    'دوربین در این دستگاه در دسترس نیست.',
  );
  String get alignPage => _t(
    'Align one printed page in the frame',
    'یک صفحه چاپی را در کادر قرار دهید',
  );
  String get takePhoto => _t('Take photo', 'گرفتن عکس');
  String get retake => _t('Retake', 'گرفتن دوباره');
  String get usePhoto => _t('Use photo', 'استفاده از عکس');
  String get ocrQueued => _t('Text extraction queued', 'استخراج متن در صف است');
  String get ocrProcessing => _t('Extracting text', 'در حال استخراج متن');
  String get ocrReady => _t('Text ready', 'متن آماده است');
  String get ocrFailed =>
      _t('Text extraction failed', 'استخراج متن ناموفق بود');
  String get retryOcr =>
      _t('Retry text extraction', 'تلاش دوباره برای استخراج متن');
  String get noTextFound =>
      _t('No text was found in this source.', 'متنی در این منبع پیدا نشد.');
  String get editText => _t('Edit text', 'ویرایش متن');
  String get extractedText => _t('Extracted text', 'متن استخراج‌شده');
  String get saveChanges => _t('Save changes', 'ذخیره تغییرات');
  String get deleteSource => _t('Delete source', 'حذف منبع');
  String get sourceDeleted => _t(
    'Source deleted; editable text was kept.',
    'منبع حذف شد؛ متن قابل ویرایش نگه داشته شد.',
  );
  String get noBitesYet =>
      _t('No Bites captured yet.', 'هنوز یادداشتی ثبت نشده است.');
  String get noBookSelected => _t('No book selected', 'کتابی انتخاب نشده است');
  String get noLibraryBooks =>
      _t('No books in your library yet.', 'هنوز کتابی در کتابخانه ندارید.');
  String get voiceCapture => _t('Voice capture', 'ثبت صدا');
  String get recordingVoice =>
      _t('Recording your thought', 'در حال ضبط صدای شما');
  String get fiveSecondVoiceHelp => _t(
    'Recording stops automatically after five seconds.',
    'ضبط پس از پنج ثانیه خودکار متوقف می‌شود.',
  );
  String get voiceTimeRemaining =>
      _t('Recording time remaining', 'زمان باقی‌مانده ضبط');
  String get stopAndSave => _t('Stop and save', 'توقف و ذخیره');
  String get savingVoice => _t('Saving recording…', 'در حال ذخیره صدا…');
  String get microphoneUnavailable =>
      _t('Microphone unavailable', 'میکروفون در دسترس نیست');
  String get microphonePermissionHelp => _t(
    'Allow microphone access in system settings, then try again. Photo capture and saved data are unaffected.',
    'دسترسی میکروفون را در تنظیمات دستگاه فعال کنید. ثبت عکس و داده‌های ذخیره‌شده بدون تغییر می‌مانند.',
  );
  String get comingSoon => _t('Coming later', 'بعداً اضافه می‌شود');
  String get language => _t('Language', 'زبان');
  String get switchLanguage => isPersian ? 'English' : 'فارسی';
  String get searchCatalog =>
      _t('Search title, author, or ISBN', 'جست‌وجوی عنوان، نویسنده یا شابک');
  String get exploreThisWeek => _t('Explore this week', 'کاوش این هفته');
  String get browseCatalog => _t('Browse catalog', 'مرور فهرست');
  String get filter => _t('Filter', 'فیلتر');
  String get cancel => _t('Cancel', 'لغو');
  String get clear => _t('Clear', 'پاک کردن');
  String get catalogResults => _t('Catalog results', 'نتایج فهرست');
  String get authorUnavailable => _t('Author unavailable', 'نویسنده نامشخص');
  String get typeMoreToSearch => _t(
    'Type at least three characters to search.',
    'برای جست‌وجو دست‌کم سه نویسه وارد کنید.',
  );
  String get searchGuidance => _t(
    'Enter a title, author, or ISBN to find a book.',
    'برای یافتن کتاب، عنوان، نویسنده یا شابک را وارد کنید.',
  );
  String get manualCreateTitle => _t('Create a book', 'ساخت کتاب');
  String get manualCreateDescription => _t(
    'Create a book manually — works offline.',
    'کتاب را دستی بسازید؛ آفلاین هم کار می‌کند.',
  );
  String get bookTitle => _t('Book title', 'عنوان کتاب');
  String get bookTitleRequired =>
      _t('A title is required.', 'عنوان الزامی است.');
  String get createBook => _t('Create book', 'ساخت کتاب');
  String get noMatches => _t(
    'No matches found for “{query}”.',
    'نتیجه‌ای برای «{query}» پیدا نشد.',
  );
  String get savedCatalog =>
      _t('Saved catalog information', 'اطلاعات ذخیره‌شده فهرست');
  String get catalogUnavailable => _t(
    'The book catalog is temporarily unavailable.',
    'فهرست کتاب موقتاً در دسترس نیست.',
  );
  String get liveSearchNeedsConnection => _t(
    'Live catalog search needs a connection.',
    'جست‌وجوی زنده فهرست به اینترنت نیاز دارد.',
  );
  String get retry => _t('Retry', 'تلاش دوباره');
  String get loadMoreBooks => _t('Load 20 more books', 'بارگیری ۲۰ کتاب دیگر');
  String get endOfCatalog => _t(
    'You have reached the end of this catalog.',
    'به پایان این فهرست رسیدید.',
  );
  String get categoriesComingSoon => _t(
    'More categories are coming later.',
    'دسته‌بندی‌های بیشتر بعداً اضافه می‌شوند.',
  );
  String get filtersComingSoon =>
      _t('Filters are coming later.', 'فیلترها بعداً اضافه می‌شوند.');
  String get allCategory => _t('All', 'همه');
  String get philosophy => _t('Philosophy', 'فلسفه');
  String get fiction => _t('Fiction', 'داستانی');
  String get history => _t('History', 'تاریخ');
  String get biography => _t('Biography', 'زندگی‌نامه');
  String get selfHelp => _t('Self-help', 'خودیاری');
  String get browseEmpty => _t(
    'No books are available to browse right now.',
    'اکنون کتابی برای مرور در دسترس نیست.',
  );
  String get pendingSearch => _t(
    'Preparing search for “{query}”',
    'در حال آماده‌سازی جست‌وجوی «{query}»',
  );
  String get previousResults => _t('Results for “{query}”', 'نتایج «{query}»');
  String get searchTooLong =>
      _t('Search text is too long.', 'متن جست‌وجو بیش از حد طولانی است.');
  String get catalogBookOverviewComingSoon =>
      _t('Catalog book overview', 'نمای کلی کتاب فهرست');
  String get back => _t('Back', 'بازگشت');
  String get aboutThisBook => _t('About this book', 'درباره این کتاب');
  String get details => _t('Details', 'جزئیات');
  String get relatedCatalogBooks =>
      _t('Related catalog books', 'کتاب‌های مرتبط در فهرست');
  String get addToLibrary => _t('Add to your library', 'افزودن به کتابخانه');
  String get addComingLater => _t(
    'Adding books will be available later.',
    'افزودن کتاب بعداً در دسترس خواهد بود.',
  );
  String get offlineCatalogCopy =>
      _t('Saved catalog copy · Offline', 'نسخه ذخیره‌شده فهرست · آفلاین');
  String get refreshingCatalog =>
      _t('Refreshing catalog information', 'در حال به‌روزرسانی اطلاعات فهرست');
  String get metadataSavedHelper => _t(
    'After adding, book information is saved locally for offline access.',
    'پس از افزودن، اطلاعات کتاب برای دسترسی آفلاین روی دستگاه ذخیره می‌شود.',
  );
  String get noDescription => _t(
    'No description was provided by the catalog.',
    'فهرست توضیحی ارائه نکرده است.',
  );
  String get unavailableDetail => _t(
    'This book detail is temporarily unavailable.',
    'جزئیات این کتاب موقتاً در دسترس نیست.',
  );
  String get connectionNeeded => _t(
    'A connection is needed to load this book detail.',
    'برای بارگیری جزئیات کتاب به اینترنت نیاز است.',
  );
  String get publicationDate => _t('Publication date', 'تاریخ انتشار');
  String get firstPublished => _t('First published', 'اولین انتشار');
  String get edition => _t('Edition', 'ویرایش');
  String get languageLabel => _t('Edition language', 'زبان ویرایش');
  String get originalLanguage => _t('Original language', 'زبان اصلی');
  String get pageCount => _t('Pages', 'تعداد صفحات');
  String get isbn13 => 'ISBN-13';
  String get isbn10 => 'ISBN-10';
  String get authorLabel => _t('Author', 'نویسنده');
  String get compactAdd => _t('Add', 'افزودن');
  String get savedState => _t('Saved', 'ذخیره شد');
  String get savingToLibrary =>
      _t('Adding to your library…', 'در حال افزودن به کتابخانه…');
  String get savingShort => _t('Saving…', 'در حال ذخیره…');
  String get tryAddAgain => _t('Try again', 'تلاش دوباره');
  String get savedOfflineHelper => _t(
    'Saved on this device and available offline.',
    'روی این دستگاه ذخیره شد و آفلاین در دسترس است.',
  );
  String get addToLibraryFailed => _t(
    'The book was not added; try again.',
    'کتاب افزوده نشد؛ دوباره تلاش کنید.',
  );
  String get addBook => _t('Add book', 'افزودن کتاب');
  String get emptyLibrary => _t(
    'Your library is ready for its first book.',
    'کتابخانه شما آماده نخستین کتاب است.',
  );
  String get libraryReadFailed => _t(
    'Your books could not be read. Nothing was deleted.',
    'کتاب‌ها خوانده نشدند؛ هیچ داده‌ای حذف نشده است.',
  );
  String get bookUnavailable =>
      _t('This personal book is unavailable.', 'این کتاب شخصی در دسترس نیست.');
  String get readingSessions => _t('Reading sessions', 'نشست‌های مطالعه');
  String get noReadingSessions => _t(
    'No reading sessions for this book yet.',
    'هنوز نشستی برای این کتاب ثبت نشده است.',
  );
  String get attachedBites => _t('Attached Bites', 'یادداشت‌های پیوست‌شده');
  String get noAttachedBites => _t(
    'No text, photos, or voices are attached yet.',
    'هنوز متن، عکس یا صدایی پیوست نشده است.',
  );
  String get photoBite => _t('Photo Bite', 'یادداشت تصویری');
  String get voiceBite => _t('Voice Bite', 'یادداشت صوتی');
}

class _BookBiteLocalizationsDelegate
    extends LocalizationsDelegate<BookBiteLocalizations> {
  const _BookBiteLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => BookBiteLocalizations.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<BookBiteLocalizations> load(Locale locale) =>
      SynchronousFuture(BookBiteLocalizations(locale));

  @override
  bool shouldReload(_BookBiteLocalizationsDelegate old) => false;
}
