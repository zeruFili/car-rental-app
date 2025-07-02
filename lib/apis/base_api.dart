import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';

class BaseUrl {
  Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api/'));

  BaseUrl() {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.interceptors.add(LogInterceptor(responseBody: true, request: true));

    // Add an interceptor to set the Authorization header before each request
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          options.headers
              .remove('Authorization'); // Remove if not authenticated
        }
        return handler.next(options); // Continue with the request
      },
    ));
  }
}
