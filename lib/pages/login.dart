import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:secaspi/pages/register.dart";
import "package:secaspi/pages/welcome.dart";
import "package:secaspi/services/http.dart";
import "package:secaspi/services/storage.dart";

import "home.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // state
  bool loading = false;

  void login() async {
    try {
      setState(() {
        loading = true;
      });
      var response = await dio.post(
        '/login',
        data: {'email': _email.text, 'password': _password.text},
        onSendProgress: (count, total) {
          print("count $count of $total");
        },
      );

      print("response ${response.data['token']}");

      box.write("userName", response.data['user']['name']);
      box.write("userId", response.data['user']['id']);
      box.write('userToken', response.data['token']);
      box.write('userEmail', response.data['user']['email']);

      Get.to(() => HomePage());
    } catch (error) {
      if (error is DioError) {
        print("DioError occurred: $error");
        Get.defaultDialog(
          title: "Error",
          content: Text("Account not found! "),
        );
      } else {
        print("Error occurred: $error");
        Get.defaultDialog(
          title: "Error",
          content: Text("Something went wrong !"),
        );
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      "SECASPI",
                      style: TextStyle(
                          fontSize: 32,
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration:
                                  const InputDecoration(label: Text("EMAIL")),
                              controller: _email,
                              validator: (value) {
                                if (value == "") {
                                  return "Email is required.";
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                  label: Text("PASSWORD")),
                              controller: _password,
                              validator: (value) {
                                if (value == "") {
                                  return "Password is required.";
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    bool isValid =
                                        _formKey.currentState!.validate();
                                    if (isValid) {
                                      login();
                                    }
                                  },
                                  child: Text("LOGIN")),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                  onPressed: () {
                                    Get.to(() => const RegisterPage());
                                  },
                                  child: Text("NO CREATED ACCOUNT?")),
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ),
    );
  }
}
