import 'package:flutter/material.dart';

class ResourcesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resources'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white,
              width: 5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  'Emergency Services',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ResourceTile(
                      title: 'Emergency Services',
                      subtitle: '911',
                    ),
                    ResourceTile(
                      title: 'Suicide Hotline',
                      subtitle: '1-800-273-TALK (8255)',
                    ),
                    ResourceTile(
                      title: 'National Domestic Violence Hotline',
                      subtitle: '1-800-799-SAFE (7233)',
                    ),
                    ResourceTile(
                      title: 'Substance Abuse and Mental Health Services Administration (SAMHSA)',
                      subtitle: '1-800-662-HELP (4357)',
                    ),
                    ResourceTile(
                      title: 'National Alliance on Mental Illness (NAMI)',
                      subtitle: '1-800-950-NAMI (6264)',
                    ),
                    ResourceTile(
                      title: 'Crisis Text Line',
                      subtitle: 'Text HOME to 741741',
                    ),
                    ResourceTile(
                      title: 'Veterans Crisis Line',
                      subtitle: '1-800-273-8255 (Press 1)',
                    ),
                    ResourceTile(
                      title: 'LGBT National Help Center',
                      subtitle: '1-888-843-4564',
                    ),
                    ResourceTile(
                      title: 'The Trevor Project (LGBTQ+ Youth)',
                      subtitle: '1-866-488-7386',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResourceTile extends StatelessWidget {
  final String title;
  final String subtitle;

  ResourceTile({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      onTap: () {
        // Implement what you want to happen when a resource is tapped
        // For example, you can launch a website or make a phone call.
      },
    );
  }
}
