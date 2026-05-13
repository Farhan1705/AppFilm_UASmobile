import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Daftar email yang dianggap admin
  static const List<String> _adminEmails = [
    'admin@movieapp.com',
  ];

  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var currentUser = Rxn<User>();
  var role = 'user'.obs; // 'admin' atau 'user'

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? user) {
      currentUser.value = user;
      isLoggedIn.value = user != null;
      _updateRole(user);
    });
  }

  void _updateRole(User? user) {
    if (user == null) {
      role.value = 'user';
    } else if (_adminEmails.contains(user.email?.toLowerCase())) {
      role.value = 'admin';
    } else {
      role.value = 'user';
    }
  }

  bool get isAdmin => role.value == 'admin';

  // REGISTER
  Future<void> register(String email, String password, String name) async {
    try {
      isLoading.value = true;

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

      Get.snackbar(
        'Sukses',
        'Akun berhasil dibuat! Silakan login.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );

      Get.offAllNamed('/login');
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'email-already-in-use') {
        message = 'Email sudah terdaftar';
      } else if (e.code == 'weak-password') {
        message = 'Password terlalu lemah (minimal 6 karakter)';
      } else {
        message = e.message ?? 'Registrasi gagal';
      }
      Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // LOGIN
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      Get.snackbar(
        'Sukses',
        'Login berhasil!',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1),
      );

      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'Email tidak terdaftar';
      } else if (e.code == 'wrong-password') {
        message = 'Password salah';
      } else {
        message = e.message ?? 'Login gagal';
      }
      Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
    Get.snackbar('Info', 'Anda telah logout', snackPosition: SnackPosition.BOTTOM);
  }

  String getUserName() {
    return currentUser.value?.displayName ?? currentUser.value?.email ?? 'User';
  }
}