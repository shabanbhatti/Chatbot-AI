import 'package:dio/dio.dart';

class DioClient {
  late Dio countriesDio;
  DioClient(){
    countriesDio= Dio(
        BaseOptions(
            baseUrl: 'https://restcountries.com/v3.1/name',
            connectTimeout:const Duration(seconds: 3),
            receiveTimeout:const Duration(seconds: 3),
            sendTimeout:const Duration(seconds: 3),
            contentType: 'application/json'
        )
    );
  }
}