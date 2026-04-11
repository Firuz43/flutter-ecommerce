import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    // USE YOUR COMPUTER'S IP, NOT LOCALHOST
    // If using Android Emulator, use 10.0.2.2
    baseUrl: 'http://10.0.2.2:8000',
    connectTimeout: const Duration(seconds: 5),
  ));

  final _storage = const FlutterSecureStorage();

  ApiService() {
    // Add an Interceptor to automatically attach the JWT to every request
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await _storage.read(key: 'jwt');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  // --- AUTH METHODS ---

  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      // Save the token immediately on success
      await _storage.write(key: 'jwt', value: response.data['token']);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // --- PRODUCT METHODS ---

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}