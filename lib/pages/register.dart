import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:secaspi/pages/login.dart";
import "package:secaspi/services/http.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _password = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // state
  bool loading = false;

  void register() async {
    try {
      setState(() {
        loading = true;
      });

      var response = await dio.post('/register', data: {
        "name": _name.text,
        "password": _password.text,
        "email": _email.text,
      });

      print("response >> $response");
      Get.defaultDialog(
        title: "SUCCESS",
        content: Text("You registered successfully!"),
        confirm: ElevatedButton(onPressed: () {
          Get.to(() => const LoginPage(), transition: Transition.upToDown);
        }, child: const Text("Login now"))
      );
    } catch (error) {
      if (error is DioError) {
        Get.defaultDialog(title: "Error", content: Text("Failed to register!"));
      } else {
        Get.defaultDialog(
            title: "Error", content: Text("Something went wrong!"));
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
              child: SingleChildScrollView(
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
                                    const InputDecoration(label: Text("NAME")),
                                controller: _name,
                                validator: (value) {
                                  if (value == "") {
                                    return "Name is required.";
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
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
                                        register();
                                      }
                                    },
                                    child: Text("REGISTER")),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                    onPressed: () {
                                      Get.to(() => LoginPage());
                                    },
                                    child: Text("ALREADY HAVE AN ACCOUNT?")),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
