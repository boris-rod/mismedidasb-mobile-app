class NoUserException implements Exception {
  @override
  String toString() {
    return "Exception: No Logged User";
  }
}

class ServerException implements Exception {
  String message;
  int code;

  ServerException.fromJson(this.code, Map<String, dynamic> json) {
    final error = json['error'];
    this.message =
        error is Map<String, dynamic> ? error['message'] : error.toString();
    this.code = code;
  }

  @override
  String toString() => message ?? 'Error $code';
}
