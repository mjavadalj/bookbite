import 'package:bookbite/core/domain/clock.dart';
import 'package:bookbite/core/domain/id_generator.dart';
import 'package:uuid/uuid.dart';

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

class UuidGenerator implements IdGenerator {
  const UuidGenerator();

  @override
  String newId() => const Uuid().v4();
}
