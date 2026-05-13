import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/film_controller.dart';
import '../models/film_model.dart';

class AddEditView extends StatelessWidget {
  final Film? film;
  AddEditView({this.film});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController judulCtrl = TextEditingController();
  final TextEditingController ringkasanCtrl = TextEditingController();
  final TextEditingController posterCtrl = TextEditingController();
  final TextEditingController sampulCtrl = TextEditingController();
  final TextEditingController ratingCtrl = TextEditingController();
  final TextEditingController kategoriCtrl = TextEditingController();
  final TextEditingController trailerCtrl = TextEditingController();
  final TextEditingController tanggalCtrl = TextEditingController();

  void _initFields() {
    if (film != null) {
      judulCtrl.text = film!.judul;
      ringkasanCtrl.text = film!.ringkasan;
      posterCtrl.text = film!.gambarPoster;
      sampulCtrl.text = film!.gambarSampul;
      ratingCtrl.text = film!.skorRating.toString();
      kategoriCtrl.text = film!.kategori;
      trailerCtrl.text = film!.urlTrailer;
      tanggalCtrl.text = film!.tanggalRilis.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    _initFields();
    final FilmController controller = Get.find();
    final isEdit = film != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Film' : 'Tambah Film')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field(judulCtrl, 'Judul', required: true),
              _field(ringkasanCtrl, 'Ringkasan', maxLines: 3),
              _field(posterCtrl, 'URL Poster'),
              _field(sampulCtrl, 'URL Sampul'),
              _field(ratingCtrl, 'Rating (0-100)', type: TextInputType.number),
              _field(kategoriCtrl, 'Kategori'),
              _field(trailerCtrl, 'URL Trailer'),
              _field(tanggalCtrl, 'Timestamp Rilis', type: TextInputType.number),
              SizedBox(height: 20),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          final newFilm = Film(
                            id: film?.id,
                            judul: judulCtrl.text,
                            ringkasan: ringkasanCtrl.text,
                            gambarPoster: posterCtrl.text,
                            gambarSampul: sampulCtrl.text,
                            skorRating: int.tryParse(ratingCtrl.text) ?? 0,
                            kategori: kategoriCtrl.text,
                            urlTrailer: trailerCtrl.text,
                            tanggalRilis: int.tryParse(tanggalCtrl.text) ?? 0,
                          );
                          if (isEdit) {
                            controller.updateFilm(film!.id!, newFilm);
                          } else {
                            controller.addFilm(newFilm);
                          }
                        }
                      },
                child: controller.isLoading.value
                    ? CircularProgressIndicator()
                    : Text(isEdit ? 'Update' : 'Simpan'),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label, {
    int maxLines = 1,
    TextInputType type = TextInputType.text,
    bool required = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        maxLines: maxLines,
        keyboardType: type,
        validator: required
            ? (v) => v == null || v.isEmpty ? '$label harus diisi' : null
            : null,
      ),
    );
  }
}
