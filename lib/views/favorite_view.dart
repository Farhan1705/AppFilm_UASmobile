import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/film_controller.dart';
import 'detail_view.dart';

class FavoriteView extends StatelessWidget {
  final FavoriteController favController = Get.find();
  final FilmController filmController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Film Favorit')),
      body: Obx(() {
        favController.favoriteIds.value;
        final films = favController.getFavoriteFilms();

        if (films.isEmpty) {
          return Center(child: Text('Belum ada film favorit'));
        }

        return ListView.builder(
          itemCount: films.length,
          itemBuilder: (context, index) {
            final film = films[index];
            return ListTile(
              leading: Image.network(
                film.gambarPoster,
                width: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.movie),
              ),
              title: Text(film.judul),
              subtitle: Text('${film.kategori} • ${film.skorRating}/100'),
              trailing: IconButton(
                icon: Icon(Icons.favorite, color: Colors.red),
                onPressed: () => favController.toggleFavorite(film),
              ),
              onTap: () => Get.to(() => DetailView(film: film)),
            );
          },
        );
      }),
    );
  }
}
