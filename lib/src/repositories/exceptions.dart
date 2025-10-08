class NoConnectionException implements Exception {
  final String message;
  NoConnectionException([this.message = 'No internet connection']);
  @override
  String toString() => message;
}

class FetchDataException implements Exception {
  final String message;
  FetchDataException([this.message = 'Failed to fetch data']);
  @override
  String toString() => message;
}
