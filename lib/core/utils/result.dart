/// A minimal, dependency-free `Result` type.
///
/// Domain/data layers return `Result<S, F>` instead of throwing so the
/// presentation layer can branch on success/failure explicitly (see
/// `master_plan/02_architecture.md`).
sealed class Result<S, F> {
  const Result();

  bool get isSuccess => this is Success<S, F>;
  bool get isFailure => this is Failure<S, F>;

  /// Fold both branches into a single value.
  T when<T>({
    required T Function(S value) success,
    required T Function(F error) failure,
  }) {
    final self = this;
    return switch (self) {
      Success<S, F>(:final value) => success(value),
      Failure<S, F>(:final error) => failure(error),
    };
  }
}

/// Successful result carrying a [value].
final class Success<S, F> extends Result<S, F> {
  const Success(this.value);
  final S value;
}

/// Failed result carrying an [error].
final class Failure<S, F> extends Result<S, F> {
  const Failure(this.error);
  final F error;
}
