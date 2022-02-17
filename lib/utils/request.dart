import 'package:dio/dio.dart';

BaseOptions options= BaseOptions(
    baseUrl: 'https://vip.meimiaoip.com',
    connectTimeout: 5000,
    receiveTimeout: 3000
);

var dio = Dio(options);
