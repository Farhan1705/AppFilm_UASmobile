import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatelessWidget {
  final AuthController authController = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authController.isLoading.value
                    ? null
                    : () {
                        if (emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          authController.login(
                            emailController.text,
                            passwordController.text,
                          );
                        } else {
                          Get.snackbar('Error', 'Email dan password harus diisi');
                        }
                      },
                child: authController.isLoading.value
                    ? CircularProgressIndicator()
                    : Text('Login'),
              ),
            )),
            TextButton(
              onPressed: () => Get.toNamed('/register'),
              child: Text('Belum punya akun? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
