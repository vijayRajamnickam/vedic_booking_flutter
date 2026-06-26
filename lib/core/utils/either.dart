class Either<L, R> {
  L? _left;
  R? _right;
  bool _isLeft = false;

  void setLeft(L value) {
    _left = value;
    _isLeft = true;
  }

  void setRight(R value) {
    _right = value;
    _isLeft = false;
  }

  bool isLeft() => _isLeft;
  bool isRight() => !_isLeft;

  L getLeft() => _left as L;
  R getRight() => _right as R;

  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    if (_isLeft) return onLeft(_left as L);
    return onRight(_right as R);
  }
}

class Failure {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  factory Failure.generic([String message = 'Something went wrong']) =>
      Failure(message: message);

  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode)';
}
