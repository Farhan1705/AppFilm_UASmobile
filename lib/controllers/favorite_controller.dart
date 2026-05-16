import 'package:get/get.dart';
import '../models/film_model.dart';
import '../controllers/film_controller.dart';

class FavoriteController extends GetxController {
  var favoriteIds = <String>{}.obs;

  bool isFavorite(String id) => favoriteIds.contains(id);

  void toggleFavorite(Film film) {
    if (film.id == null) return;
    if (favoriteIds.contains(film.id)) {
      favoriteIds.remove(film.id);
      Get.snackbar('Favorit', '${film.judul} dihapus dari favorit');
    } else {
      favoriteIds.add(film.id!);
      Get.snackbar('Favorit', '${film.judul} ditambahkan ke favorit');
    }
    favoriteIds.refresh();
  }

  List<Film> getFavoriteFilms() {
    final filmController = Get.find<FilmController>();
    return filmController.filmList
        .where((f) => f.id != null && favoriteIds.contains(f.id))
        .toList();
  }
}
