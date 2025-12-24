abstract class Failures {
  final String message;
  const Failures({required this.message});
}

class LocalDatabaseFailure extends Failures {
  LocalDatabaseFailure({required super.message});
}

class ApiFailure extends Failures {
  ApiFailure({required super.message});
}
