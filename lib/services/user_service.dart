import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static const String _baseUrl = 'https://reqres.in/api';

  static const Duration _timeout = Duration(seconds: 15);

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<List<UserModel>> getUsers() async {
    try {
      final uri = Uri.parse('$_baseUrl/users?page=1');
      final response = await http
          .get(uri, headers: _headers)
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> data = body['data'] as List<dynamic>;
        return data
            .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Gagal mengambil data pengguna. Status: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(
          'Tidak dapat terhubung ke internet. Periksa koneksi Anda.');
    } on TimeoutException {
      throw Exception(
          'Permintaan membutuhkan waktu terlalu lama. Silakan coba lagi.');
    } on FormatException {
      throw Exception('Format data yang diterima tidak valid.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Gagal mengambil data pengguna.');
    }
  }

  Future<Map<String, dynamic>> createUser({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/users');
      final body = jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
      });

      final response = await http
          .post(uri, headers: _headers, body: body)
          .timeout(_timeout);

      if (response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
            'Gagal menambahkan pengguna. Status: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(
          'Tidak dapat terhubung ke internet. Periksa koneksi Anda.');
    } on TimeoutException {
      throw Exception(
          'Permintaan membutuhkan waktu terlalu lama. Silakan coba lagi.');
    } on FormatException {
      throw Exception('Format data yang diterima tidak valid.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Gagal menambahkan pengguna.');
    }
  }

  Future<Map<String, dynamic>> updateUser({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/users/$id');
      final body = jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
      });

      final response = await http
          .put(uri, headers: _headers, body: body)
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
            'Gagal memperbarui pengguna. Status: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(
          'Tidak dapat terhubung ke internet. Periksa koneksi Anda.');
    } on TimeoutException {
      throw Exception(
          'Permintaan membutuhkan waktu terlalu lama. Silakan coba lagi.');
    } on FormatException {
      throw Exception('Format data yang diterima tidak valid.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Gagal memperbarui pengguna.');
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      final uri = Uri.parse('$_baseUrl/users/$id');
      final response = await http
          .delete(uri, headers: _headers)
          .timeout(_timeout);

      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception(
            'Gagal menghapus pengguna. Status: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(
          'Tidak dapat terhubung ke internet. Periksa koneksi Anda.');
    } on TimeoutException {
      throw Exception(
          'Permintaan membutuhkan waktu terlalu lama. Silakan coba lagi.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Gagal menghapus pengguna.');
    }
  }
}
