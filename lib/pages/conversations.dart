import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:secaspi/pages/about.dart";
import "package:secaspi/pages/conversation.dart";
import "package:secaspi/pages/welcome.dart";

import "../services/http.dart";
import "../services/storage.dart";

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {

  Future<dynamic> loadConversations() async {
    dio.options.headers['Authorization'] = 'Bearer ${box.read('userToken')}';

    var response = await dio.get('/conversations/me');

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
                          box.erase(); // remove all credentials
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
      body: FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong!"),
            );
          }
          
          if (snapshot.data.data.length == 0) {
            return const Center(
              child: Text("No Conversation Found."),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:  Text("Conversations (${snapshot.data.data.length})"),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ListView.builder(itemBuilder: (_, index) {
                    var record  = snapshot.data.data[index];
                    String name = record['name'];
                    List<String> names = name.split(":");
                    if (names.length > 1) {
                      name = names[1];
                    }
                    String date = "${DateTime.parse(record['created_at']).month}/${DateTime.parse(record['created_at']).day}/${DateTime.parse(record['created_at']).year}";
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(name),
                          subtitle: Text(date),
                          onTap: () {
                            Get.to(() =>  ShowConversationPage(conversation: record,));
                          },
                        ),
                      ),
                    );
                  }, itemCount: snapshot.data.data.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                  ),
                ),
              ],
            ),
          );
        },
        future: loadConversations(),
      )
    );
  }
}
