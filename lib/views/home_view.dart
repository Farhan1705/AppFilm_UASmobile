import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/film_controller.dart';
import 'add_edit_view.dart';
import 'detail_view.dart';

class HomeView extends StatelessWidget {
  final FilmController filmController = Get.put(FilmController());
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      filmController.fetchFilms();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Movie List'),
        actions: [
          Obx(() => Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                authController.isAdmin ? '[Admin]' : '[User]',
                style: TextStyle(fontSize: 12),
              ),
            ),
          )),
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

        if (filmController.filmList.isEmpty) {
          return Center(child: Text('Belum ada film.'));
        }

        return RefreshIndicator(
          onRefresh: () => filmController.fetchFilms(),
          child: ListView.builder(
            itemCount: filmController.filmList.length,
            itemBuilder: (context, index) {
              final film = filmController.filmList[index];
              return ListTile(
                leading: Image.network(
                  film.gambarPoster,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(Icons.movie),
                ),
                title: Text(film.judul),
                subtitle: Text('${film.kategori} • ${film.skorRating}/100'),
                onTap: () => Get.to(() => DetailView(film: film)),
              );
            },
          ),
        );
      }),
      floatingActionButton: Obx(() => authController.isAdmin
          ? FloatingActionButton(
              onPressed: () => Get.to(() => AddEditView()),
              child: Icon(Icons.add),
              tooltip: 'Tambah Film',
            )
          : SizedBox.shrink()),
    );
  }
}
