import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/film_model.dart';

class ApiService {
  static const String baseUrl = 'https://68ff8dfbe02b16d1753e765d.mockapi.io/film';

  // CREATE - Tambah film
  Future<Film> createFilm(Film film) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(film.toJson()),
      );

      if (response.statusCode == 201) {
        return Film.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal menambah film: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // READ - Ambil semua film
  Future<List<Film>> getFilms() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Film.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil film: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // UPDATE - Edit film
  Future<Film> updateFilm(String id, Film film) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(film.toJson()),
      );

      if (response.statusCode == 200) {
        return Film.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal update film: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // DELETE - Hapus film
  Future<void> deleteFilm(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        throw Exception('Gagal hapus film: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}