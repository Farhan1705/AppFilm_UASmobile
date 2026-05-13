# App Film 🎬

Aplikasi Flutter untuk menampilkan dan mengelola daftar film. Menggunakan Firebase Authentication untuk login/register dan MockAPI sebagai backend data film.

---

## Fitur

- Login & Register dengan Firebase Authentication
- Role system: **Admin** (CRUD) dan **User** (read-only)
- Lihat daftar film
- Lihat detail film + buka trailer
- Admin: tambah, edit, hapus film
- Data film dari MockAPI (REST API)

---

## Struktur Proyek

```
lib/
├── controllers/
│   ├── auth_controller.dart   # Logic login, register, logout, role
│   └── film_controller.dart   # Logic CRUD film
├── models/
│   └── film_model.dart        # Model data Film
├── services/
│   └── api_service.dart       # HTTP request ke MockAPI
├── views/
│   ├── login_view.dart
│   ├── register_view.dart
│   ├── home_view.dart
│   ├── detail_view.dart
│   └── add_edit_view.dart
├── firebase_options.dart      # Auto-generated oleh FlutterFire CLI
└── main.dart
```

---

## Prasyarat

Pastikan sudah terinstall:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi 3.x ke atas)
- [Dart SDK](https://dart.dev/get-dart) (sudah termasuk dalam Flutter)
- [Android Studio](https://developer.android.com/studio) atau VS Code
- Git

Cek instalasi Flutter:
```bash
flutter doctor
```
Semua centang hijau sebelum lanjut.

---

## Cara Menjalankan Project

### 1. Clone repository

```bash
git clone <url-repository>
cd app_film
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Setup Firebase

Project ini menggunakan Firebase. Setiap anggota perlu menghubungkan ke Firebase project yang sama.

**Opsi A — Minta file `google-services.json` dari ketua kelompok:**
- Letakkan file `google-services.json` di folder `android/app/`
- Letakkan file `firebase_options.dart` di folder `lib/` (ganti yang sudah ada)

**Opsi B — Setup ulang dengan FlutterFire CLI:**

Install FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

Tambahkan ke PATH (jalankan sekali di PowerShell):
```powershell
$env:PATH += ";$env:LOCALAPPDATA\Pub\Cache\bin"
```

Login ke Firebase dan configure:
```bash
firebase login
flutterfire configure
```
Pilih project Firebase yang sama dengan ketua kelompok.

### 4. Aktifkan Developer Mode (Windows)

Flutter membutuhkan Developer Mode untuk build dengan plugin native:

```
ms-settings:developers
```
Buka Settings tersebut dan aktifkan **Developer Mode**.

### 5. Jalankan aplikasi

```bash
flutter run
```

Pilih device yang tersedia (Chrome, Windows, atau Android emulator/device).

---

## Akun untuk Testing

### Akun Admin
Email admin ditentukan di `lib/controllers/auth_controller.dart`:

```dart
static const List<String> _adminEmails = [
  'admin@movieapp.com',
];
```

Daftar akun dengan email `admin@movieapp.com` melalui halaman Register, lalu login — otomatis mendapat akses Admin (CRUD).

### Akun User Biasa
Daftar dengan email apapun selain yang ada di list `_adminEmails`. User biasa hanya bisa melihat film.

---

## Menambah Admin Baru

Buka `lib/controllers/auth_controller.dart`, tambahkan email ke list:

```dart
static const List<String> _adminEmails = [
  'admin@movieapp.com',
  'email-anggota@gmail.com', // tambahkan di sini
];
```

---

## Dependencies

| Package | Versi | Kegunaan |
|---|---|---|
| `get` | ^4.7.3 | State management & navigasi |
| `firebase_core` | ^4.8.0 | Inisialisasi Firebase |
| `firebase_auth` | ^6.5.0 | Autentikasi pengguna |
| `http` | ^1.1.0 | HTTP request ke MockAPI |
| `url_launcher` | ^6.3.2 | Buka link trailer |

---

## API

Data film menggunakan MockAPI:

```
Base URL: https://68ff8dfbe02b16d1753e765d.mockapi.io/film
```

| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/film` | Ambil semua film |
| POST | `/film` | Tambah film baru |
| PUT | `/film/:id` | Update film |
| DELETE | `/film/:id` | Hapus film |

### Struktur data Film

```json
{
  "id": "1",
  "judul": "Judul Film",
  "ringkasan": "Deskripsi singkat film",
  "gambar_poster": "https://url-gambar.com/poster.jpg",
  "gambar_sampul": "https://url-gambar.com/sampul.jpg",
  "tanggal_rilis": 1700000000,
  "skor_rating": 85,
  "kategori": "Action",
  "url_trailer": "https://youtube.com/watch?v=xxx"
}
```

> `tanggal_rilis` menggunakan format **Unix timestamp** (detik).

---

## Troubleshooting

**`package:get/get.dart` not found**
```bash
flutter pub get
```

**`flutterfire` not recognized**
```bash
dart pub global activate flutterfire_cli
$env:PATH += ";$env:LOCALAPPDATA\Pub\Cache\bin"
```

**`AuthController not found`**
Pastikan `Get.put(AuthController())` ada di `main()` sebelum `runApp()`.

**Build gagal di Windows**
Aktifkan Developer Mode di Settings Windows.

**Firebase 400 Bad Request saat register**
Buka Firebase Console → Authentication → Sign-in method → aktifkan **Email/Password**.
