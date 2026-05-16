import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/film_controller.dart';
import '../models/film_model.dart';
import 'add_edit_view.dart';

class DetailView extends StatelessWidget {
  final Film film;
  DetailView({required this.film});

  final FilmController controller = Get.find();
  final AuthController authController = Get.find();
  final FavoriteController favController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(film.judul),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                favController.isFavorite(film.id ?? '')
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: favController.isFavorite(film.id ?? '')
                    ? Colors.red
                    : null,
              ),
              onPressed: () => favController.toggleFavorite(film),
            ),
          ),
          Obx(() => authController.isAdmin
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => Get.to(() => AddEditView(film: film)),
                      icon: Icon(Icons.edit),
                      tooltip: 'Edit',
                    ),
                    Obx(() => IconButton(
                      onPressed: controller.isDeleting.value
                          ? null
                          : () => controller.confirmDelete(film.id!, film.judul),
                      icon: controller.isDeleting.value
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(Icons.delete),
                      tooltip: 'Hapus',
                    )),
                  ],
                )
              : SizedBox.shrink()),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            Center(
              child: Image.network(
                film.gambarPoster,
                height: 200,
                errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: 80),
              ),
            ),
            SizedBox(height: 16),

            // Info dasar
            Text(film.judul, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Kategori: ${film.kategori}'),
            Text('Rating: ${film.skorRating}/100'),
            Text(
              'Rilis: ${DateTime.fromMillisecondsSinceEpoch(film.tanggalRilis * 1000).toString().split(' ')[0]}',
            ),
            SizedBox(height: 16),

            // Ringkasan
            Text('Ringkasan', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(film.ringkasan),
            SizedBox(height: 16),

            // Trailer
            if (film.urlTrailer.isNotEmpty)
              ElevatedButton(
                onPressed: () async {
                  final url = film.urlTrailer;
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                  } else {
                    Get.snackbar('Error', 'Tidak bisa membuka trailer');
                  }
                },
                child: Text('Tonton Trailer'),
              ),
          ],
        ),
      ),
    );
  }
}
