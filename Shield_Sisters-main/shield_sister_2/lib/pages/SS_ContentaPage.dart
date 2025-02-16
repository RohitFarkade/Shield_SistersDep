import 'package:flutter/material.dart';

class SSContentPage extends StatelessWidget {
  final List<Article> articles = [
    Article(
        title: "Stay Alert",
        imageUrl: "assets/images/stayAlert.jpg",
        description: "Tips on staying alert in public places.",
        content: "Always be aware of your surroundings and trust your instincts."),
    Article(
        title: "Self Defense Techniques",
        imageUrl: "assets/images/womenDefence.jpg",
        description: "Learn simple and effective self-defense techniques.",
        content:
        "Basic moves that can help protect yourself in dangerous situations."),
  ];

  final List<SafetyManual> manuals = [
    SafetyManual(
        title: "Defense Techniques",
        imageUrl: "assets/images/womenDefence.jpg",
        content: "Detailed guide on effective defense techniques with step-by-step visuals and explanations."
    ),
    SafetyManual(
        title: "Emergency Contacts",
        imageUrl: "assets/images/stayAlert.jpg",
        content: "Comprehensive list of emergency contacts and how to reach them quickly."
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Safety Resources"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Safety Guidelines & Articles",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(article.title),
                      content: Text(article.content),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Close"),
                        ),
                      ],
                    ),
                  ),
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            article.imageUrl,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                article.description,
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Safety Manuals",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: manuals.length,
              itemBuilder: (context, index) {
                final manual = manuals[index];
                return GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.asset(manual.imageUrl, fit: BoxFit.cover),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                manual.content,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(manual.imageUrl),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        manual.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Article {
  final String title;
  final String imageUrl;
  final String description;
  final String content;

  Article({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.content,
  });
}

class SafetyManual {
  final String title;
  final String imageUrl;
  final String content;

  SafetyManual({
    required this.title,
    required this.imageUrl,
    required this.content,
  });
}
