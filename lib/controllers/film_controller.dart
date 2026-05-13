import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/film_model.dart';
import '../services/api_service.dart';

class FilmController extends GetxController {
  final ApiService _apiService = ApiService();
  
  var filmList = <Film>[].obs;
  var isLoading = false.obs;
  var isDeleting = false.obs;

  // READ - Ambil semua film dari MockAPI
  Future<void> fetchFilms() async {
    try {
      isLoading.value = true;
      final films = await _apiService.getFilms();
      filmList.value = films;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat film: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // CREATE - Tambah film ke MockAPI
  Future<void> addFilm(Film film) async {
    try {
      isLoading.value = true;
      final newFilm = await _apiService.createFilm(film);
      filmList.add(newFilm);
      Get.back(); // Kembali ke halaman home
      Get.snackbar('Sukses', 'Film "${film.judul}" berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambah film: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // UPDATE - Edit film di MockAPI
  Future<void> updateFilm(String id, Film film) async {
    try {
      isLoading.value = true;
      final updatedFilm = await _apiService.updateFilm(id, film);
      
      // Update di list
      int index = filmList.indexWhere((f) => f.id == id);
      if (index != -1) {
        filmList[index] = updatedFilm;
      }
      
      Get.back();
      Get.snackbar('Sukses', 'Film "${film.judul}" berhasil diupdate');
    } catch (e) {
      Get.snackbar('Error', 'Gagal update film: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // DELETE - Hapus film dari MockAPI
  Future<void> deleteFilm(String id, String judul) async {
    try {
      isDeleting.value = true;
      await _apiService.deleteFilm(id);
      filmList.removeWhere((film) => film.id == id);
      Get.snackbar('Sukses', 'Film "$judul" berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal hapus film: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  // Konfirmasi hapus dengan dialog
  void confirmDelete(String id, String judul) {
    Get.dialog(
      AlertDialog(
        title: Text('Hapus Film'),
        content: Text('Apakah Anda yakin ingin menghapus "$judul"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              deleteFilm(id, judul);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Hapus'),
          ),
        ],
      ),
    );
  }
}