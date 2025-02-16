import 'package:flutter/material.dart';
import 'manualSchema.dart';

class NewContentPage extends StatefulWidget {
  const NewContentPage({super.key});

  @override
  State<NewContentPage> createState() => _NewContentPageState();
}

class _NewContentPageState extends State<NewContentPage> {

  final List<DefenceManual> defenceManuals = [
    DefenceManual(
        title: "8 Self-Defense Moves Every Woman Needs to Know",
        imageUrl: "https://i0.wp.com/post.healthline.com/wp-content/uploads/2022/01/Nicole-Davis-500x500-Bio.png?w=105&h=105",
        searchable: "https://www.healthline.com/health/womens-health/self-defense-tips-escape"
    ),
    DefenceManual(
        title: "Women’s Safety: Self-Defense Tips and Why Is It Important",
        imageUrl: "https://media.seniority.in/mageplaza/blog/post/ktpl_blog/main_image_-_self_defense.jpg",
        searchable: "https://seniority.in/blog/womens-safety-self-defense-tips-and-why-is-it-important"
    ),
    DefenceManual(
        title: "Top 3 Most Effective Self Defence Moves for Women",
        imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSg-GW5mC_J15eIBlKz5MzhldMFIPIKh4QB_g&s",
        searchable: "https://youtu.be/SSnnte5cVIo?si=w9KFPF8fASWx0xnP"
    ),

  ];

  final List<SafetyBlogs> safetyBlogs = [
    SafetyBlogs(
        title: "Women's safety at workplace",
        imageUrl:
            "https://blogimage.vantagecircle.com/vcblogimage/en/2024/10/Women-s-safety-at-workplace.jpg",
        searchable:
            "https://www.vantagecircle.com/en/blog/womens-safety-workplace/"),
    SafetyBlogs(
        title: "Women's Safety: Building confidence",
        imageUrl:
            "https://zhl.org.in/blog/wp-content/uploads/2023/07/WOMEN-SAFETY-1-1-2-1-1-1.jpeg",
        searchable: "https://zhl.org.in/blog/growing-need-women-safety-india/"),
    SafetyBlogs(
        title: "Women's Safety: Law and policies",
        imageUrl:
            "https://www.khanglobalstudies.com/blog/wp-content/uploads/2024/09/Women-Safety-1024x576.jpg",
        searchable: "https://www.khanglobalstudies.com/blog/women-safety/"),
    SafetyBlogs(
        title: "Women’s Safety: Initiatives and Challenges",
        imageUrl:
            "https://sleepyclasses.com/wp-content/uploads/2024/05/LogoCompressed.png",
        searchable: "https://sleepyclasses.com/womens-safety-in-india/"),
  ];

  final List<AccessManual> accessManual = [
    AccessManual(
        title: "What is a SOS?",
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcST4Yzb80_jIgbz17IQ2I18qii1gqDneHZfnw&s",
        content:
            " the SOS (Save our Souls) feature sends an alert to emergency services or contacts when a user needs immediate assistance.\n The alert includes the user's location, battery percentage, and other information."),
    AccessManual(
        title: "How to make SOS alert?",
        imageUrl:
            "https://img.freepik.com/premium-vector/sos-notification-screen-phone-sos-emergency-call-phone-911-call-screen-smartphone-cry-help-calling-help-vector-stock-illustration_435184-1303.jpg",
        content:
            "The SOS feature is embedded in our home page.\n\n Follow the steps:\n1. Open the homepage.\n2. Click on the SOS button in the center\n3. If a dropdown message is recieved then the SOS is successfully sent"),
    AccessManual(
        title: "How to add Contacts?",
        imageUrl:
            "https://img.freepik.com/free-vector/mobile-inbox-concept-illustration_114360-4014.jpg",
        content:
            "Follow the simple steps to add contact:\n1. Visit Contact page from Navigation bar on the bottom\n2. Add contact details and hit save\n3. The card will appear with name and details."),
    AccessManual(
        title: "How to locate Safe-Zones?",
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPfNxeXYCh6YJS_mZGGh-8HE6FQEUlHAOB2g&s",
        content:
            "Safe zones are safety location marked on the map.\n\nFollow the steps to track safe zones\n1. Go to Map section from bottom Navigation bar\n2. Click on the track safe zones button\n3. The nearest safe zone will be tracked on the map screen."),
  ];

  int selected = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            //   Start of the Column
            Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _topButtons("How to access?", () {
                          setState(() {
                            selected = 1;
                          });
                        }),
                        _topButtons("Safety Blogs", () {
                          setState(() {
                            selected = 2;
                          });
                        }),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _topButtons("Quick Manuals", () {
                          setState(() {
                            selected = 3;
                          });
                          ;
                        }),
                        _topButtons("Misc", () {
                          setState(() {
                            selected = 4;
                          });
                          ;
                        }),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )), // This is the starting container with main buttons
            SingleChildScrollView(
                child: selected == 1
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: accessManual.length,
                        itemBuilder: (context, index) {
                          final manual = accessManual[index];
                          return aManual(context, manual);
                        },
                      )
                    : selected == 2
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: safetyBlogs.length,
                            itemBuilder: (context, index) {
                              final manual = safetyBlogs[index];
                              return sManual(context, manual);
                            },
                          )
                        : selected == 3
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: defenceManuals.length,
                                itemBuilder: (context, index) {
                                  final manual = defenceManuals[index];
                                  return dManual(context, manual);
                                },
                              )
                            : selected == 4
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: accessManual.length,
                                    itemBuilder: (context, index) {
                                      final manual = accessManual[index];
                                      return aManual(context, manual);
                                    },
                                  )
                                : Text("Please Select type of articles...."))
            // End of the column
          ],
        ),
      ),
    );
  }
}

Widget _topButtons(String name, VoidCallback callback) => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      width: 190,
      child: Center(
        // Centering the text button
        child: TextButton(
          // adding the text button
          onPressed: callback,
          child: Text(
            name,
            style: TextStyle(
              // text style
              color: Colors.black,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );