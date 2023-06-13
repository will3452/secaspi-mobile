import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:secaspi/pages/register.dart";

import "login.dart";

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/logo.jpg', width: 200, ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(onPressed: () {
              Get.to(() => const LoginPage());
            }, child: const Text("Log In")),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(onPressed: () {
              Get.to(() => const RegisterPage());
            }, child: const Text("Sign Up")),
          ),
        ],
      ),),
    );
  }
}
