import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:secaspi/pages/about.dart";
import "package:secaspi/pages/home.dart";
import "package:secaspi/pages/search.dart";
import "package:secaspi/pages/welcome.dart";
import "package:secaspi/services/http.dart";

import "../services/storage.dart";
import "conversations.dart";

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  bool loading = false;
  Future<dynamic> loadPets() async {
    Future.delayed(const Duration(seconds: 5));
    dio.options.headers['Authorization'] = 'Bearer ${box.read('userToken')}';

    var response = await dio.get('/pets');

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SECASPI"),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const AboutPage(), transition: Transition.downToUp);
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
        child: SingleChildScrollView(
          child: FutureBuilder(
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong!"),
                );
              }
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: ListView.builder(
                  itemBuilder: (_, index) {
                    var record = snapshot.data.data![index];
                    return SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    'https://secaspi.elezerk.net/storage/${record['image']}'),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${record['name']}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 19),
                                                    ),
                                                    Text("${record['type']}"),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Text(record['story']),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {},
                                            child: Row(
                                              children: const [
                                                Icon(Icons.delete),
                                                Text("Remove"),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                            Positioned(
                              right: 16,
                              top: 16,
                              child: IconButton(
                                onPressed: () async {
                                  try {
                                    setState(() {
                                      loading = true;
                                    });

                                    dio.options.headers['Authorization'] =
                                    'Bearer ${box.read('userToken')}';

                                    var response = await dio
                                        .post('/conversations', data: {
                                      "name":
                                      "${box.read('userEmail')}:Adopt ${record['name']}"
                                    });
                                    Get.to( () => const ConversationPage());
                                    print("response >> $response");
                                  } catch (error) {
                                    print("error >> $error");
                                    Get.defaultDialog(
                                        title: "Error",
                                        content: Text(
                                            "Something wen't wrong please proceed to conversation page."));
                                  } finally {
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                },
                                icon: Icon(Icons.message),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data.data.length,
                  physics: const ClampingScrollPhysics(),
                ),
              );
            },
            future: loadPets(),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Get.to(() => HomePage());
          }

          if (index == 2) {
            Get.to(() => SearchPage());
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
