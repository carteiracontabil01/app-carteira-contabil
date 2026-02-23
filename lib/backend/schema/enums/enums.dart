import 'package:collection/collection.dart';

enum JobsStatus {
  agendado,
  cancelado,
  confirmado,
  concluido,
}

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) =>
      firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (JobsStatus):
      return JobsStatus.values.deserialize(value) as T?;
    default:
      return null;
  }
}
