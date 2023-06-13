import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:secaspi/pages/about.dart";
import "package:secaspi/pages/favorites.dart";
import "package:secaspi/pages/home.dart";
import "package:secaspi/pages/welcome.dart";
import "package:secaspi/services/http.dart";

import "../services/storage.dart";

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<dynamic> loadPets() async {
    Future.delayed(const Duration(seconds: 5));
    dio.options.headers['Authorization'] = 'Bearer ${box.read('userToken')}';

    var response = await dio.get('/pets');

    return response;
  }

  String? _selectedSize = 'Small';
  String? _selectedGender = 'Male';
  String? _selectedType = 'Cat';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SECASPI"),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(const AboutPage(), transition: Transition.downToUp);
              },
              icon: const Icon(Icons.info)),
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                    title: "LOGOUT",
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          box.erase(); // remove all creds
                          Get.to(() => const WelcomePage());
                        },
                        child: const Text("YES"),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("NO"),
                      )
                    ]);
              },
              icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      drawer: const Drawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Search Pet",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Select Type"),
                DropdownButton(
                  value: _selectedType,
                  items: const [
                    DropdownMenuItem(
                      value: 'Cat',
                      child: Text('Cat'),
                    ),
                    DropdownMenuItem(
                      value: 'Dog',
                      child: Text('Dog'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                  isExpanded: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Select Size"),
                DropdownButton(
                  value: _selectedSize,
                  items: const [
                    DropdownMenuItem(
                      value: 'Small',
                      child: Text('Small'),
                    ),
                    DropdownMenuItem(
                      value: 'Medium',
                      child: Text('Medium'),
                    ),
                    DropdownMenuItem(
                      value: 'Large',
                      child: Text('Large'),
                    ),
                    DropdownMenuItem(
                      value: 'X-Large',
                      child: Text('X-Large'),
                    )
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedSize = value;
                    });
                  },
                  isExpanded: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Select Gender"),
                DropdownButton(
                  value: _selectedGender,
                  items: const [
                    DropdownMenuItem(
                      value: 'Male',
                      child: Text('Male'),
                    ),
                    DropdownMenuItem(
                      value: 'Female',
                      child: Text('Female'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  isExpanded: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () {

                  } , child: Text('Search Pet')),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Get.to(() => FavoritePage());
          }

          if (index == 1) {
            Get.to(() => HomePage());
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          )
        ],
      ),
    );
  }
}
