enum BiteSourceKind { pageImage, voiceRecording }

enum ExtractionStatus { captured, processing, ready, failed }

enum BiteTag {
  quote('Quotes'),
  thought('Thoughts'),
  idea('Ideas'),
  question('Questions'),
  lesson('Lessons');

  const BiteTag(this.label);
  final String label;
}

class ReadingSession {
  const ReadingSession({
    required this.id,
    required this.startedAt,
    this.endedAt,
    this.personalBookId,
    this.readingCycleId,
  });

  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? personalBookId;
  final String? readingCycleId;
}

class Bite {
  const Bite({
    required this.id,
    required this.sourceKind,
    required this.extractionStatus,
    required this.createdAt,
    required this.updatedAt,
    this.extractedText,
    this.readingSessionId,
    this.personalBookId,
    this.readingCycleId,
    this.mediaReference,
    this.tags = const {},
  });

  final String id;
  final BiteSourceKind sourceKind;
  final ExtractionStatus extractionStatus;
  final String? extractedText;
  final String? readingSessionId;
  final String? personalBookId;
  final String? readingCycleId;
  final String? mediaReference;
  final Set<BiteTag> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class ExtractionJob {
  const ExtractionJob({
    required this.id,
    required this.biteId,
    required this.kind,
    required this.mediaReference,
    required this.attempts,
  });

  final String id;
  final String biteId;
  final BiteSourceKind kind;
  final String mediaReference;
  final int attempts;
}
