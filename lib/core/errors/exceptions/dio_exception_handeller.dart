import 'package:dio/dio.dart';

abstract class DioExceptionHandeler {
  static String getMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout. Server slow or down.";
      case DioExceptionType.receiveTimeout:
        return "Response timeout. Internet slow.";
      case DioExceptionType.sendTimeout:
        return "Request timeout.";
      case DioExceptionType.badResponse:
        return _handleBadResponse(e);
      case DioExceptionType.connectionError:
        return "No internet connection.";
      default:
        return "Something went wrong. Try again.";
    }
  }

  static String _handleBadResponse(DioException e) {
    try {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      if (statusCode == 400) return data["message"] ?? "Bad request.";
      if (statusCode == 401) return "Unauthorized. Login required.";
      if (statusCode == 403) return "Access denied.";
      if (statusCode == 404) return "Not found.";
      if (statusCode == 500) return "Server error. Try later.";

      return "Unexpected server error.";
    } catch (_) {
      return "Unexpected error occurred.";
    }
  }
}
