import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:secaspi/pages/welcome.dart";

import "../services/storage.dart";

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SECASPI"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.info)),
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                    title: "LOGOUT",
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          box.erase(); // remove all creds
                          Get.to(() => WelcomePage());
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Image.asset(
                  'assets/logo.jpg',
                  width: 100,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                    "Welcome to SECASPI - your go-to app for finding loving homes for cats and dogs!"),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                    "At SECASPI, we believe that every pet deserves a warm and caring home. Our mission is to connect pet lovers with furry friends in need, creating lifelong bonds that bring joy and happiness to both humans and animals."),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                    "Browse through our extensive collection of adorable cats and dogs available for adoption. Each profile showcases their unique personalities, ages, and backgrounds. You can easily filter your search based on breed, size, age, and location to find the perfect companion that matches your lifestyle and preferences."),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                    "Our dedicated team ensures that all pets listed on SECASPI are well-cared for and ready to be welcomed into their forever homes. They undergo thorough health check-ups, vaccinations, and are often spayed or neutered. We provide detailed information about their temperament, training, and any special requirements they may have, ensuring transparency and helping you make an informed decision.",
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                    "Our dedicated team ensures that all pets listed on SECASPI are well-cared for and ready to be welcomed into their forever homes. They undergo thorough health check-ups, vaccinations, and are often spayed or neutered. We provide detailed information about their temperament, training, and any special requirements they may have, ensuring transparency and helping you make an informed decision.",
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "SECASPI also offers a community section where you can connect with fellow pet lovers, share stories, seek advice, and participate in local events and volunteer opportunities. We believe in building a compassionate and supportive community that celebrates the love and companionship our pets bring to our lives."),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                    "Join SECASPI today and embark on a heartwarming journey of finding your perfect feline or canine companion. Together, let's make a difference in the lives of these wonderful animals, one adoption at a time."),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
