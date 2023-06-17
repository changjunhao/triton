import 'package:dio/dio.dart';

BaseOptions options= BaseOptions(
  baseUrl: 'https://vip.meimiaoip.com',
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 3),
);

var dio = Dio(options);
