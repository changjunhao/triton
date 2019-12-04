import 'package:dio/dio.dart';

BaseOptions options= new BaseOptions(
    baseUrl: 'https://vip.meimiaoip.com',
    connectTimeout: 5000,
    receiveTimeout: 3000
);

var dio = new Dio(options);
