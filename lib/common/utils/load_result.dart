/// Network veya parse hatalarında tek bir bölümü düşürmek için basit sonuç tipi.
sealed class LoadResult<T> {
  const LoadResult();
}

final class LoadSuccess<T> extends LoadResult<T> {
  const LoadSuccess(this.value) : super();
  final T value;
}

final class LoadFailure<T> extends LoadResult<T> {
  const LoadFailure([this.error]) : super();
  final Object? error;
}

extension LoadResultLists<T> on LoadResult<List<T>> {
  /// Başarısız isteklerde bölümü gizlemek için boş liste.
  List<T> get valueOrEmpty => switch (this) {
        LoadSuccess(:final value) => value,
        LoadFailure() => <T>[],
      };
}

/// Herhangi bir hata yakalanır; üst seviye try/catch gerekmez.
Future<LoadResult<List<T>>> safeLoadList<T>(
  Future<List<T>> Function() fn,
) async {
  try {
    return LoadSuccess(await fn());
  } catch (e) {
    return LoadFailure<List<T>>(e);
  }
}
