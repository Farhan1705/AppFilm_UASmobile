import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/favorite_controller.dart'; 
import '../controllers/film_controller.dart';
import 'add_edit_view.dart';
import 'detail_view.dart';
import 'favorite_view.dart';

class HomeView extends StatelessWidget {
  final FilmController filmController = Get.put(FilmController());
  final AuthController authController = Get.find();
  final FavoriteController favController = Get.find();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      filmController.fetchFilms();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Movie List'),
        actions: [
          Obx(
            () => Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  authController.isAdmin ? '[Admin]' : '[User]',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),

          IconButton(
            onPressed: () => Get.to(() => FavoriteView()), // ← TAMBAH
            icon: Icon(Icons.favorite),
            tooltip: 'Favorit',
          ),

          IconButton(
            onPressed: () => authController.logout(),
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Obx(() {
        if (filmController.isLoading.value && filmController.filmList.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari film...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
                onChanged: (val) => filmController.searchQuery.value = val,
              ),
            ),

            // Filter Chip
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemCount: filmController.kategoriList.length,
                itemBuilder: (context, index) {
                  final kat = filmController.kategoriList[index];
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Obx(
                      () => ChoiceChip(
                        label: Text(kat),
                        selected: filmController.selectedKategori.value == kat,
                        onSelected: (_) =>
                            filmController.selectedKategori.value = kat,
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 8),

            // Film List
            Expanded(
              child: filmController.filteredFilms.isEmpty
                  ? Center(child: Text('Film tidak ditemukan.'))
                  : RefreshIndicator(
                      onRefresh: () => filmController.fetchFilms(),
                      child: ListView.builder(
                        itemCount: filmController.filteredFilms.length,
                        itemBuilder: (context, index) {
                          final film = filmController.filteredFilms[index];
                          final isComingSoon = DateTime.fromMillisecondsSinceEpoch(film.tanggalRilis * 1000).isAfter(DateTime.now());
                          return ListTile(
                            leading: Stack(
                              children: [
                                Image.network(
                                  film.gambarPoster,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(Icons.movie),
                                ),
                                if (isComingSoon)
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      color: Colors.orange.withOpacity(0.85),
                                      padding: EdgeInsets.symmetric(vertical: 1),
                                      child: Text(
                                        'Soon',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            title: Row(
                              children: [
                                Flexible(child: Text(film.judul)),
                                if (isComingSoon) ...[  
                                  SizedBox(width: 6),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Coming Soon',
                                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            subtitle: Text(
                              '${film.kategori} • ${film.skorRating}/100',
                            ),
                            
                            trailing: Obx(
                              () => IconButton(
                                icon: Icon(
                                  favController.isFavorite(film.id ?? '')
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: favController.isFavorite(film.id ?? '')
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () =>
                                    favController.toggleFavorite(film),
                              ),
                            ),

                            onTap: () => Get.to(() => DetailView(film: film)),
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      }),
      floatingActionButton: Obx(
        () => authController.isAdmin
            ? FloatingActionButton(
                onPressed: () => Get.to(() => AddEditView()),
                child: Icon(Icons.add),
                tooltip: 'Tambah Film',
              )
            : SizedBox.shrink(),
      ),
    );
  }
}
