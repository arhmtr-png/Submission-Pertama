// Simple sealed-like Result class to represent Loading/Success/Error states
abstract class Result<T> {
  const Result();
}

class Loading<T> extends Result<T> {
  const Loading();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class ErrorResult<T> extends Result<T> {
  final String message;
  const ErrorResult(this.message);
}
