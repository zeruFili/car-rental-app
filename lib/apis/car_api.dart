import 'package:dio/dio.dart';
import '../apis/base_api.dart';

class CarApi extends BaseUrl {
  Future<Response> getAllCars() async {
    try {
      final response = await dio.get('cars'); // Adjust the endpoint as needed
      return response; // Return the response for further handling
    } catch (e) {
      throw Exception('Failed to fetch cars: $e');
    }
  }

  Future<Response> createCar(FormData data) async {
    try {
      // Don't set Content-Type here - let the interceptor handle it
      final response = await dio.post(
        'cars',
        data: data,
        options: Options(
          // This will prevent the interceptor from setting JSON content-type
          contentType: 'multipart/form-data',
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to create car: $e');
    }
  }
}
