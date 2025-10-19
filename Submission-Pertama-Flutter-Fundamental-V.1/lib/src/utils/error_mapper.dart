String friendlyErrorMessage(Object error) {
  try {
    if (error is Exception) {
      final msg = error.toString();
      if (msg.contains('ApiException')) {
        // Example: ApiException(500): Failed to load
        final parts = msg.split(':');
        if (parts.length >= 2) {
          final codePart = parts[0].replaceAll(RegExp(r'[^0-9]'), '');
          final code = int.tryParse(codePart) ?? 0;
          switch (code) {
            case 400:
              return 'Bad request. Please try again.';
            case 401:
            case 403:
              return 'Permission denied. Please check your access.';
            case 404:
              return 'Data not found.';
            case 408:
            case 504:
              return 'Request timed out. Please try again.';
            case 500:
            default:
              return 'Unable to load data. Please try again later.';
          }
        }
      }
      // Fallback for other exceptions
      return 'An error occurred. Please try again.';
    }
  } catch (_) {}
  return 'An unexpected error occurred.';
}
