class ServerException implements Exception {
  const ServerException({
    this.statusCode,
    this.message = "Unexpected Server Error",
  });

  final int? statusCode;
  final String message;
}

class NetworkException implements Exception {
  const NetworkException({this.message = "No Internet Connection"});

  final String message;
}

class CacheException implements Exception {
  const CacheException({this.message = 'Cache operation failed'});

  final String message;

  @override
  String toString() => 'CacheException: $message';
}
