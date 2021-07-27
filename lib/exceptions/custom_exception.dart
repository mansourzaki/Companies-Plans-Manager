class CustomException implements Exception {
  String cause;
  CustomException(this.cause);
}

throwException() {
  throw CustomException('This is my first custom exception');
}
