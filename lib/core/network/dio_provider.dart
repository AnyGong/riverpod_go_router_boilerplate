import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((_) {
  return Dio(BaseOptions(baseUrl: 'https://api.example.com'));
});
