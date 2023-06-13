import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:secaspi/pages/about.dart";
import "package:secaspi/pages/welcome.dart";

import "../services/http.dart";
import "../services/storage.dart";

class ShowConversationPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final conversation;
  const ShowConversationPage({Key? key, required this.conversation})
      : super(key: key);

  @override
  State<ShowConversationPage> createState() => _ShowConversationPageState();
}

class _ShowConversationPageState extends State<ShowConversationPage> {

  final TextEditingController _message = TextEditingController();

  void sendMessage() async {
    try {
      var response = await dio.post('/messages', data: {
        "conversation_id": widget.conversation['id'],
        "user_id": box.read('userId'),
        "content": _message.text,
      });

      _message.text = "";

      setState(() {
        messages.add(response.data);
      });



      print("response >> ${widget.conversation['messages']}");
    } catch (error) {
      print("error >> $error");
      Get.defaultDialog(title: "ERROR", content: const Text("Failed to send message."), );
    }
  }

  var messages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      messages = widget.conversation['messages'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.conversation['name']}"),
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
      body: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (_, index) {
                        var message = messages[index];
                        String date =
                            "${DateTime.parse(message['created_at']).month}/${DateTime.parse(message['created_at']).day}/${DateTime.parse(message['created_at']).year}";

                        if (message['user'] == null) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10.0),
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  color: Colors.blue,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("${message['content']}"),
                                ),
                              ),
                              Text(
                                date,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              )
                            ],
                          );
                        }

                        if (message['user_id'] != box.read('userId')) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10.0),
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  color: Colors.grey,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("${message['content']}"),
                                ),
                              ),
                              Text(
                                date,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              )
                            ],
                          );
                        }

                        if (message['user']['email'] == box.read('userEmail')) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10.0),
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  color: Colors.blue,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("${message['content']}"),
                                ),
                              ),
                              Text(
                                date,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              )
                            ],
                          );
                        }
                      },
                      itemCount: messages.length,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Aa"
                            ),
                            controller: _message,
                          ),
                        ),
                        IconButton(onPressed: () {
                          sendMessage();
                        }, icon: const Icon(Icons.send))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
