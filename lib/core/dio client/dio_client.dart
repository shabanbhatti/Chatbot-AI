import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  late Dio countriesDio;
  late Dio chatApi;
  DioClient() {
    final apiKey = dotenv.env['API_KEY'];
    countriesDio = Dio(
      BaseOptions(
        baseUrl: 'https://restcountries.com/v3.1',
        connectTimeout: const Duration(seconds: 3),
        receiveTimeout: const Duration(seconds: 3),
        sendTimeout: const Duration(seconds: 3),
        contentType: 'application/json',
      ),
    );

    chatApi = Dio(
      BaseOptions(
        baseUrl: 'https://generativelanguage.googleapis.com',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 3),
        contentType: 'application/json',
        headers: {'x-goog-api-key': apiKey},
      ),
    );
  }
}
