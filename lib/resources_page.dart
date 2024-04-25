import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  'Resources for when in need',
                  style: TextStyle(
                    fontSize: 24,
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
                      url: 'tel:911', // Phone number URL
                    ),
                    ResourceTile(
                      title: 'Suicide Hotline',
                      subtitle: '1-800-273-TALK',
                      url: 'tel:1-800-273-8255', // Phone number URL
                    ),
                    ResourceTile(
                      title: 'National Domestic Violence Hotline',
                      subtitle: '1-800-799-SAFE',
                      url: 'tel:1-800-799-7233', // Phone number URL
                    ),
                    ResourceTile(
                      title:
                      'Substance Abuse and Mental Health Services Administration (SAMHSA)',
                      subtitle: '1-800-662-HELP',
                      url: 'tel:1-800-662-4357', // Phone number URL
                    ),
                    ResourceTile(
                      title: 'National Alliance on Mental Illness (NAMI)',
                      subtitle: '1-800-950-NAMI',
                      url: 'tel:1-800-950-6264', // Phone number URL
                    ),
                    ResourceTile(
                      title: 'Crisis Text Line',
                      subtitle: 'Text HOME to 741741',
                      url: 'sms:741741?body=HOME', // Crisis text line URL
                    ),
                    ResourceTile(
                      title: 'Veterans Crisis Line (Press 1)',
                      subtitle: '1-800-273-8255',
                      url: 'tel:1-800-273-8255', // Phone number URL
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
  final String url;

  ResourceTile({
    required this.title,
    required this.subtitle,
    required this.url,
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
        _launchResource(url);
      },
    );
  }

  // Function to launch URL
  void _launchResource(String url) async {
    try {
      await launch(url);
    } catch (e) {
      throw 'Could not launch $url';
    }
  }
}
