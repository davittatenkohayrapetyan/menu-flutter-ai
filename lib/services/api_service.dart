import 'package:dio/dio.dart';
import '../models/menu_item.dart';

class ApiService {
  final Dio _dio;
  final String baseUrl;

  ApiService({String? baseUrl})
      : baseUrl = baseUrl ?? 'http://localhost:3000',
        _dio = Dio(BaseOptions(
          baseUrl: baseUrl ?? 'http://localhost:3000',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ));

  Future<List<MenuItem>> parseMenu(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        '/parse-menu',
        data: formData,
      );

      final List<dynamic> items = response.data['items'] ?? [];
      return items
          .map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to parse menu: $e');
    }
  }

  Future<MenuItem> enrichDish(MenuItem item) async {
    try {
      final response = await _dio.post(
        '/enrich-dish',
        data: {
          'name': item.name,
          'description': item.description,
        },
      );

      return MenuItem.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to enrich dish: $e');
    }
  }
}
